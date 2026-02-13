// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateChangesHash() => r'24ccea72693bd761695a193bf44e03365e8811b2';

/// Provides the raw FirebaseAuth user stream
///
/// Copied from [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider =
    AutoDisposeStreamProvider<fb_auth.User?>.internal(
      authStateChanges,
      name: r'authStateChangesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authStateChangesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateChangesRef = AutoDisposeStreamProviderRef<fb_auth.User?>;
String _$currentUserHash() => r'd11edd233d6e01e39e8f91bb7a84c35e06ce7e51';

/// Provides the current application user (User model from domain)
/// logic taken from AppState._fetchUserProfile
///
/// Copied from [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider =
    AutoDisposeAsyncNotifierProvider<CurrentUser, User?>.internal(
      CurrentUser.new,
      name: r'currentUserProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentUserHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentUser = AutoDisposeAsyncNotifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
