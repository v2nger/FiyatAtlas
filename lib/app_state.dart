import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'data/in_memory_repository.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/product_lookup_service.dart';
import 'models/market_branch.dart';
import 'models/price_entry.dart';
import 'models/price_status.dart';
import 'models/product.dart';
import 'models/user.dart';

class AppState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final ProductLookupService _productLookupService = ProductLookupService();
  final InMemoryRepository _repository;
  
  Locale _locale = const Locale('tr');
  Locale get locale => _locale;

  fb_auth.User? _firebaseUser;
  User? _localUser;

  bool get isLoggedIn => _firebaseUser != null;

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }

  Future<void> _fetchUserProfile() async {
    if (_firebaseUser == null) {
      _localUser = null;
      notifyListeners();
      return;
    }

    // Try fetch from Firestore
    User? fetchedUser = await _firestoreService.getUser(_firebaseUser!.uid);

    if (fetchedUser == null) {
      // First time login? Create user doc
      final newUser = User(
        id: _firebaseUser!.uid,
        name: _firebaseUser!.displayName ?? 'Kullanıcı',
        email: _firebaseUser!.email ?? '',
        avatarUrl: _firebaseUser!.photoURL ?? 'https://i.pravatar.cc/300?img=${_firebaseUser!.uid.hashCode % 70}',
        joinDate: DateTime.now(),
      );
      await _firestoreService.createUserIfNotExists(newUser);
      fetchedUser = newUser;
    }

    _localUser = fetchedUser;
    notifyListeners();
  }

  AppState({InMemoryRepository? repository})
      : _repository = repository ?? InMemoryRepository() {
    _authService.authStateChanges.listen((user) {
      _firebaseUser = user;
      _fetchUserProfile(); // Fetch real data when auth state changes
    });
  }

  // Current User Accessor
  User? get currentUser => _localUser;

  // Auth Methods
  Future<void> loginAnonymously() async {
    final user = await _authService.signInAnon();
    // Ensure we trigger update immediately
    if (user != null) {
        _firebaseUser = user;
    }
    await _fetchUserProfile();
  }

  Future<void> loginWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
        _firebaseUser = user;
    }
    await _fetchUserProfile();
  }

  Future<void> loginWithApple() async {
    final user = await _authService.signInWithApple();
     if (user != null) {
        _firebaseUser = user;
    }
    await _fetchUserProfile();
  }

  Future<void> loginWithEmail(String email, String password) async {
    final user = await _authService.signInWithEmailPassword(email, password);
    if (user != null) {
        _firebaseUser = user;
    }
    await _fetchUserProfile();
  }

  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> registerWithEmail(String email, String password) async {
    final user = await _authService.registerWithEmailPassword(email, password);
    if (user != null) {
        _firebaseUser = user;
    }
    // Note: Usually registering also sends verification email. We can trigger it if needed.
    await _authService.sendEmailVerification();
    // Create initial user doc immediately
    if (_firebaseUser != null) {
       final newUser = User(
        id: _firebaseUser!.uid,
        name: _firebaseUser!.displayName ?? 'Kullanıcı',
        email: _firebaseUser!.email ?? email,
        avatarUrl: _firebaseUser!.photoURL ?? 'https://i.pravatar.cc/300?img=${_firebaseUser!.uid.hashCode % 70}',
        joinDate: DateTime.now(),
      );
      await _firestoreService.createUserIfNotExists(newUser);
      await _fetchUserProfile();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  // --- Product Lookup & Creation ---

  /// 1. Checks Firestore (Verified & User-added)
  /// 2. If not found, checks APIs (OpenFoodFacts -> UPCitemdb)
  /// 3. If found in API, saves to Firestore as "Verified"
  /// 4. Returns null if product is completely new
  Future<Product?> lookupProduct(String barcode) async {
    try {
      // 1. Check our database first
      final existing = await _firestoreService.getProduct(barcode);
      if (existing != null) return existing;

      // 2. Check external APIs
      final apiProduct = await _productLookupService.lookupBarcode(barcode);
      if (apiProduct != null) {
        // 3. Save to our DB (Auto-verify API data)
        await _firestoreService.addProduct(apiProduct); 
        return apiProduct;
      }
    } catch (e) {
      debugPrint("Lookup failed: $e");
    }
    return null;
  }

  /// Adds a user-submitted product (Unverified initially)
  Future<void> addUserProduct(Product product) async {
    await _firestoreService.addProduct(product);
    // Ideally we'd also update local state if we were caching
    notifyListeners();
  }

  // Active User Session
  MarketBranch? _currentBranch;
  MarketBranch? get currentBranch => _currentBranch;

  void setCheckIn(MarketBranch? branch) {
    _currentBranch = branch;
    notifyListeners();
  }

  List<Product> get products => _repository.getProducts();

  List<MarketBranch> get branches => _repository.getBranches();

  List<PriceEntry> get entries => _repository.getEntries();

  void addPriceEntry({
    required String barcode,
    required String marketBranchId,
    required double price,
    required bool hasReceipt,
    required bool isAvailable,
  }) {
    final entry = PriceEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      barcode: barcode,
      marketBranchId: marketBranchId,
      price: price,
      currency: 'TRY',
      entryDate: DateTime.now(),
      hasReceipt: hasReceipt,
      isAvailable: isAvailable,
      status: hasReceipt
          ? PriceVerificationStatus.awaitingConsensus
          : PriceVerificationStatus.pendingPrivate,
    );
    _repository.addEntry(entry);

    // Update Mock User Stats
    if (_localUser != null) {
      _localUser = User(
        id: _localUser!.id,
        name: _localUser!.name,
        email: _localUser!.email,
        avatarUrl: _localUser!.avatarUrl,
        // Add Points
        points: _localUser!.points + 10,
        entryCount: _localUser!.entryCount + 1,
        rank: _localUser!.rank,
        joinDate: _localUser!.joinDate,
        earnedBadgeIds: _localUser!.earnedBadgeIds,
      );
      
      _checkBadges(entry); // Rozet kontrolü
    }

    notifyListeners();
  }

  void _checkBadges(PriceEntry newEntry) {
    if (_localUser == null) return;
    
    final currentBadges = _localUser!.earnedBadgeIds;
    final newBadges = <String>[];
    
    // Yardımcı fonksiyon: Kullanıcıda yoksa ve listeye henüz eklenmediyse ekle
    void unlock(String badgeId) {
      if (!currentBadges.contains(badgeId) && !newBadges.contains(badgeId)) {
        newBadges.add(badgeId);
      }
    }

    // --- 1. Seviye & Giriş Sayısı (Rütbe) ---
    final totalEntries = _localUser!.entryCount;
    
    if (totalEntries >= 1) unlock('acemi_kasif');
    if (totalEntries >= 10) unlock('cirak');
    if (totalEntries >= 50) unlock('kalfa');
    if (totalEntries >= 100) unlock('usta');
    if (totalEntries >= 250) unlock('ustat');
    if (totalEntries >= 500) unlock('efsane');
    if (totalEntries >= 1000) unlock('fiyat_makinesi');
    if (totalEntries >= 5000) unlock('atlas_efendisi');

    // --- 3. Teknoloji & Kanıt ---
    if (newEntry.barcode.length > 3) {
      final barcodeCount = entries.where((e) => e.barcode.length > 3).length;
      if (barcodeCount >= 10) unlock('barkodcu');
      if (barcodeCount >= 100) unlock('lazer_goz');
    } else {
      unlock('manuel_giris');
    }

    if (newEntry.hasReceipt) {
      final receiptCount = entries.where((e) => e.hasReceipt).length;
      if (receiptCount >= 10) unlock('fis_toplayici');
      if (receiptCount >= 50) unlock('foto_muhabiri');
    }

    // --- 4. Zaman Dilimi ---
    final hour = newEntry.entryDate.hour;
    if (hour >= 5 && hour < 8) unlock('erkenci_kus');
    if (hour >= 23 || hour < 5) unlock('gece_kusu');
    if (hour >= 12 && hour < 14) unlock('ogle_arasi');

    final weekday = newEntry.entryDate.weekday;
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      unlock('hafta_sonu'); 
    }
    
    if (newEntry.entryDate.month == 2 && newEntry.entryDate.day == 12) {
      unlock('dogum_gunu');
    }

    // --- 5. Reyon Uzmanlıkları ---
    try {
      final product = products.firstWhere((p) => p.barcode == newEntry.barcode);
      final cat = product.category.toLowerCase();
      
      if (cat.contains('süt') || cat.contains('peynir') || cat.contains('yoğurt')) unlock('sutcu');
      if (cat.contains('et') || cat.contains('tavuk') || cat.contains('kıyma')) unlock('kasap');
      if (cat.contains('meyve') || cat.contains('sebze') || cat.contains('domates')) unlock('manav');
      if (cat.contains('ekmek') || cat.contains('pasta') || cat.contains('un')) unlock('firinci');
      if (cat.contains('çikolata') || cat.contains('cips') || cat.contains('bisküvi') || cat.contains('abur')) unlock('keyifci');
      if (cat.contains('bebek') || cat.contains('mama') || cat.contains('bez')) unlock('bebek_dostu');
      if (cat.contains('deterjan') || cat.contains('temiz') || cat.contains('sabun')) unlock('titiz');
      if (cat.contains('şampuan') || cat.contains('krem') || cat.contains('diş') || cat.contains('kozmetik')) unlock('bakimli');
      if (cat.contains('su ') || cat.contains('gazoz') || cat.contains('ola') || cat.contains('içecek')) unlock('icecek_uzmani');
      if (cat.contains('kalem') || cat.contains('defter') || cat.contains('kağıt') || cat.contains('ofis')) unlock('kirtasiyeci');
      if (cat.contains('giyim') || cat.contains('pantolon') || cat.contains('tişört') || cat.contains('tekstil')) unlock('modaci');
      if (cat.contains('kedi') || cat.contains('köpek') || cat.contains('mama') || cat.contains('pet')) unlock('pati_dostu');
      if (cat.contains('pil') || cat.contains('şarj') || cat.contains('telefon') || cat.contains('elektronik')) unlock('teknoloji_kurdu');
      if (cat.contains('benzin') || cat.contains('mazot') || cat.contains('lpg') || cat.contains('akaryakıt')) unlock('sofor');
    } catch (_) {}

    // --- 6. Ekonomi & Fırsat ---
    if (newEntry.price.toString().endsWith('.99') || newEntry.price.toString().endsWith('.90')) {
       unlock('indirim_avcisi');
    }

    // --- 7. Keşif & Konum ---
    final uniqueChains = entries.map((e) {
       try {
         return branches.firstWhere((b) => b.id == e.marketBranchId).chainName;
       } catch (_) {
         return 'unknown';
       }
    }).toSet();
    uniqueChains.remove('unknown');
    if (uniqueChains.length >= 5) unlock('zincir_kiran');

    // Kullanıcı güncelleme
    if (newBadges.isNotEmpty) {
      _localUser = User(
        id: _localUser!.id,
        name: _localUser!.name,
        email: _localUser!.email,
        avatarUrl: _localUser!.avatarUrl,
        points: _localUser!.points + (newBadges.length * 50),
        rank: _localUser!.rank,
        entryCount: _localUser!.entryCount,
        joinDate: _localUser!.joinDate,
        earnedBadgeIds: [...currentBadges, ...newBadges],
      );
    }
  }

  List<Product> searchProducts(String query) =>
      _repository.searchProducts(query);

  List<MarketBranch> searchBranches(String query) =>
      _repository.searchBranches(query);

  void addMarketBranch({
    required String chainName,
    required String branchName,
    required String city,
    required String district,
  }) {
    final branch = MarketBranch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chainName: chainName,
      branchName: branchName,
      city: city,
      district: district,
    );
    _repository.addBranch(branch);
    notifyListeners();
  }

  void updateUser({String? name, String? avatarUrl}) {
    if (_localUser == null) return;
    _localUser = User(
      id: _localUser!.id,
      name: name ?? _localUser!.name,
      email: _localUser!.email,
      avatarUrl: avatarUrl ?? _localUser!.avatarUrl,
      points: _localUser!.points,
      rank: _localUser!.rank,
      entryCount: _localUser!.entryCount,
      earnedBadgeIds: _localUser!.earnedBadgeIds,
      joinDate: _localUser!.joinDate,
    );
    notifyListeners();
  }
}
