import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { Timestamp } from "firebase-admin/firestore";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

admin.initializeApp();
const db = admin.firestore();

/* ================= GOD MODE ================= */

const GOD_UID = "mUYjSwDcr5aTa5ghV7sJCWSRec52";

function isGod(uid?: string) {
  return uid === GOD_UID;
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
    if (after.abuse_flag) return;
    if (before?.status === "verified") return;

    const { product_id, market_id, user_id } = after;

    /* ===== GOD FORCE VERIFY ===== */

    if (isGod(user_id)) {
      await db.collection("verified_prices")
        .doc(`${product_id}_${market_id}`)
        .set({
          product_id,
          market_id,
          verified_price: after.price,
          confidence: 100,
          sample_size: 1,
          forced_by_god: true,
          verified_at: Timestamp.now(),
        }, { merge: true });

      await event.data?.after?.ref.update({
        status: "verified",
        confidence_score: 100,
      });

      return;
    }

    /* ===== SHADOW CHECK ===== */

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

    const logs = snapshot.docs.map(d => d.data());

    const uniqueMap = new Map();
    logs.forEach((l: any) => {
      if (!uniqueMap.has(l.user_id)) {
        uniqueMap.set(l.user_id, l);
      }
    });

    const uniqueLogs = Array.from(uniqueMap.values());
    if (uniqueLogs.length < 2) return;

    const userSnaps = await Promise.all(
      uniqueLogs.map((l: any) =>
        db.collection("users").doc(l.user_id).get()
      )
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

    const prices = filteredLogs.map((l: any) => l.price);
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
   TRUST DECAY (God Immune)
============================================================ */

export const trustDecayEngine = onSchedule(
  { schedule: "every 24 hours", region: "us-central1" },
  async () => {

    const snapshot = await db.collection("users").get();
    const batch = db.batch();

    snapshot.forEach(doc => {

      if (doc.id === GOD_UID) return;

      const data = doc.data();
      let trust = data.trust_score || 50;
      const shadow = data.shadow_banned || false;

      if (shadow) trust -= 5;

      trust = Math.max(0, Math.min(100, trust));

      batch.update(doc.ref, { trust_score: trust });
    });

    await batch.commit();
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
  logs.forEach((log: any)=>{
    const ref = db.collection("price_logs").doc(log.id);
    batch.update(ref, { status, confidence_score: confidence });
  });
  await batch.commit();
}
