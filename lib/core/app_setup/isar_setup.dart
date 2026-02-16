// The common export file.
// On Mobile (dart.library.io) export the mobile implementation
// On Web (default) export the stub implementation
export 'isar_setup_stub.dart'
  if (dart.library.io) 'isar_setup_mobile.dart';
