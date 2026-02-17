import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shared_providers.dart';
import '../../../auth/data/auth_service.dart';
import '../../../auth/domain/user.dart';

// Services
final authServiceProvider = Provider<AuthService>((ref) {
  // Assuming AuthService can be instantiated without deps or we inject them
  return AuthService(); // Check if AuthService needs deps
});

// Auth State (Firebase)
final authStateChangesProvider = StreamProvider<fb_auth.User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Domain User State
// This fetches the full user profile from Firestore whenever the Firebase User changes
final currentUserProvider = AsyncNotifierProvider<CurrentUserNotifier, User?>(
  CurrentUserNotifier.new,
);

class CurrentUserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // Wait for the auth state to be resolved (skip loading state)
    final firebaseUser = await ref.watch(authStateChangesProvider.future);

    if (firebaseUser == null) return null;
    return await _fetchOrCreateUser(firebaseUser);
  }

  Future<User> _fetchOrCreateUser(fb_auth.User firebaseUser) async {
    final firestoreService = ref.read(firestoreServiceProvider);

    // Try fetch
    User? user = await firestoreService.getUser(firebaseUser.uid);

    if (user == null) {
      // Create new
      user = User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'Kullanıcı',
        email: firebaseUser.email ?? '',
        avatarUrl:
            firebaseUser.photoURL ??
            'https://i.pravatar.cc/300?img=${firebaseUser.uid.hashCode % 70}',
        joinDate: DateTime.now(),
      );
      await firestoreService.createUserIfNotExists(user);
    }
    return user;
  }

  // Method to refresh user manually (e.g. after point update)
  Future<void> refresh() async {
    // Invalidate self will cause rebuild
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateProfile({String? name, String? avatarUrl}) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(name: name, avatarUrl: avatarUrl);

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.updateUser(updatedUser);

    // Refresh local state
    refresh();
  }
}


// God Mode Check
final isGodProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(authStateChangesProvider.future);
  if (user == null) return false;

  try {
    // Force refresh to ensure we get the latest claims
    final idTokenResult = await user.getIdTokenResult(true);
    return idTokenResult.claims?['god'] == true;
  } catch (e) {
    return false;
  }
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});

class AuthController {
  final AuthService _authService;

  AuthController(this._authService);

  Future<void> signInAnonymously() async => _authService.signInAnon();
  Future<void> signInWithGoogle() async => _authService.signInWithGoogle();
  Future<void> signInWithApple() async => _authService.signInWithApple();
  Future<void> signOut() async => _authService.signOut();

  Future<void> signInWithEmail(String email, String password) async {
    await _authService.signInWithEmailPassword(email, password);
  }

  Future<void> registerWithEmail(String email, String password) async {
    await _authService.registerWithEmailPassword(email, password);
    // User creation is handled by the currentUserProvider watching the stream
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }
}
