import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fiyatatlas/features/product/domain/product.dart';
import 'package:fiyatatlas/features/auth/domain/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Collection Names ---
  static const String _productsCol = 'products';
  static const String _usersCol = 'users';

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
}
