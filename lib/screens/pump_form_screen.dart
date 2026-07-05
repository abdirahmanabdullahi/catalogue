import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../theme.dart';

/// Form for adding a new pump or updating an existing one.
class PumpFormScreen extends StatefulWidget {
  /// When set, the form edits this pump; otherwise it creates a new one.
  final ProductFamily? existing;

  const PumpFormScreen({super.key, this.existing});

  @override
  State<PumpFormScreen> createState() => _PumpFormScreenState();
}

class _PumpFormScreenState extends State<PumpFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _typeCode;
  late final TextEditingController _description;
  late bool _sizable;
  late bool _discontinued;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    _title = TextEditingController(text: p?.title ?? '');
    _typeCode = TextEditingController(text: p?.typeCode ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _sizable = p?.sizable ?? false;
    _discontinued = p?.isDiscontinued ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _typeCode.dispose();
    _description.dispose();
    super.dispose();
  }

  String _slug(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'(^-+|-+$)'), '');

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = CatalogueRepository.instance;
    final title = _title.text.trim();
    final pump = ProductFamily(
      letter: title[0].toUpperCase(),
      title: title,
      urlName: _slug(title),
      typeCode: _typeCode.text.trim().toUpperCase(),
      description: _description.text.trim(),
      sizable: _sizable,
      isDiscontinued: _discontinued,
      image: widget.existing?.image,
    );
    if (_isEdit) {
      await repo.updatePump(widget.existing!.typeCode, pump);
    } else {
      await repo.addPump(pump);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isEdit ? 'Pump updated' : 'Pump added'),
        backgroundColor: GfColors.darkBlue));
    Navigator.of(context).pop(pump);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete pump'),
        content: Text('Delete "${widget.existing!.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
          TextButton(
              style: TextButton.styleFrom(foregroundColor: GfColors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await CatalogueRepository.instance.deletePump(widget.existing!.typeCode);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pump deleted'), backgroundColor: GfColors.darkBlue));
    Navigator.of(context).pop('deleted');
  }

  @override
  Widget build(BuildContext context) {
    final repo = CatalogueRepository.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit pump' : 'Add pump',
            style: const TextStyle(
                fontFamily: 'Qiantao-Extd', fontWeight: FontWeight.w700)),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Pump name *'),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter the pump name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _typeCode,
              decoration: const InputDecoration(
                  labelText: 'Type code *',
                  helperText: 'Unique identifier, e.g. ALPFAM'),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              validator: (v) {
                final code = (v ?? '').trim().toUpperCase();
                if (code.isEmpty) return 'Enter a type code';
                final original = widget.existing?.typeCode;
                if (code != original && repo.typeCodeExists(code)) {
                  return 'A pump with this type code already exists';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              minLines: 3,
              maxLines: 6,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sizeable'),
              subtitle: const Text('Pump can be sized for an installation'),
              activeThumbColor: GfColors.actionBlue,
              value: _sizable,
              onChanged: (v) => setState(() => _sizable = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Discontinued'),
              activeThumbColor: GfColors.actionBlue,
              value: _discontinued,
              onChanged: (v) => setState(() => _discontinued = v),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: Text(_isEdit ? 'Save changes' : 'Add pump'),
            ),
            if (_isEdit) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: GfColors.red,
                  side: const BorderSide(color: GfColors.red, width: 1.5),
                ),
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete pump'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
