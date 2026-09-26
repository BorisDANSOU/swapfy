import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../repositories/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final VoidCallback? onRegistered;

  const RegisterScreen({
    super.key,
    required this.authRepository,
    this.onRegistered,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      await widget.authRepository.register(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) widget.onRegistered?.call();
    } on FormatException {
      if (mounted) {
        setState(
          () => _errorMessage = AppLocalizations.of(context)!.registerFailed,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = AppLocalizations.of(context)!.registerFailed,
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
      appBar: AppBar(title: Text(l10n.registerTitle)),
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
                child: Text(_errorMessage!, key: const Key('register-error')),
              ),
            const SizedBox(height: 12),
            Semantics(
              button: true,
              label: l10n.registerAction,
              child: ElevatedButton(
                key: const Key('register-submit'),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(l10n.registerAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
