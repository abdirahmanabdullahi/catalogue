import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../theme.dart';
import '../widgets/gf_scaffold.dart';
import '../widgets/tiles.dart';

/// Product group / family detail page: photo, description, technical data
/// (from the live Qiantao catalogue API) and related applications.
class ProductGroupScreen extends StatelessWidget {
  final ProductGroup group;

  const ProductGroupScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = CatalogueRepository.instance;
    final subcats = group.subcategories
        .map((u) => repo.subcategories.where((s) => s.urlname == u))
        .expand((s) => s)
        .toList();

    return GfScaffold(
      children: [
        if (group.image != null)
          Container(
            color: GfColors.white,
            padding: const EdgeInsets.all(24),
            child: Image.asset(group.image!,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const SizedBox(height: 220)),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(group.displayname,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 26)),
                  ),
                  if (group.sizable) const SizeableBadge(),
                ],
              ),
              const SizedBox(height: 8),
              Text(group.description, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text('${group.productcount} products',
                  style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        if (group.technicaldata.isNotEmpty) ...[
          const DeckHeader(title: 'Technical data'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Table(
              border: TableBorder.all(color: GfColors.grey300),
              columnWidths: const {0: FlexColumnWidth(1.2), 1: FlexColumnWidth(1)},
              children: [
                for (final t in group.technicaldata)
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(t.label,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('${t.data} ${t.additionalData}'.trim()),
                    ),
                  ]),
              ],
            ),
          ),
        ],
        if (group.applications.isNotEmpty) ...[
          const DeckHeader(title: 'Applications'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final a in group.applications)
                  Chip(label: Text(_titleize(a))),
              ],
            ),
          ),
        ],
        if (subcats.isNotEmpty) ...[
          const DeckHeader(title: 'Categories'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in subcats) Chip(label: Text(s.title)),
              ],
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  static String _titleize(String urlname) {
    final words = urlname.split('-');
    if (words.isEmpty) return urlname;
    words[0] = words[0][0].toUpperCase() + words[0].substring(1);
    return words.join(' ');
  }
}
