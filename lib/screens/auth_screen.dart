import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/repository.dart';
import '../theme.dart';
import '../widgets/flavor.dart';

/// Fully-scrollable, modern front-door auth for the proposal demo.
/// Credentials are not verified against any backend — any valid-looking
/// input signs in — but the flow, validation and session gate are real.
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
      body: CustomScrollView(
        slivers: [
          // Gradient hero that scrolls with the page.
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: GfGradients.hero),
              padding: EdgeInsets.fromLTRB(
                  28, MediaQuery.paddingOf(context).top + 52, 28, 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/images/brand/logo.svg',
                      height: 28,
                      colorFilter: const ColorFilter.mode(
                          GfColors.white, BlendMode.srcIn)),
                  const SizedBox(height: 32),
                  const Eyebrow('Digital Product Catalogue',
                      color: GfColors.lightBlue),
                  const SizedBox(height: 12),
                  const Text('The catalogue,\nin your pocket.',
                      style: TextStyle(
                          fontFamily: 'Grundfos-Extd',
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          height: 1.12,
                          color: GfColors.white)),
                  const SizedBox(height: 14),
                  Text(
                    'Every Grundfos pump, spec and performance curve — '
                    'replacing the heavy printed books with a fast, '
                    'searchable digital catalogue.',
                    style: TextStyle(
                        fontSize: 14.5,
                        height: 1.5,
                        color: GfColors.white.withValues(alpha: 0.9)),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _HeroChip(icon: Icons.eco_outlined, label: 'Paperless'),
                      _HeroChip(icon: Icons.bolt_outlined, label: 'Instant'),
                      _HeroChip(
                          icon: Icons.sync_outlined, label: 'Always current'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // The form floats up over the hero on a rounded white card.
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                decoration: const BoxDecoration(
                  color: GfColors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Sign in / Sign up segmented toggle.
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: GfColors.grey100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            _segment('Sign in', !_signUp,
                                () => setState(() => _signUp = false)),
                            _segment('Create account', _signUp,
                                () => setState(() => _signUp = true)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                          _signUp
                              ? 'Create your account'
                              : 'Welcome back',
                          style: const TextStyle(
                              fontFamily: 'Grundfos-Extd',
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: GfColors.ink)),
                      const SizedBox(height: 4),
                      Text(
                          _signUp
                              ? 'Join to explore the full digital catalogue.'
                              : 'Sign in to continue to the catalogue.',
                          style: const TextStyle(
                              fontSize: 14, color: GfColors.grey600)),
                      const SizedBox(height: 22),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.topCenter,
                        child: _signUp
                            ? Column(
                                children: [
                                  TextFormField(
                                    controller: _name,
                                    decoration: const InputDecoration(
                                        labelText: 'Full name',
                                        prefixIcon: Icon(Icons.person_outline)),
                                    textInputAction: TextInputAction.next,
                                    validator: (v) => _signUp &&
                                            (v == null || v.trim().isEmpty)
                                        ? 'Enter your name'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
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
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6)
                            ? 'At least 6 characters'
                            : null,
                      ),
                      if (!_signUp)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Forgot password?'),
                          ),
                        ),
                      const SizedBox(height: 14),
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
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or',
                                style: TextStyle(color: GfColors.grey500)),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.person_outline),
                        label: const Text('Continue as guest'),
                        onPressed: () {
                          Session.instance.continueAsGuest();
                          widget.onSignedIn();
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'By continuing you agree to the demo terms of this '
                        'digital-catalogue proposal.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: GfColors.grey500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segment(String label, bool active, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: active ? GfColors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
              boxShadow: active ? gfCardShadow : null,
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: active ? GfColors.actionBlue : GfColors.grey600)),
          ),
        ),
      );
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: GfColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GfColors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: GfColors.white),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: GfColors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
