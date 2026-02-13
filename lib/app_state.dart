import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'core/data/in_memory_repository.dart';
import 'features/auth/data/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'features/product/data/product_lookup_service.dart';
import 'features/market/domain/market_branch.dart';
import 'features/price/domain/price_entry.dart';
import 'features/price/domain/price_status.dart';
import 'features/product/domain/product.dart';
import 'features/auth/domain/user.dart';

import 'features/price/domain/price_repository.dart';
import 'features/price/data/price_repository_impl.dart';
import 'features/gamification/domain/gamification_service.dart';
import 'features/price/domain/usecases/log_price_use_case.dart';
import 'features/market/domain/market_repository.dart';
import 'features/market/data/market_repository_impl.dart';
import 'features/price/domain/consensus_service.dart';

class AppState extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  final ProductLookupService _productLookupService = ProductLookupService();
  final InMemoryRepository _repository;
  
  // Clean Architecture Components
  late final PriceRepository _priceRepository;
  late final MarketRepository _marketRepository;
  late final GamificationService _gamificationService;
  late final ConsensusService _consensusService;
  late final LogPriceUseCase _logPriceUseCase;
  
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
    
    // Initial Data Load
    await _reloadEntries();
    
    notifyListeners();
  }

  Future<void> _reloadEntries() async {
    _repository.replaceEntries(recent);
    
    // Also reload branches (Assuming small list for MVP)
    final branches = await _marketRepository.getAllBranches();
    // Helper to replace branches in repo (need to add this to InMemoryRepository)
    // For now assuming we just add them or I need to update InMemoryRepository
    // Let's implement setBranches in Repo or just iterate add.
    // _repository.setBranches(branches); // Need to add this
    for (var b in branches) {
       // Avoid duplicates if already in memory (simple check)
       if (_repository.getBranches().every((existing) => existing.id != b.id)) {
          _repository.addBranch(b);
       }
    }
    
    notifyListeners();
  }

  AppState({
    InMemoryRepository? repository,
    AuthService? authService,
    FirestoreService? firestoreService,
  })  : _repository = repository ?? InMemoryRepository(),
        _authService = authService ?? AuthService(),
        _firestoreService = firestoreService ?? FirestoreService() {
          
    // Initialize Domain Layer
    _priceRepository = PriceRepositoryImpl(_firestoreService);
    _marketRepository = MarketRepositoryImpl(_firestoreService);
    _gamificationService = GamificationService();
    _consensusService = ConsensusService();
    _logPriceUseCase = LogPriceUseCase(
        _priceRepository, 
        _gamificationService,
        _consensusService
    );

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

  Future<void> addPriceEntry({
    required String barcode,
    required String marketBranchId,
    required double price,
    required bool hasReceipt,
    required bool isAvailable,
  }) async {
    if (_localUser == null) return;

    try {
      // Execute Domain Use Case
      // This encapsulates: Persistence, Gamification Logic, Status Determination
      final updatedUser = await _logPriceUseCase.execute(
        currentUser: _localUser!,
        barcode: barcode,
        marketBranchId: marketBranchId,
        price: price,
        hasReceipt: hasReceipt,
        isAvailable: isAvailable,
        allProducts: _repository.getProducts(), // Or fetch from Repo
        allBranches: _repository.getBranches(), // Or fetch from Repo
        userPastEntries: _repository.getEntries(), // History needed for badges
      );

      // Local UI Updates
      if (updatedUser != null) {
        _localUser = updatedUser;
        // Ideally we should sync this updatedUser to Firestore here too or in the UseCase
        // The UseCase currently only returns the object, it didn't save the User update to DB.
        // For MVP, we'll assume firestore user update happens or we add it to use case next.
        // Let's stick to memory update + existing flow.
      }
      
      // Refresh list to show new entry (which was added to Firestore by UseCase)
      // We manually add it to local repo for instant feedback, 
      // or rely on _reloadEntries() call.
      // Let's assume we want instant feedback:
      final newEntry = PriceEntry(
         id: 'temp-${DateTime.now().millisecondsSinceEpoch}', // Will be overwritten on reload
         userId: _localUser!.id,
         barcode: barcode,
         marketBranchId: marketBranchId,
         price: price,
         currency: 'TRY',
         entryDate: DateTime.now(),
         hasReceipt: hasReceipt,
         isAvailable: isAvailable,
         status: PriceVerificationStatus.pendingPrivate,
      );
      _repository.addEntry(newEntry);
      
      notifyListeners();

    } catch (e) {
      debugPrint("AddPriceEntry error: $e");
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    return _firestoreService.searchProducts(query);
  }

  // Note: Firestore implementation for searchBranches is pending, using repo for now or empty?
  // Ideally we need text search on markets collection. 
  // For now let's leave it using _repository or implement simple firestore query
  List<MarketBranch> searchBranches(String query) =>
      _repository.searchBranches(query); // Keeping local for now

  Future<void> addMarketBranch({
    required String chainName,
    required String branchName,
    required String city,
    required String district,
  }) async {
    final branch = MarketBranch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chainName: chainName,
      branchName: branchName,
      city: city,
      district: district,
    );
     // Write to Firestore via UseCase or Repo
    await _marketRepository.addBranch(branch);
    
    // Also update local repo for immediate feedback if needed, 
    // though real apps usually refetch or listen to streams.
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
