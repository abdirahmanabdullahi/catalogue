import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../theme.dart';
import '../widgets/gf_scaffold.dart';
import '../widgets/tiles.dart';
import 'applications_screen.dart';
import 'categories_screen.dart';
import 'products_screen.dart';

/// Header search — searches products, categories and applications.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = CatalogueRepository.instance;
    final q = _query.toLowerCase().trim();

    final products = q.isEmpty
        ? []
        : repo.products
            .where((p) =>
                p.title.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q))
            .take(30)
            .toList();
    final categories = q.isEmpty
        ? []
        : repo.categories
            .where((c) => c.title.toLowerCase().contains(q))
            .toList();
    final applications = q.isEmpty
        ? []
        : repo.applicationAreas
            .where((a) => a.name.toLowerCase().contains(q))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Qiantao product',
            style: TextStyle(
                fontFamily: 'Qiantao-Extd',
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search for...',
                suffixIcon: Icon(Icons.search, color: GfColors.grey600),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          if (q.isNotEmpty && categories.isNotEmpty) ...[
            const DeckHeader(title: 'Categories'),
            for (final c in categories)
              ListTile(
                title: Text(c.title),
                trailing:
                    const Icon(Icons.chevron_right, color: GfColors.actionBlue),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CategoryDetailScreen(category: c))),
              ),
          ],
          if (q.isNotEmpty && applications.isNotEmpty) ...[
            const DeckHeader(title: 'Applications'),
            for (final a in applications)
              ListTile(
                title: Text(a.name),
                trailing:
                    const Icon(Icons.chevron_right, color: GfColors.actionBlue),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ApplicationAreaScreen(area: a))),
              ),
          ],
          if (q.isNotEmpty && products.isNotEmpty) ...[
            const DeckHeader(title: 'Products'),
            for (final p in products)
              ListTile(
                leading: p.image != null
                    ? Image.asset(p.image!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            const SizedBox(width: 44, height: 44))
                    : null,
                title: Text(p.title),
                subtitle: Text(p.description,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  RecentlyViewed.instance.add(p);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProductFamilyScreen(product: p)));
                },
              ),
          ],
          if (q.isNotEmpty &&
              products.isEmpty &&
              categories.isEmpty &&
              applications.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                  'Unfortunately, we did not find the product.',
                  style: theme.textTheme.bodyLarge),
            ),
        ],
      ),
    );
  }
}

/// "Product Compare Variants" (header touchpoint).
class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final compare = CompareList.instance;
    return GfScaffold(
      children: [
        const PageHero(title: 'Product Compare Variants'),
        ListenableBuilder(
          listenable: compare,
          builder: (context, _) {
            if (compare.items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text('No products have been added to comparison.'),
              );
            }
            return Column(
              children: [
                for (final p in compare.items)
                  ListTile(
                    leading: p.image != null
                        ? Image.asset(p.image!,
                            width: 44, height: 44, fit: BoxFit.contain)
                        : null,
                    title: Text(p.title),
                    subtitle: Text(p.description,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => compare.remove(p),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProductFamilyScreen(product: p))),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// "Recently viewed products" (header touchpoint).
class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recent = RecentlyViewed.instance;
    return GfScaffold(
      children: [
        const PageHero(title: 'Recently viewed products'),
        ListenableBuilder(
          listenable: recent,
          builder: (context, _) {
            if (recent.items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text('You have not viewed any products yet.'),
              );
            }
            return Column(
              children: [
                for (final p in recent.items)
                  ListTile(
                    leading: p.image != null
                        ? Image.asset(p.image!,
                            width: 44, height: 44, fit: BoxFit.contain)
                        : null,
                    title: Text(p.title),
                    subtitle: Text(p.description,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProductFamilyScreen(product: p))),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// "Catalogue Settings" (header touchpoint).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _units = 'SI units';

  @override
  Widget build(BuildContext context) {
    return GfScaffold(
      children: [
        const PageHero(title: 'Catalogue Settings'),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _units,
                decoration: const InputDecoration(labelText: 'Units'),
                items: const [
                  DropdownMenuItem(value: 'SI units', child: Text('SI units')),
                  DropdownMenuItem(value: 'US units', child: Text('US units')),
                ],
                onChanged: (v) => setState(() => _units = v ?? _units),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
