import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart'; 
// Note: Apple Sign In usually requires iOS/macOS setup or a service ID for Android/Web.
// For simplicity in this demo environment, we will structure it but might mock the actual call if needed.

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Google Sign In Configuration
  static const String? _webClientId = kIsWeb 
      ? '904641400932-sql9kfdqhgkr2ci89amk1809bbmc77up.apps.googleusercontent.com' 
      : null;
  bool _isGoogleInit = false;

  Future<void> _ensureGoogleInit() async {
    if (_isGoogleInit) return;
    try {
      await GoogleSignIn.instance.initialize(
        clientId: _webClientId,
      );
      _isGoogleInit = true;
    } catch (e) {
      debugPrint("Google Sign In Init Error: $e");
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User?> signInAnon() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      debugPrint("Anon Login Error: $e");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      if (!_isGoogleInit) await _ensureGoogleInit();
      
      const scopes = ['email', 'profile'];
      
      // 1. Authenticate (Sign In)
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate(
        scopeHint: scopes,
      );
      
      // 2. Get ID Token
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 3. Get Access Token (Authorization)
      // Note: authorizeScopes might require user interaction if not granted, 
      // but scopeHint above helps.
      final GoogleSignInClientAuthorization authClient = 
          await googleUser.authorizationClient.authorizeScopes(scopes);

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authClient.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint("Google Sign In Error: $e");
      return null;
    }
  }
  
  // Apple Sign In (Platform check required)
  Future<User?> signInWithApple() async {
      // Gerçek implementasyon için 'sign_in_with_apple' paketi ve yapılandırma gerekir.
      // Şimdilik yer tutucu olarak bırakıyoruz veya sadece bir hata fırlatmayacak şekilde yapılandırıyoruz.
      debugPrint("Apple Sign In tetiklendi (Mock)");
      return null;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      debugPrint("Email Login Error: $e");
      rethrow;
    }
  }

  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      debugPrint("Register Error: $e");
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("Password Reset Error: $e");
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    try {
      if (_isGoogleInit) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (_) {}
    await _auth.signOut();
  }
}
