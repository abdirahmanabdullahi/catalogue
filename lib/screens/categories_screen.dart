import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../widgets/gf_scaffold.dart';
import '../widgets/tiles.dart';
import 'product_group_screen.dart';

/// `/categories` — "Select by category" grid of the site's category areas.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CatalogueRepository.instance;
    return GfScaffold(
      children: [
        const PageHero(
          title: 'Categories',
          description:
              'Choose a product category to find all your high-quality '
              'Qiantao options quickly and easily.',
        ),
        const DeckHeader(title: 'Select by category'),
        for (final c in repo.categories)
          TileCard(
            image: c.image,
            title: c.title,
            description: c.description,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CategoryDetailScreen(category: c))),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// `/categories/<area>` — category area page with its subcategory tiles.
class CategoryDetailScreen extends StatelessWidget {
  final CategoryArea category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final repo = CatalogueRepository.instance;
    final subcats = repo.subcategoriesForArea(category.urlName);
    return GfScaffold(
      children: [
        PageHero(
          title: category.title,
          description: category.description,
          image: category.image,
        ),
        if (subcats.isNotEmpty) const DeckHeader(title: 'Categories Overview'),
        for (final sc in subcats)
          TileCard(
            image: sc.image,
            title: sc.title,
            description: sc.description,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SubCategoryScreen(subcategory: sc))),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// `/categories/<area>/<subcategory>` — product groups in a subcategory.
class SubCategoryScreen extends StatelessWidget {
  final SubCategory subcategory;

  const SubCategoryScreen({super.key, required this.subcategory});

  @override
  Widget build(BuildContext context) {
    final repo = CatalogueRepository.instance;
    final groups = repo.groupsForSubcategory(subcategory);
    return GfScaffold(
      children: [
        PageHero(
          title: subcategory.title,
          description: subcategory.description,
          image: subcategory.image,
        ),
        if (groups.isNotEmpty) const DeckHeader(title: 'Products'),
        for (final g in groups)
          TileCard(
            image: g.image,
            imageFit: BoxFit.contain,
            imageHeight: 180,
            title: g.displayname,
            description: g.description,
            badge: g.sizable ? const SizeableBadge() : null,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ProductGroupScreen(group: g))),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
