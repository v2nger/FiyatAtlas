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
}
