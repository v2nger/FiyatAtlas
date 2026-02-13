import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_state.dart';

/// Legacy AppState exposed as a Riverpod provider.
/// This allows gradual migration from Provider to Riverpod.
final appStateProvider = ChangeNotifierProvider<AppState>((ref) {
  return AppState();
});
