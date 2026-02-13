import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart'; 
// Note: Apple Sign In usually requires iOS/macOS setup or a service ID for Android/Web.
// For simplicity in this demo environment, we will structure it but might mock the actual call if needed.

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Web Client ID'yi buraya sabit olarak ekliyoruz.
  // Bu ID, google-services.json dosyasındaki "client_type": 3 olan android dışı client ID'dir.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb 
      ? '904641400932-sql9kfdqhgkr2ci89amk1809bbmc77up.apps.googleusercontent.com' 
      : null,
    scopes: ['email', 'profile'],
  );

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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Kullanıcı iptal etti

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
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
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
