import 'package:flutter/material.dart';

import '../theme.dart';

/// Contact form backing the site's "How can we help you?" cards:
/// sales enquiries, expert questions and service requests.
class ContactFormScreen extends StatefulWidget {
  /// Preselected topic (one of [topics]) when opened from a help card.
  final String? initialTopic;

  const ContactFormScreen({super.key, this.initialTopic});

  static const topics = [
    'Sales enquiry',
    'Ask an expert',
    'Service request',
  ];

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _company = TextEditingController();
  final _message = TextEditingController();
  String? _topic;

  @override
  void initState() {
    super.initState();
    _topic = widget.initialTopic;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _company.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank you'),
        content: Text(
            'Your ${_topic!.toLowerCase()} has been registered. '
            'Our team will get back to you at ${_email.text.trim()}.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close')),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact us',
            style: TextStyle(
                fontFamily: 'Qiantao-Extd', fontWeight: FontWeight.w700)),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('How can we help you?',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontSize: 22, color: GfColors.darkBlue)),
            const SizedBox(height: 6),
            Text(
              'Whether you’re looking to buy a product or simply seeking '
              'advice from a Qiantao expert, we are more than happy to '
              'help you get the most out of your pump solution!',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _topic,
              decoration: const InputDecoration(labelText: 'Topic *'),
              items: [
                for (final t in ContactFormScreen.topics)
                  DropdownMenuItem(value: t, child: Text(t)),
              ],
              validator: (v) => v == null ? 'Select a topic' : null,
              onChanged: (v) => setState(() => _topic = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full name *'),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email *'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Enter your email';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _company,
              decoration: const InputDecoration(labelText: 'Company'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _message,
              decoration: const InputDecoration(labelText: 'Message *'),
              minLines: 4,
              maxLines: 8,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a message' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _submit, child: const Text('Send')),
          ],
        ),
      ),
    );
  }
}
