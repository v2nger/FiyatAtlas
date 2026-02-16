class MarketBranch {
  MarketBranch({
    required this.id,
    required this.chainName,
    required this.branchName,
    required this.city,
    required this.district,
    this.latitude = 41.0082, // Default Istanbul
    this.longitude = 28.9784,
  });

  final String id;
  final String chainName;
  final String branchName;
  final String city;
  final String district;
  final double latitude;
  final double longitude;

  String get displayName => '$chainName - $branchName';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chainName': chainName,
      'branchName': branchName,
      'city': city,
      'district': district,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory MarketBranch.fromMap(Map<String, dynamic> map) {
    return MarketBranch(
      id: map['id'] ?? '',
      chainName: map['chainName'] ?? '',
      branchName: map['branchName'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }
}
