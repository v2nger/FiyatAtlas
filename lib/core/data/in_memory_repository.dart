import 'package:fiyatatlas/features/market/domain/market_branch.dart';
import 'package:fiyatatlas/features/price/domain/price_entry.dart';
import 'package:fiyatatlas/features/price/domain/price_status.dart';
import 'package:fiyatatlas/features/product/domain/entities/product.dart';

class InMemoryRepository {
  final List<Product> _products = [
    Product(
      barcode: '8690000000012',
      name: 'Süt 1L',
      brand: 'Sütçü',
      category: 'Süt ve Kahvaltılık',
    ),
    Product(
      barcode: '8690000000029',
      name: 'Tam Buğday Ekmek',
      brand: 'Fırıncı',
      category: 'Fırın',
    ),
  ];

  final List<MarketBranch> _branches = [
    MarketBranch(
      id: 'branch-001',
      chainName: 'Migros',
      branchName: 'Kadıköy Çarşı',
      city: 'İstanbul',
      district: 'Kadıköy',
      latitude: 40.9901,
      longitude: 29.0201,
    ),
    MarketBranch(
      id: 'branch-002',
      chainName: 'BİM',
      branchName: 'Koşuyolu',
      city: 'İstanbul',
      district: 'Kadıköy',
      latitude: 41.0053,
      longitude: 29.0345,
    ),
    MarketBranch(
      id: 'branch-003',
      chainName: 'A101',
      branchName: 'Üsküdar Merkez',
      city: 'İstanbul',
      district: 'Üsküdar',
      latitude: 41.0264,
      longitude: 29.0153,
    ),
  ];

  final List<PriceEntry> _entries = [
    PriceEntry(
      id: 'entry-001',
      barcode: '8690000000012',
      marketBranchId: 'branch-001',
      price: 42.5,
      currency: 'TRY',
      entryDate: DateTime.now().subtract(const Duration(hours: 5)),
      hasReceipt: true,
      isAvailable: true,
      status: PriceVerificationStatus.verifiedPublic,
    ),
    PriceEntry(
      id: 'entry-002',
      barcode: '8690000000029',
      marketBranchId: 'branch-002',
      price: 24.75,
      currency: 'TRY',
      entryDate: DateTime.now().subtract(const Duration(hours: 2)),
      hasReceipt: false,
      isAvailable: true,
      status: PriceVerificationStatus.pendingPrivate,
    ),
  ];

  List<Product> getProducts() => List.unmodifiable(_products);

  List<MarketBranch> getBranches() => List.unmodifiable(_branches);

  List<PriceEntry> getEntries() => List.unmodifiable(_entries);

  List<Product> searchProducts(String query) {
    final lower = query.toLowerCase();
    return _products.where((p) {
      return p.name.toLowerCase().contains(lower) ||
          p.barcode.contains(query) ||
          p.brand.toLowerCase().contains(lower);
    }).toList();
  }

  List<MarketBranch> searchBranches(String query) {
    if (query.isEmpty) return _branches;
    final lower = query.toLowerCase();
    return _branches.where((b) {
      return b.chainName.toLowerCase().contains(lower) ||
          b.branchName.toLowerCase().contains(lower) ||
          b.district.toLowerCase().contains(lower);
    }).toList();
  }

  void addBranch(MarketBranch branch) {
    _branches.add(branch);
  }

  void addEntry(PriceEntry entry) {
    _entries.insert(0, entry);
  }

  void replaceEntries(List<PriceEntry> entries) {
    _entries.clear();
    _entries.addAll(entries);
  }

  void updateEntry(PriceEntry updatedEntry) {
    final index = _entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      _entries[index] = updatedEntry;
    }
  }
}
