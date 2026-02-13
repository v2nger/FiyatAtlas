import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../app_state.dart';
import '../constants/agreements.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true; // Login vs Register mode
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _kvkkApproved = false;
  bool _userAgreementApproved = false;
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.read<AppState>();
    final isTr = appState.locale.languageCode == 'tr';

    final kvkkTitle = isTr 
      ? "KVKK Aydınlatma Metni'ni okudum ve kabul ediyorum."
      : "I have read and accept the Privacy Policy.";
    final kvkkLink = isTr ? "KVKK Aydınlatma Metni" : "Privacy Policy";
    
    final userAgreementTitle = isTr
      ? "Kullanıcı Sözleşmesi'ni okudum ve kabul ediyorum."
      : "I have read and accept the User Agreement.";
    final userAgreementLink = isTr ? "Kullanıcı Sözleşmesi" : "User Agreement";

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo & Title
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),

                // Language Switcher
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                         final current = appState.locale;
                         final newLocale = current.languageCode == 'tr' 
                             ? const Locale('en') 
                             : const Locale('tr');
                         appState.setLocale(newLocale);
                      },
                      icon: const Icon(Icons.language),
                      label: Text(appState.locale.languageCode.toUpperCase()),
                    ),
                  ],
                ),

                // Email & Password Fields
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.passwordLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                
                // Forgot Password
                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _showForgotPasswordDialog(context);
                      },
                      child: Text(l10n.forgotPassword),
                    ),
                  ),

                const SizedBox(height: 24),

                // Agreements
                _buildAgreementCheckbox(
                  title: kvkkTitle,
                  linkText: kvkkLink,
                  value: _kvkkApproved,
                  onChanged: (val) => setState(() => _kvkkApproved = val ?? false),
                  onLinkPressed: () => _showAgreementDialog(
                    context, 
                    isTr ? AppAgreements.kvkkTitleTR : AppAgreements.kvkkTitleEN, 
                    isTr ? AppAgreements.kvkkTextTR : AppAgreements.kvkkTextEN
                  ),
                ),
                _buildAgreementCheckbox(
                  title: userAgreementTitle,
                  linkText: userAgreementLink,
                  value: _userAgreementApproved,
                  onChanged: (val) => setState(() => _userAgreementApproved = val ?? false),
                  onLinkPressed: () => _showAgreementDialog(
                    context, 
                    isTr ? AppAgreements.userAgreementTitleTR : AppAgreements.userAgreementTitleEN, 
                    isTr ? AppAgreements.userAgreementTextTR : AppAgreements.userAgreementTextEN
                  ),
                ),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 16),

                // Main Action Button
                FilledButton(
                  onPressed: _isLoading ? null : () => _submit(context),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_isLogin ? l10n.login : l10n.register),
                ),

                const SizedBox(height: 16),
                
                // Toggle Login/Register
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = null;
                    });
                  },
                  child: Text(_isLogin 
                      ? "Hesabın yok mu? Kayıt Ol" 
                      : "Zaten hesabın var mı? Giriş Yap"),
                ),

                const SizedBox(height: 24),
                
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(l10n.orContinueWith, style: const TextStyle(color: Colors.grey)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Social Logins
                OutlinedButton.icon(
                  onPressed: () => _handleSocialLogin(context, 'google'),
                  icon: const Icon(Icons.g_mobiledata, size: 28), // Placeholder icon
                  label: Text(l10n.googleSignIn),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _handleSocialLogin(context, 'apple'),
                  icon: const Icon(Icons.apple, size: 28),
                  label: Text(l10n.appleSignIn),
                ),
                
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _handleGuestLogin(context),
                  child: Text(l10n.guestLogin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_validateAgreements(context)) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
        setState(() => _errorMessage = "Lütfen alanları doldurun."); // Localization needed here too properly
        return;
    }

    setState(() => _isLoading = true);
    final appState = context.read<AppState>();

    try {
      if (_isLogin) {
        await appState.loginWithEmail(email, password);
      } else {
        await appState.registerWithEmail(email, password);
      }
      
      if (mounted) {
        Navigator.pushReplacementNamed(this.context, '/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSocialLogin(BuildContext context, String provider) async {
    if (!_validateAgreements(context)) return;
    
    setState(() => _isLoading = true);
    final appState = context.read<AppState>();
    
    try {
      if (provider == 'google') {
        await appState.loginWithGoogle();
      } else if (provider == 'apple') {
        await appState.loginWithApple();
      }

      if (!mounted) return;

      // Check if actually logged in (user might have cancelled social login)
      if (appState.isLoggedIn) {
          Navigator.pushReplacementNamed(this.context, '/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
      final l10n = AppLocalizations.of(context)!;
      final dialogEmailController = TextEditingController(text: _emailController.text);

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.resetPasswordTitle), // "Şifre Sıfırlama"
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.resetPasswordDesc), // "E-posta girin..."
              const SizedBox(height: 16),
              TextField(
                controller: dialogEmailController,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final email = dialogEmailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    await context.read<AppState>().sendPasswordReset(email);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.resetLinkSent)),
                      );
                    }
                  } catch (e) {
                     // Error handling is inside AppState/AuthService but we might want to show it here
                     if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                     }
                  }
                }
              },
              child: Text(l10n.sendResetLink),
            ),
          ],
        ),
      );
  }

  Future<void> _handleGuestLogin(BuildContext context) async {
    if (!_validateAgreements(context)) return;

    setState(() => _isLoading = true);
    try {
      // Use the context from the build method to read the provider before the async gap
      final appState = context.read<AppState>();
      await appState.loginAnonymously();
       
       if (mounted) {
        // Use this.context (the State's context) after the async gap and mounted check
        Navigator.pushReplacementNamed(this.context, '/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _validateAgreements(BuildContext context) {
    if (!_kvkkApproved || !_userAgreementApproved) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.agreementsRequiredError;
      });
      return false;
    }
    setState(() => _errorMessage = null);
    return true;
  }

  Widget _buildAgreementCheckbox({
    required String title,
    required String linkText,
    required bool value,
    required Function(bool?) onChanged,
    required VoidCallback onLinkPressed,
  }) {
    final parts = title.split(linkText);
    final prefix = parts.isNotEmpty ? parts[0] : "";
    final suffix = parts.length > 1 ? parts[1] : "";

    return Row(
      children: [
        Checkbox(
          value: value, 
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 12),
              children: [
                TextSpan(text: prefix),
                TextSpan(
                  text: linkText,
                  style: const TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    decoration: TextDecoration.underline
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onLinkPressed,
                ),
                TextSpan(text: suffix),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAgreementDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }
}
