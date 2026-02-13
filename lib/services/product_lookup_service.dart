import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductLookupService {
  // Open Food Facts API (Free, No Key)
  static const String _offUrl = 'https://world.openfoodfacts.org/api/v2/product/';
  
  // UPCitemdb API (Free Trial, No Key)
  static const String _upcUrl = 'https://api.upcitemdb.com/prod/trial/lookup?upc=';

  Future<Product?> lookupBarcode(String barcode) async {
    // 1. Try Open Food Facts first (Best for Turkey/Food)
    Product? product = await _fetchFromOpenFoodFacts(barcode);
    if (product != null) return product;

    // 2. Try UPCitemdb (Backup for general items)
    product = await _fetchFromUPCitemdb(barcode);
    return product;
  }

  Future<Product?> _fetchFromOpenFoodFacts(String barcode) async {
    try {
      final response = await http.get(Uri.parse('$_offUrl$barcode.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          final p = data['product'];
          return Product(
            barcode: barcode,
            name: p['product_name'] ?? p['product_name_tr'] ?? 'Bilinmeyen Ürün',
            brand: p['brands'] ?? '',
            category: p['categories'] ?? '',
            imageUrl: p['image_url'],
            isVerified: true, // Trusted API source
            source: 'OpenFoodFacts',
          );
        }
      }
    } catch (e) {
      debugPrint("OpenFoodFacts Error: $e");
    }
    return null;
  }

  Future<Product?> _fetchFromUPCitemdb(String barcode) async {
    try {
      final response = await http.get(Uri.parse('$_upcUrl$barcode'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'OK' && (data['items'] as List).isNotEmpty) {
          final item = data['items'][0];
          return Product(
            barcode: barcode,
            name: item['title'] ?? '',
            brand: item['brand'] ?? '',
            category: item['category'] ?? '', // UPCitemdb categories can be long strings
            imageUrl: (item['images'] as List).isNotEmpty ? item['images'][0] : null,
            isVerified: true, // Trusted API source
            source: 'UPCitemdb',
          );
        }
      }
    } catch (e) {
       debugPrint("UPCitemdb Error: $e");
    }
    return null;
  }
}
