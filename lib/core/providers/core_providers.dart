import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/data/auth_service.dart';
import '../services/firestore_service.dart';
import '../../features/product/data/product_lookup_service.dart';
import '../data/in_memory_repository.dart';
import '../../features/verification/data/verification_service.dart';

part 'core_providers.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

@riverpod
FirestoreService firestoreService(FirestoreServiceRef ref) {
  return FirestoreService();
}

@riverpod
ProductLookupService productLookupService(ProductLookupServiceRef ref) {
  return ProductLookupService();
}

@riverpod
InMemoryRepository inMemoryRepository(InMemoryRepositoryRef ref) {
  return InMemoryRepository();
}

@riverpod
VerificationService verificationService(VerificationServiceRef ref) {
  final repo = ref.watch(inMemoryRepositoryProvider);
  return VerificationService(repo);
}
