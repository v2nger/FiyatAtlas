class Product {
  final String barcode;
  final String name;
  final String brand;
  final String category;
  final String? imageUrl;
  final bool isVerified; // Approved by admin or authoritative source (API)
  final String? source; // "OpenFoodFacts", "UPCitemdb", "User"

  // Auditing
  final DateTime? createdAt;
  final String? createdBy;

  // Use barcode as ID
  String get id => barcode;

  Product({
    required this.barcode,
    required this.name,
    required this.brand,
    this.category = "Diğer",
    this.imageUrl,
    this.isVerified = false,
    this.source,
    this.createdAt,
    this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'category': category,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
      'source': source,
      'createdAt': createdAt?.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      barcode: map['barcode'] ?? '',
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      category: map['category'] ?? 'Diğer',
      imageUrl: map['imageUrl'],
      isVerified: map['isVerified'] ?? false,
      source: map['source'],
    );
  }
}
