import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onRequest } from "firebase-functions/v2/https";
import { Timestamp } from "firebase-admin/firestore";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

admin.initializeApp();
const db = admin.firestore();

/* ============================================================
   GOD MODE (Hard + Claim Based)
============================================================ */

const GOD_UIDS = [
  "QHhUDWdNQYYjOJnLUIiNLXtGCqn2",
  "mUYjSwDcr5aTa5ghV7sJCWSRec52",
];

async function isGod(uid?: string): Promise<boolean> {
  if (!uid) return false;

  // Hard whitelist
  if (GOD_UIDS.includes(uid)) return true;

  // Claim fallback
  try {
    const user = await admin.auth().getUser(uid);
    return user.customClaims?.god === true;
  } catch {
    return false;
  }
}

/* ============================================================
   CONFIDENCE ENGINE
============================================================ */

export const confidenceEngine = onDocumentWritten(
  { document: "price_logs/{logId}", region: "us-central1" },
  async (event) => {
    const before = event.data?.before?.data();
    const after = event.data?.after?.data();
    if (!after) return;

    const { product_id, market_id, user_id, price } = after;

    /* ================= GOD FORCE VERIFY ================= */

    if (await isGod(user_id)) {
      await db.collection("verified_prices")
        .doc(`${product_id}_${market_id}`)
        .set({
          product_id,
          market_id,
          verified_price: price,
          confidence: 100,
          sample_size: 1,
          forced_by_god: true,
          verified_at: Timestamp.now(),
        }, { merge: true });

      await event.data?.after?.ref.update({
        status: "verified",
        confidence_score: 100,
      });

      logger.info("God forced verification", { user_id });
      return;
    }

    /* ================= BASIC FILTERS ================= */

    if (after.abuse_flag) return;
    if (before?.status === "verified") return;

    const ownerSnap = await db.collection("users").doc(user_id).get();
    if (ownerSnap.exists && ownerSnap.data()?.shadow_banned) return;

    const sevenDaysAgo = Timestamp.fromDate(
      new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
    );

    const snapshot = await db.collection("price_logs")
      .where("product_id", "==", product_id)
      .where("market_id", "==", market_id)
      .where("timestamp", ">=", sevenDaysAgo)
      .get();

    if (snapshot.empty) return;

    const logs = snapshot.docs.map(d => ({
      id: d.id,
      ...d.data()
    })) as any[];

    // Unique by user
    const uniqueMap = new Map<string, any>();
    logs.forEach(l => {
      if (!uniqueMap.has(l.user_id)) {
        uniqueMap.set(l.user_id, l);
      }
    });

    const uniqueLogs = Array.from(uniqueMap.values());
    if (uniqueLogs.length < 2) return;

    /* ================= TRUST WEIGHT ================= */

    const userSnaps = await Promise.all(
      uniqueLogs.map(l => db.collection("users").doc(l.user_id).get())
    );

    let weightedTrust = 0;
    let weightTotal = 0;
    const filteredLogs: any[] = [];

    for (const log of uniqueLogs) {
      const snap = userSnaps.find(s => s.id === log.user_id);
      if (!snap?.exists) continue;

      const data = snap.data();
      if (data?.shadow_banned) continue;

      filteredLogs.push(log);

      const trust = data?.trust_score || 50;
      const tier = data?.reputation_tier_current || "Bronze";

      let multiplier = 1;
      if (tier === "Atlas") multiplier = 1.2;
      if (tier === "Gold") multiplier = 1.1;
      if (tier === "Silver") multiplier = 1.05;

      weightedTrust += trust * multiplier;
      weightTotal += multiplier;
    }

    if (filteredLogs.length < 2) return;

    const prices = filteredLogs.map(l => l.price);
    const median = calculateMedian(prices);

    const avgTrust =
      weightTotal > 0 ? weightedTrust / weightTotal : 50;

    let score = 30;
    score += Math.min(filteredLogs.length * 12, 36);
    score += avgTrust * 0.25;
    score = Math.max(0, Math.min(100, score));

    const status =
      score >= 75 ? "verified" :
      score >= 55 ? "pending" :
      "private";

    await updateStatuses(filteredLogs, status, score);

    if (status === "verified") {
      await db.collection("verified_prices")
        .doc(`${product_id}_${market_id}`)
        .set({
          product_id,
          market_id,
          verified_price: median,
          confidence: score,
          sample_size: filteredLogs.length,
          verified_at: Timestamp.now(),
        }, { merge: true });
    }

    logger.info("Confidence calculated", { score });
  }
);

/* ============================================================
   TRUST DECAY + TIER ENGINE (God Immune)
============================================================ */

export const trustDecayEngine = onSchedule(
  { schedule: "every 24 hours", region: "us-central1" },
  async () => {

    const snapshot = await db.collection("users").get();
    const batch = db.batch();
    const now = Date.now();

    snapshot.forEach(doc => {

      if (GOD_UIDS.includes(doc.id)) return;

      const data = doc.data();

      let trust = data.trust_score || 50;
      const shadow = data.shadow_banned || false;
      const verified = data.verified_submissions || 0;
      const total = data.total_submissions || 0;
      const lastSubmission = data.last_submission_at?.toDate();

      if (shadow) trust -= 5;

      if (lastSubmission) {
        const days =
          (now - lastSubmission.getTime()) /
          (1000 * 60 * 60 * 24);

        if (days > 60) trust -= 6;
        else if (days > 30) trust -= 4;
        else if (days > 7) trust -= 2;
      }

      if (total >= 5) {
        const ratio = verified / total;
        if (ratio < 0.3) trust -= 3;
        if (ratio < 0.15) trust -= 6;
      }

      trust = Math.max(0, Math.min(100, trust));

      batch.update(doc.ref, { trust_score: trust });
    });

    await batch.commit();
    logger.info("Trust decay executed");
  }
);

/* ============================================================
   SEASON RESET (Yearly)
============================================================ */

export const seasonResetEngine = onSchedule(
  { schedule: "0 0 1 1 *", region: "us-central1" },
  async () => {

    const snapshot = await db.collection("users").get();
    const batch = db.batch();

    snapshot.forEach(doc => {
      if (GOD_UIDS.includes(doc.id)) return;

      batch.update(doc.ref, {
        season_total: 0,
        season_verified: 0,
        reputation_tier_current: "Bronze",
        season_year: new Date().getFullYear(),
      });
    });

    await batch.commit();
    logger.info("Season reset executed");
  }
);

/* ============================================================
   HELPERS
============================================================ */

function calculateMedian(values: number[]): number {
  const sorted = [...values].sort((a,b)=>a-b);
  const mid = Math.floor(sorted.length/2);
  return sorted.length%2!==0
    ? sorted[mid]
    : (sorted[mid-1]+sorted[mid])/2;
}

async function updateStatuses(
  logs: any[],
  status: string,
  confidence: number
){
  const batch = db.batch();

  logs.forEach((log:any)=>{
    const ref = db.collection("price_logs").doc(log.id);
    batch.update(ref, {
      status,
      confidence_score: confidence
    });
  });

  await batch.commit();
}

/* ============================================================
   PRODUCT CREATION
============================================================ */

export const createProduct = onCall({ region: "us-central1" }, async (request: any) => {
  // 1. Authentication Check
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "The user must be authenticated to create a product."
    );
  }

  const { barcode, name, brand, imageUrl } = request.data;
  const uid = request.auth.uid;
  const isGodUser = await isGod(uid);

  // 2. Data Validation
  if (!barcode || typeof barcode !== "string") {
    throw new HttpsError("invalid-argument", "The function must be called with a valid barcode.");
  }
  if (!name || typeof name !== "string") {
    throw new HttpsError("invalid-argument", "The function must be called with a valid name.");
  }

  // 3. Check Existence
  const productRef = db.collection("products").doc(barcode);
  const existingDoc = await productRef.get();

  if (existingDoc.exists) {
    return { success: true, message: "Product already exists", productId: barcode };
  }

  // 4. Create Product
  const newProduct = {
    barcode: barcode,
    name: name,
    brand: brand || "",
    category: "Diğer",
    imageUrl: imageUrl || null,
    isVerified: isGodUser, // God Mode: Auto-verify
    source: isGodUser ? "God" : "User",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    createdBy: uid,
    searchKeywords: generateKeywords(name, brand, barcode),
  };

  await productRef.set(newProduct);

  logger.info("Product created", { barcode });

  return { success: true, productId: barcode };
});

function generateKeywords(name: string, brand?: string, barcode?: string): string[] {
  const keywords: string[] = [];
  
  const addKeywords = (text?: string) => {
    if (!text) return;
    text.toLowerCase().split(/\s+/).forEach(word => {
      if (word.length > 2) keywords.push(word);
    });
  };

  addKeywords(name);
  addKeywords(brand);
  if (barcode) keywords.push(barcode);

  return [...new Set(keywords)];
}

/* ============================================================
   GOD MODE SYNC (Badges & Stats)
============================================================ */

const ALL_BADGE_IDS = [
  // 1. Level & Entry
  "acemi_kasif", "cirak", "kalfa", "usta", "ustat", "efsane", "fiyat_makinesi", "atlas_efendisi",
  // 2. Loyalty
  "alev_alan", "maratoncu", "sadik_dost", "takvim_yapragi", "geri_dondu",
  // 3. Tech & Proof
  "barkodcu", "lazer_goz", "fis_toplayici", "foto_muhabiri", "onayli_kaynak", "manuel_giris",
  // 4. Time
  "erkenci_kus", "gece_kusu", "ogle_arasi", "hafta_sonu", "dogum_gunu",
  // 5. Category
  "sutcu", "kasap", "manav", "firinci", "keyifci", "bebek_dostu", "titiz", "bakimli", 
  "icecek_uzmani", "kirtasiyeci", "modaci", "pati_dostu", "teknoloji_kurdu", "sofor",
  // 6. Economy
  "indirim_avcisi", "vurgun", "dip_fiyat", "zam_habercesi", "enflasyon_canavari",
  // 7. Discovery
  "mahalleli", "gezgin", "seyyah", "zincir_kiran", "bakkal_amca",
  // 8. Social
  "davetkar", "yorumcu", "dedektif", "hakim", "lider", "egitmen"
];


export const godModeSync = onSchedule(
  { schedule: "every 60 minutes", region: "us-central1" },
  async () => {
    const batch = db.batch();
    
    for (const uid of GOD_UIDS) {
      const userRef = db.collection("users").doc(uid);
      
      batch.set(userRef, {
        trust_score: 100,
        reputation_tier_current: "Atlas",
        verified_submissions: 9999, // Status symbol
        total_submissions: 9999,
        earnedBadgeIds: ALL_BADGE_IDS,
        is_god: true,
        role: "admin", // Ensure role is admin
      }, { merge: true });
    }

    await batch.commit();
    logger.info("God Mode Sync Executed", { count: GOD_UIDS.length });
  }
);
