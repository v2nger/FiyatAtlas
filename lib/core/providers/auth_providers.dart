import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_providers.dart';
import '../../features/auth/domain/user.dart';

part 'auth_providers.g.dart';

/// Provides the raw FirebaseAuth user stream
@riverpod
Stream<fb_auth.User?> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

/// Provides the current application user (User model from domain)
/// logic taken from AppState._fetchUserProfile
@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  FutureOr<User?> build() async {
    // Watch the Firebase Auth state
    final firebaseUser = await ref.watch(authStateChangesProvider.future);

    if (firebaseUser == null) {
      return null;
    }

    final firestoreService = ref.read(firestoreServiceProvider);

    // Try fetch from Firestore
    User? fetchedUser = await firestoreService.getUser(firebaseUser.uid);

    if (fetchedUser == null) {
      // Create user doc if not exists (First time login logic)
      final newUser = User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'Kullanıcı',
        email: firebaseUser.email ?? '',
        avatarUrl: firebaseUser.photoURL ?? 
            'https://i.pravatar.cc/300?img=${firebaseUser.uid.hashCode % 70}',
        joinDate: DateTime.now(),
      );
      await firestoreService.createUserIfNotExists(newUser);
      fetchedUser = newUser;
    }

    return fetchedUser;
  }
  
  // Method to manually refresh user profile
  Future<void> refresh() async {
      ref.invalidateSelf();
      await future; 
  }
}
