import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/repository.dart';
import '../theme.dart';
import '../widgets/flavor.dart';

/// Simple front-door auth for the proposal demo. Credentials are not
/// verified against any backend — any valid-looking input signs in — but
/// the flow, validation and session gate are real.
class AuthScreen extends StatefulWidget {
  final VoidCallback onSignedIn;

  const AuthScreen({super.key, required this.onSignedIn});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _signUp = false;
  bool _obscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 500));
    await Session.instance.signIn(
        _email.text.trim(), _signUp ? _name.text.trim() : null);
    if (!mounted) return;
    widget.onSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Branded gradient header with logo + value proposition.
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(gradient: GfGradients.hero),
            padding: EdgeInsets.fromLTRB(
                28, MediaQuery.paddingOf(context).top + 48, 28, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/images/brand/logo.svg',
                    height: 28,
                    colorFilter: const ColorFilter.mode(
                        GfColors.white, BlendMode.srcIn)),
                const SizedBox(height: 28),
                const Eyebrow('Digital Product Catalogue',
                    color: GfColors.lightBlue),
                const SizedBox(height: 10),
                const Text('The catalogue,\nin your pocket.',
                    style: TextStyle(
                        fontFamily: 'Grundfos-Extd',
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        height: 1.15,
                        color: GfColors.white)),
                const SizedBox(height: 12),
                Text(
                  'Every Grundfos pump, spec and performance curve — '
                  'replacing the heavy printed books with a fast, searchable '
                  'digital catalogue.',
                  style: TextStyle(
                      fontSize: 14.5,
                      height: 1.5,
                      color: GfColors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_signUp ? 'Create your account' : 'Sign in',
                        style: const TextStyle(
                            fontFamily: 'Grundfos-Extd',
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: GfColors.ink)),
                    const SizedBox(height: 20),
                    if (_signUp) ...[
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                            labelText: 'Full name',
                            prefixIcon: Icon(Icons.person_outline)),
                        textInputAction: TextInputAction.next,
                        validator: (v) => _signUp && (v == null || v.trim().isEmpty)
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                          labelText: 'Work email',
                          prefixIcon: Icon(Icons.mail_outline)),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return 'Enter your email';
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'At least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: GfColors.white))
                          : Text(_signUp ? 'Create account' : 'Sign in'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() => _signUp = !_signUp),
                      child: Text(_signUp
                          ? 'Already have an account? Sign in'
                          : 'New here? Create an account'),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Session.instance.continueAsGuest();
                          widget.onSignedIn();
                        },
                        child: const Text('Continue as guest',
                            style: TextStyle(color: GfColors.grey600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
