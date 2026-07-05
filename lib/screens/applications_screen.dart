import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../theme.dart';
import '../widgets/gf_scaffold.dart';
import '../widgets/tiles.dart';
import 'product_group_screen.dart';

/// `/applications` — "Select area of interest or application".
class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CatalogueRepository.instance;
    return GfScaffold(
      children: [
        const PageHero(
          title: 'Applications',
          description:
              'Discover the available applications and find the one that '
              'matches your current task.',
        ),
        const DeckHeader(title: 'Select area of interest or application'),
        for (final a in repo.applicationAreas)
          TileCard(
            image: a.image,
            title: a.name,
            description: a.description,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ApplicationAreaScreen(area: a))),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// `/applications/<area>` — application area page with its applications.
class ApplicationAreaScreen extends StatelessWidget {
  final ApplicationArea area;

  const ApplicationAreaScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return GfScaffold(
      children: [
        PageHero(
            title: area.name, description: area.description, image: area.image),
        const DeckHeader(title: 'Applications'),
        for (final app in area.applications)
          TileCard(
            title: app.name,
            description: app.description,
            badge: app.sizable ? const SizeableBadge() : null,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    SubApplicationScreen(area: area, application: app))),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// `/applications/<area>/<application>` — application page listing the
/// product groups related to it (live catalogue API mapping).
class SubApplicationScreen extends StatelessWidget {
  final ApplicationArea area;
  final SubApplication application;

  const SubApplicationScreen(
      {super.key, required this.area, required this.application});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = CatalogueRepository.instance;
    final related = repo.groups
        .where((g) => g.applications.contains(application.urlname))
        .toList();

    return GfScaffold(
      children: [
        PageHero(title: application.name, image: area.image),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(area.name,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: GfColors.grey600)),
              const SizedBox(height: 8),
              Text(application.description, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
        if (related.isNotEmpty) ...[
          const DeckHeader(title: 'Products'),
          for (final g in related)
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
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
