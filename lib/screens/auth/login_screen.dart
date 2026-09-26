import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final VoidCallback? onAuthenticated;

  const LoginScreen({
    super.key,
    required this.authRepository,
    this.onAuthenticated,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await widget.authRepository.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) widget.onAuthenticated?.call();
    } on FormatException {
      if (mounted) {
        setState(
          () =>
              _errorMessage = AppLocalizations.of(context)!.invalidCredentials,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = AppLocalizations.of(context)!.loginFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l10n.email),
              validator: (value) => value == null || !value.contains('@')
                  ? l10n.invalidEmail
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.password),
              validator: (value) =>
                  value == null || value.length < 6 ? l10n.shortPassword : null,
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Semantics(
                liveRegion: true,
                child: Text(
                  _errorMessage!,
                  key: const Key('login-error'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 12),
            Semantics(
              button: true,
              label: l10n.loginAction,
              child: ElevatedButton(
                key: const Key('login-submit'),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(l10n.loginAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
