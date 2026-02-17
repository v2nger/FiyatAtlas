import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google Sign In Configuration
  // Web Client ID from Google Cloud Console (OAuth 2.0 Client IDs -> Web application)
  static const String? _webClientId = kIsWeb
      ? '904641400932-sql9kfdqhgkr2ci89amk1809bbmc77up.apps.googleusercontent.com'
      : null;

  AuthService();

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
      // 1. Trigger the authentication flow
      // GoogleSignIn singleton instance kullanımı
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: _webClientId,
        scopes: ['email', 'profile'],
      );
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create a new credential
      // accessToken ARTIK KULLANILMIYOR (v7+)
      // idToken yeterlidir.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: null, 
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint("Google Sign In Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // Ignored
      }
    } catch (e) {
      debugPrint("Sign Out Error: $e");
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
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      debugPrint("Email Login Error: $e");
      rethrow;
    }
  }

  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
}
