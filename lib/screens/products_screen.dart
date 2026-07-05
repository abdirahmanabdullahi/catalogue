import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../services/downloads.dart';
import '../theme.dart';
import '../widgets/flavor.dart';
import '../widgets/gf_scaffold.dart';
import '../widgets/pump_curve.dart';
import '../widgets/tiles.dart';
import '../widgets/zoomable_image.dart';
import 'ai_assistant_screen.dart';
import 'pump_form_screen.dart';

/// `/products` — the site's Products A-Z: letter-indexed list of all
/// product families with photos and descriptions.
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _query = '';
  String? _letter;

  @override
  Widget build(BuildContext context) {
    final repo = CatalogueRepository.instance;
    return ListenableBuilder(
      listenable: repo,
      builder: (context, _) => _buildScaffold(context, repo),
    );
  }

  Widget _buildScaffold(BuildContext context, CatalogueRepository repo) {
    final letters = repo.productLetters;
    final products = repo.products.where((p) {
      if (_letter != null && p.letter != _letter) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return p.title.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();

    String? lastLetter;
    final rows = <Widget>[];
    for (final p in products) {
      if (p.letter != lastLetter) {
        lastLetter = p.letter;
        rows.add(Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Text(p.letter,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: GfColors.actionBlue)),
        ));
      }
      rows.add(_ProductRow(product: p));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products A-Z',
            style: TextStyle(
                fontFamily: 'Grundfos-Extd', fontWeight: FontWeight.w700)),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      drawer: const GfMenuDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: GfColors.actionBlue,
        foregroundColor: GfColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add pump',
            style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PumpFormScreen())),
      ),
      body: ListView(
        children: [
          const PageHero(
            title: 'Products A-Z',
            description:
                'Find exactly what you are looking for in this product list.',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for...',
                suffixIcon: Icon(Icons.search, color: GfColors.grey600),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: [
                _LetterChip(
                  label: 'All',
                  selected: _letter == null,
                  onTap: () => setState(() => _letter = null),
                ),
                for (final l in letters)
                  _LetterChip(
                    label: l,
                    selected: _letter == l,
                    onTap: () => setState(() => _letter = l),
                  ),
              ],
            ),
          ),
          ...rows,
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _LetterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LetterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: GfColors.actionBlue,
        labelStyle: TextStyle(
            color: selected ? GfColors.white : GfColors.ink,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final ProductFamily product;

  const _ProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        RecentlyViewed.instance.add(product);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductFamilyScreen(product: product)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: GfColors.grey300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: product.image != null
                  ? Image.asset(product.image!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          const SizedBox(width: 72, height: 72))
                  : const SizedBox(width: 72, height: 72),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(product.description,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (product.sizable)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: SizeableBadge(),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: GfColors.actionBlue),
          ],
        ),
      ),
    );
  }
}

/// Product family page reached from Products A-Z; shows the family photo,
/// description and — when the family exists in the catalogue API data —
/// its technical data and related applications. Pumps can be edited or
/// deleted from here.
class ProductFamilyScreen extends StatefulWidget {
  final ProductFamily product;

  const ProductFamilyScreen({super.key, required this.product});

  @override
  State<ProductFamilyScreen> createState() => _ProductFamilyScreenState();
}

class _ProductFamilyScreenState extends State<ProductFamilyScreen> {
  late ProductFamily product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  Future<void> _edit() async {
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PumpFormScreen(existing: product)));
    if (!mounted) return;
    if (result == 'deleted') {
      Navigator.of(context).pop();
    } else if (result is ProductFamily) {
      setState(() => product = result);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete pump'),
        content: Text('Delete "${product.title}"?'),
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
    await CatalogueRepository.instance.deletePump(product.typeCode);
    if (mounted) Navigator.of(context).pop();
  }

  /// Parse a leading number out of a technical-data value ("5 .. 60" → 60).
  double? _numFrom(String s, {bool takeMax = false}) {
    final matches = RegExp(r'-?\d+(?:\.\d+)?')
        .allMatches(s)
        .map((m) => double.tryParse(m.group(0)!))
        .whereType<double>()
        .toList();
    if (matches.isEmpty) return null;
    return takeMax ? matches.reduce((a, b) => a > b ? a : b) : matches.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = CatalogueRepository.instance;
    final group = repo.groupByTypeCode(product.typeCode) ??
        repo.groupByUrlname(product.urlName);
    final compare = CompareList.instance;

    TechnicalDataEntry? findData(String key) {
      if (group == null) return null;
      for (final t in group.technicaldata) {
        if (t.label.toLowerCase().contains(key)) return t;
      }
      return null;
    }

    final flowData = findData('flow');
    final headData = findData('head');
    final maxFlow = flowData == null ? null : _numFrom(flowData.data, takeMax: true);
    final maxHead = headData == null ? null : _numFrom(headData.data, takeMax: true);

    return GfScaffold(
      children: [
        // Hero: product image on a soft gradient, with title overlay chip row.
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GfColors.grey100, GfColors.white],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.image != null)
                Center(
                  child: ZoomableImage(asset: product.image!, height: 240),
                ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _tag('Type code ${product.typeCode}'),
                  if (product.sizable) _tag('Sizeable', accent: true),
                  if (product.isDiscontinued) _tag('Discontinued'),
                  if (repo.isUserAdded(product.typeCode))
                    _tag('Added by you', accent: true),
                ],
              ),
              const SizedBox(height: 12),
              Text(product.title,
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 27)),
              const SizedBox(height: 10),
              Text(product.description, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),

        // Key specs stat row (from real technical data).
        if (group != null && group.technicaldata.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                for (final t in group.technicaldata.take(3)) ...[
                  Expanded(
                    child: SizedBox(
                      height: 118,
                      child: StatTile(
                        icon: _specIcon(t.label),
                        value:
                            '${_numFrom(t.data, takeMax: true)?.toStringAsFixed(0) ?? t.data}'
                            '${t.additionalData.isNotEmpty ? ' ${t.additionalData}' : ''}',
                        label: t.label,
                      ),
                    ),
                  ),
                  if (t != group.technicaldata.take(3).last)
                    const SizedBox(width: 12),
                ],
              ],
            ),
          ),

        // Primary actions: downloads + AI + compare.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.description_outlined),
                label: const Text('Download product specs'),
                onPressed: () => Downloads.productSpecSheet(context, product),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.menu_book_outlined),
                label: const Text('Download catalogue'),
                onPressed: () => Downloads.productCatalogue(context, product),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: GfColors.teal,
                  side: const BorderSide(color: GfColors.teal, width: 1.5),
                ),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Ask Grundfos Assist about this pump'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AiAssistantScreen(
                      seedQuestion: 'Tell me about the ${product.title}'),
                )),
              ),
            ],
          ),
        ),

        // Performance curve.
        if (maxFlow != null && maxHead != null && maxFlow > 0 && maxHead > 0) ...[
          _sectionHeader(context, 'Performance curve',
              'Illustrative Q/H envelope from catalogue max flow & head'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 16, 16, 12),
              decoration: BoxDecoration(
                color: GfColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GfColors.grey200),
                boxShadow: gfCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 28, bottom: 4),
                    child: Text('Head H [${headData?.additionalData ?? 'm'}]',
                        style: const TextStyle(
                            fontSize: 11, color: GfColors.grey600)),
                  ),
                  PumpCurveChart(
                    maxFlow: maxFlow,
                    maxHead: maxHead,
                    flowUnit: flowData?.additionalData ?? 'm³/h',
                    headUnit: headData?.additionalData ?? 'm',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _legendDot(GfColors.curveBlue, 'Max speed'),
                      const SizedBox(width: 14),
                      _legendDot(GfColors.curveMid, 'Mid'),
                      const SizedBox(width: 14),
                      _legendDot(GfColors.curveLight, 'Min'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],

        // Full technical data table.
        if (group != null && group.technicaldata.isNotEmpty) ...[
          _sectionHeader(context, 'Technical data', null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GfColors.grey200),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < group.technicaldata.length; i++)
                    Container(
                      color: i.isEven ? GfColors.white : GfColors.grey100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(group.technicaldata[i].label,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                                '${group.technicaldata[i].data} '
                                        '${group.technicaldata[i].additionalData}'
                                    .trim(),
                                style: const TextStyle(color: GfColors.grey800)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],

        // Applications chips.
        if (group != null && group.applications.isNotEmpty) ...[
          _sectionHeader(context, 'Suitable applications', null),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final a in group.applications)
                  Chip(
                    avatar: const Icon(Icons.check_circle_outline,
                        size: 16, color: GfColors.green),
                    label: Text(_titleize(a)),
                  ),
              ],
            ),
          ),
        ],

        // Manage (compare / edit / delete).
        _sectionHeader(context, 'Manage', null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListenableBuilder(
                listenable: compare,
                builder: (context, _) => OutlinedButton.icon(
                  icon: Icon(compare.contains(product)
                      ? Icons.check
                      : Icons.compare_arrows),
                  label: Text(compare.contains(product)
                      ? 'Added to compare'
                      : 'Add to compare'),
                  onPressed: () => compare.toggle(product),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                      onPressed: _edit,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GfColors.red,
                        side: const BorderSide(color: GfColors.red, width: 1.5),
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                      onPressed: _delete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  static String _titleize(String urlname) {
    final words = urlname.split('-');
    if (words.isEmpty) return urlname;
    words[0] = words[0][0].toUpperCase() + words[0].substring(1);
    return words.join(' ');
  }

  static IconData _specIcon(String label) {
    final l = label.toLowerCase();
    if (l.contains('flow')) return Icons.waves;
    if (l.contains('head')) return Icons.height;
    if (l.contains('temp')) return Icons.thermostat;
    if (l.contains('power')) return Icons.bolt;
    if (l.contains('pressure')) return Icons.speed;
    return Icons.tune;
  }

  Widget _tag(String text, {bool accent = false}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: accent
              ? GfColors.actionBlue.withValues(alpha: 0.1)
              : GfColors.grey100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: accent ? GfColors.actionBlue : GfColors.grey300),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: accent ? GfColors.actionBlue : GfColors.grey800)),
      );

  Widget _legendDot(Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(fontSize: 12, color: GfColors.grey700)),
        ],
      );

  Widget _sectionHeader(BuildContext context, String title, String? sub) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 20, color: GfColors.darkBlue)),
            if (sub != null) ...[
              const SizedBox(height: 4),
              Text(sub,
                  style: const TextStyle(fontSize: 13, color: GfColors.grey600)),
            ],
          ],
        ),
      );
}
