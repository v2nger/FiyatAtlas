import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fiyatatlas/features/product/domain/product.dart';
import 'package:fiyatatlas/features/auth/domain/user.dart';
import 'package:fiyatatlas/features/market/domain/market_branch.dart';
import 'package:fiyatatlas/features/price/domain/price_entry.dart';
import 'package:fiyatatlas/features/price/domain/price_status.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Collection Names ---
  static const String _usersCol = 'users';
  static const String _productsCol = 'products';
  static const String _marketsCol = 'markets';
  static const String _priceLogsCol = 'price_logs';
  static const String _verifiedPricesCol = 'verified_prices';

  // --- Users ---
  
  Future<void> createUserIfNotExists(User user) async {
    final docRef = _db.collection(_usersCol).doc(user.id);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set(user.toMap());
    }
  }

  Future<User?> getUser(String uid) async {
    try {
      final doc = await _db.collection(_usersCol).doc(uid).get();
      if (doc.exists) {
        return User.fromSnapshot(doc);
      }
    } catch (e) {
      debugPrint("GetUser Error: $e");
    }
    return null;
  }
  
  // --- Products ---

  Future<Product?> getProduct(String barcode) async {
    try {
      final doc = await _db.collection(_productsCol).doc(barcode).get();
      if (doc.exists && doc.data() != null) {
        return Product.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint("Firestore getProduct error: $e");
    }
    return null; // Not found in our database
  }

  Future<void> addProduct(Product product) async {
    try {
      // If it's verified (from API), save directly to products
      if (product.isVerified) {
        await _db.collection(_productsCol).doc(product.barcode).set(product.toMap());
      } else {
        // If it's user suggested, save to pending_products for review
        // For MVP, we can save to products but mark as unverified
        await _db.collection(_productsCol).doc(product.barcode).set(product.toMap());
      }
    } catch (e) {
      debugPrint("Firestore addProduct error: $e");
      rethrow;
    }
  }

  // --- Search ---
  
  // Basic search by name prefix (case-sensitive in Firestore usually, needs workaround for robust search)
  Future<List<Product>> searchProducts(String query) async {
    try {
      final snap = await _db.collection(_productsCol)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .limit(10)
          .get();
      
      return snap.docs.map((doc) => Product.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint("Search error: $e");
      return [];
    }
  }

  // --- Markets ---

  Future<void> addMarketBranch(MarketBranch branch) async {
    try {
      await _db.collection(_marketsCol).doc(branch.id).set(branch.toMap());
    } catch (e) {
      debugPrint("addMarketBranch error: $e");
      rethrow;
    }
  }

  Future<List<MarketBranch>> getMarketBranches() async {
    try {
      final snap = await _db.collection(_marketsCol).get();
      return snap.docs.map((doc) => MarketBranch.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint("getMarketBranches error: $e");
      return [];
    }
  }

  // --- Price Logs & Verification ---

  Future<void> logPriceEntry(PriceEntry entry) async {
    try {
      // 1. Add to Append-Only Log
      await _db.collection(_priceLogsCol).add(entry.toMap());
      // Note: We no longer auto-update verified prices here. 
      // That is now handled by the Consensus Engine.
    } catch (e) {
      debugPrint("logPriceEntry error: $e");
      rethrow;
    }
  }

  /// Called by Consensus Engine when a price is deemed trustworthy enough for public view
  Future<void> updateVerifiedPrice({
    required String barcode,
    required String marketId,
    required double price,
    required double confidenceScore,
    required int confirmationCount,
  }) async {
    try {
      // Key schema: verified_prices/{barcode}_{marketId}
      final docId = '${barcode}_${marketId}';
      
      await _db.collection(_verifiedPricesCol).doc(docId).set({
        'barcode': barcode,
        'price': price,
        'marketId': marketId,
        'updatedAt': DateTime.now().toIso8601String(),
        'status': PriceVerificationStatus.verifiedPublic.name, 
        'confidenceScore': confidenceScore,
        'confirmationCount': confirmationCount,
      });
    } catch (e) {
      debugPrint("updateVerifiedPrice error: $e");
    }
  }

  Future<List<PriceEntry>> getLogHistoryForConsensus(String barcode, String marketId, DateTime since) async {
    try {
      final snap = await _db.collection(_priceLogsCol)
          .where('barcode', isEqualTo: barcode)
          .where('marketBranchId', isEqualTo: marketId)
          .where('entryDate', isGreaterThanOrEqualTo: since.toIso8601String())
          .get();
          
      return snap.docs.map((doc) => PriceEntry.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint("getLogHistoryForConsensus error: $e");
      return [];
    }
  }

  Future<List<PriceEntry>> getRecentPriceLogs({int limit = 20}) async {
    try {
      final snap = await _db.collection(_priceLogsCol)
          .orderBy('entryDate', descending: true)
          .limit(limit)
          .get();
      
      return snap.docs.map((doc) => PriceEntry.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint("getRecentPriceLogs error: $e");
      return [];
    }
  }
}
