import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../widgets/gf_scaffold.dart';
import '../widgets/tiles.dart';
import 'product_group_screen.dart';

/// `/size-page` — sizing flow driven by the site's own sizing
/// quick-config (`.sizing-qc.json`): Select criteria → Set Flow and
/// Head → Size product.
class SizingScreen extends StatefulWidget {
  final String? initialSizeBy;
  final String? initialArea;

  const SizingScreen({super.key, this.initialSizeBy, this.initialArea});

  @override
  State<SizingScreen> createState() => _SizingScreenState();
}

class _SizingScreenState extends State<SizingScreen> {
  String? _sizeBy;
  String? _area;
  final _flow = TextEditingController();
  final _head = TextEditingController();
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _sizeBy = widget.initialSizeBy;
    _area = widget.initialArea;
  }

  @override
  void dispose() {
    _flow.dispose();
    _head.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = CatalogueRepository.instance;
    final sizeByOptions =
        repo.sizingQuestions.firstWhere((q) => q.label == 'SizeBy').options;
    final areaOptions =
        repo.sizingQuestions.firstWhere((q) => q.label == 'UxArea').options;

    // Sizeable product groups for the chosen application area
    // (live catalogue API mapping: group.applications ↔ area).
    final areaUrl = _area == null
        ? null
        : repo.applicationAreas
            .where((a) => a.name.toLowerCase() == _area!.toLowerCase())
            .map((a) => a.urlname)
            .cast<String?>()
            .firstWhere((_) => true, orElse: () => null);
    final subAppUrls = areaUrl == null
        ? <String>{}
        : repo.applicationAreas
            .firstWhere((a) => a.urlname == areaUrl)
            .applications
            .map((s) => s.urlname)
            .toSet();
    final results = repo.groups
        .where((g) =>
            g.sizable &&
            (subAppUrls.isEmpty ||
                g.applications.any(subAppUrls.contains)))
        .toList();

    return GfScaffold(
      children: [
        const PageHero(
          title: 'Size your product',
          description:
              'Find the right pump for your installation requirements.',
          dark: true,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. Select criteria', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _sizeBy,
                decoration: const InputDecoration(labelText: 'Size by'),
                items: [
                  for (final o in sizeByOptions)
                    DropdownMenuItem(value: o, child: Text(o)),
                ],
                onChanged: (v) => setState(() => _sizeBy = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _area,
                decoration:
                    const InputDecoration(labelText: 'Select application area'),
                items: [
                  for (final o in areaOptions)
                    DropdownMenuItem(value: o, child: Text(o)),
                ],
                onChanged: (v) => setState(() => _area = v),
              ),
              const SizedBox(height: 24),
              Text('2. Set Flow and Head', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _flow,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Flow', suffixText: 'm³/h'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _head,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Head', suffixText: 'm'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('3. Size product', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => setState(() => _showResults = true),
                child: const Text('Start sizing'),
              ),
              if (_showResults && _area == null && _sizeBy == null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text('To continue, please press the blue button.',
                      style: theme.textTheme.bodySmall),
                ),
            ],
          ),
        ),
        if (_showResults) ...[
          DeckHeader(
              title: 'Sizeable products',
              description: _area == null ? null : 'Application area: $_area'),
          for (final g in results)
            TileCard(
              image: g.image,
              imageFit: BoxFit.contain,
              imageHeight: 180,
              title: g.displayname,
              description: g.description,
              badge: const SizeableBadge(),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ProductGroupScreen(group: g))),
            ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

/// `/advanced-selection` — Advanced Selection entry.
class AdvancedSelectionScreen extends StatelessWidget {
  const AdvancedSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CatalogueRepository.instance;
    final sizable = repo.groups.where((g) => g.sizable).toList();
    return GfScaffold(
      children: [
        const PageHero(title: 'Advanced Selection', dark: true),
        const DeckHeader(title: 'Sizeable product families'),
        for (final g in sizable)
          TileCard(
            image: g.image,
            imageFit: BoxFit.contain,
            imageHeight: 180,
            title: g.displayname,
            description: g.description,
            badge: const SizeableBadge(),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ProductGroupScreen(group: g))),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
