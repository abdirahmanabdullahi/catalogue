import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../services/downloads.dart';
import '../theme.dart';
import '../widgets/flavor.dart';
import '../widgets/gf_scaffold.dart';
import '../widgets/tiles.dart';
import 'ai_assistant_screen.dart';
import 'contact_form_screen.dart';

/// Home page: the site's search + sizing heroes, extended with the
/// digital-catalogue proposal framing (value props, catalogue stats,
/// AI assistant entry) for the manager pitch.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GfScaffold(
      children: [
        _SearchHero(),
        _ProposalBanner(),
        _CatalogueStats(),
        _AssistantCard(),
        _SizingHero(),
        _ExploreOfferings(),
        _MarketingCentre(),
        _HowCanWeHelp(),
      ],
    );
  }
}

/// Proposal value proposition: why a digital catalogue beats printed books.
class _ProposalBanner extends StatelessWidget {
  const _ProposalBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Why go digital'),
          const SizedBox(height: 8),
          Text('One catalogue. Every pump. Always current.',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 23, color: GfColors.darkBlue)),
          const SizedBox(height: 8),
          const Text(
            'Replace the heavy printed product books with a fast, searchable '
            'catalogue — specs, performance curves and downloads in seconds, '
            'updated instantly and never out of date.',
            style: TextStyle(fontSize: 14.5, height: 1.5, color: GfColors.grey700),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                  child: FeatureCard(
                      icon: Icons.eco_outlined,
                      iconColor: GfColors.green,
                      title: 'Paperless',
                      body: 'No reprints, no shipping, no waste.')),
              SizedBox(width: 12),
              Expanded(
                  child: FeatureCard(
                      icon: Icons.bolt_outlined,
                      iconColor: GfColors.amber,
                      title: 'Instant',
                      body: 'Find any product in a couple of taps.')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                  child: FeatureCard(
                      icon: Icons.sync_outlined,
                      iconColor: GfColors.actionBlue,
                      title: 'Always current',
                      body: 'Central updates reach everyone at once.')),
              SizedBox(width: 12),
              Expanded(
                  child: FeatureCard(
                      icon: Icons.download_outlined,
                      iconColor: GfColors.teal,
                      title: 'Downloadable',
                      body: 'Export specs & catalogue sheets on demand.')),
            ],
          ),
        ],
      ),
    );
  }
}

/// Live catalogue counts + a "download full catalogue" action.
class _CatalogueStats extends StatelessWidget {
  const _CatalogueStats();

  @override
  Widget build(BuildContext context) {
    final repo = CatalogueRepository.instance;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: GfGradients.hero,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('The catalogue at a glance',
              color: GfColors.lightBlue),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: StatTile(
                      value: '${repo.products.length}',
                      label: 'Product families',
                      icon: Icons.inventory_2_outlined,
                      onDark: true)),
              const SizedBox(width: 12),
              Expanded(
                  child: StatTile(
                      value: '${repo.categories.length}',
                      label: 'Categories',
                      icon: Icons.grid_view_rounded,
                      onDark: true)),
              const SizedBox(width: 12),
              Expanded(
                  child: StatTile(
                      value: '${repo.applicationAreas.length}',
                      label: 'Applications',
                      icon: Icons.water_drop_outlined,
                      onDark: true)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: LightPillButton(
              label: 'Download full catalogue',
              icon: Icons.download,
              onPressed: () => Downloads.fullCatalogue(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Entry point for the AI product advisor.
class _AssistantCard extends StatelessWidget {
  const _AssistantCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GfColors.grey200),
        boxShadow: gfCardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: GfColors.white,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AiAssistantScreen())),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                      gradient: GfGradients.ai, shape: BoxShape.circle),
                  child:
                      const Icon(Icons.auto_awesome, color: GfColors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Grundfos Assist',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: GfColors.ink)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: GfColors.teal.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('AI',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: GfColors.teal)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                          'Describe your application — get pump recommendations '
                          'from the catalogue.',
                          style: TextStyle(
                              fontSize: 13.5,
                              height: 1.4,
                              color: GfColors.grey700)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: GfColors.actionBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchHero extends StatelessWidget {
  const _SearchHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/home/hero-search.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.35), BlendMode.darken),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Find a Grundfos product',
              style: theme.textTheme.displaySmall
                  ?.copyWith(color: GfColors.white, fontSize: 30)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/search'),
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for...',
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: GfColors.actionBlue, shape: BoxShape.circle),
                    child: const Icon(Icons.search, color: GfColors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizingHero extends StatefulWidget {
  const _SizingHero();

  @override
  State<_SizingHero> createState() => _SizingHeroState();
}

class _SizingHeroState extends State<_SizingHero> {
  static const _steps = ['Select criteria', 'Set Flow and Head', 'Size product'];

  String? _sizeBy;
  String? _area;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = CatalogueRepository.instance;
    final sizeByOptions = repo.sizingQuestions
        .firstWhere((q) => q.label == 'SizeBy')
        .options;
    final areaOptions =
        repo.sizingQuestions.firstWhere((q) => q.label == 'UxArea').options;

    const white = TextStyle(color: GfColors.white);
    return Container(
      width: double.infinity,
      color: GfColors.darkBlue,
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sizing',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: GfColors.lightBlue)),
          const SizedBox(height: 6),
          Text('Size your product',
              style: theme.textTheme.displaySmall
                  ?.copyWith(color: GfColors.white, fontSize: 28)),
          const SizedBox(height: 8),
          Text('Find the right pump for your installation requirements.',
              style: theme.textTheme.bodyLarge?.copyWith(color: GfColors.white)),
          const SizedBox(height: 20),
          // The site's 3-step indicator
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _steps.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: GfColors.lightBlue,
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: GfColors.darkBlue,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 6),
                    Text(_steps[i], style: white),
                    if (i < _steps.length - 1) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right,
                          color: GfColors.lightBlue, size: 18),
                    ],
                  ],
                ),
            ],
          ),
          const SizedBox(height: 24),
          _dropdown('Size by', sizeByOptions, _sizeBy,
              (v) => setState(() => _sizeBy = v)),
          const SizedBox(height: 12),
          _dropdown('Select application area', areaOptions, _area,
              (v) => setState(() => _area = v)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/sizing',
                    arguments: {'sizeBy': _sizeBy, 'area': _area}),
                child: const Text('Start sizing'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: GfColors.white,
                  side: const BorderSide(color: GfColors.white, width: 1.5),
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/advanced-selection'),
                child: const Text('Open Advanced Selection'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, List<String> options, String? value,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: GfColors.grey600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: GfColors.grey400),
        ),
      ),
      dropdownColor: GfColors.white,
      style: const TextStyle(color: GfColors.ink, fontFamily: 'Grundfos'),
      items: [
        for (final o in options)
          DropdownMenuItem(value: o, child: Text(o)),
      ],
      onChanged: onChanged,
    );
  }
}

class _ExploreOfferings extends StatelessWidget {
  const _ExploreOfferings();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DeckHeader(
          title: 'Explore our offerings',
          description:
              'We have a wide array of products, pump solutions and services '
              'for all applications. Select your starting point here.',
          centered: true,
        ),
        TileCard(
          bordered: false,
          image: 'assets/images/home/card-industries.jpg',
          eyebrow: 'Industry',
          title: 'Industries',
          description:
              'Explore Grundfos’ offerings and services by industries',
          onTap: () => Navigator.of(context).pushNamed('/applications'),
        ),
        TileCard(
          bordered: false,
          image: 'assets/images/home/card-applications.jpg',
          eyebrow: 'Application',
          title: 'Applications',
          description:
              'Discover the available applications and find the one that '
              'matches your current task.',
          onTap: () => Navigator.of(context).pushNamed('/applications'),
        ),
        TileCard(
          bordered: false,
          image: 'assets/images/home/card-categories.jpg',
          eyebrow: 'Product categories',
          title: 'Categories',
          description: 'Get an overview of the product categories.',
          onTap: () => Navigator.of(context).pushNamed('/categories'),
        ),
        TileCard(
          bordered: false,
          image: 'assets/images/home/card-products-az.jpg',
          eyebrow: 'Products and services',
          title: 'Products A-Z',
          description:
              'Find exactly what you are looking for in this product list.',
          onTap: () => Navigator.of(context).pushNamed('/products'),
        ),
      ],
    );
  }
}

class _MarketingCentre extends StatelessWidget {
  const _MarketingCentre();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: GfColors.grey100,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/home/marketing-centre.jpg',
                width: double.infinity, height: 170, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(
            'Make your marketing campaigns a success with our free materials '
            'for domestic and residential pressure boosting, heating, hot '
            'water recirculation, wastewater and groundwater intake.',
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            'Access downloadable elements such as photos, videos, unique '
            'selling points and campaign materials for a range of Grundfos '
            'pumps and solutions for the home.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Please note the use of Grundfos Marketing Centre is intended for '
            'use by our distributor and installer customers providing Grundfos '
            'solutions to the domestic and residential market.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Go to Grundfos Marketing Centre'),
          ),
        ],
      ),
    );
  }
}

class _HowCanWeHelp extends StatelessWidget {
  const _HowCanWeHelp();

  // Card text (from the site) → contact form topic.
  static const _cards = {
    'If you’re looking to buy one of our products, reach out to our '
        'sales team who will happily guide you through the next steps.': 'Sales enquiry',
    'If you have a specific question or request, our team of experts are '
        'ready to guide you. Feel free to reach out!': 'Ask an expert',
    'With the right service offerings, you can optimise your installation '
        'and ensure that you get the most out of your Grundfos product.': 'Service request',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('How can we help you?',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontSize: 24, color: GfColors.darkBlue)),
          ),
          const SizedBox(height: 10),
          Text(
            'Whether you’re looking to buy a product or simply seeking '
            'advice from a Grundfos expert, we are more than happy to help '
            'you get the most out of your pump solution! Feel free to get in '
            'touch if you need support.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          for (final entry in _cards.entries)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: GfColors.grey300),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        ContactFormScreen(initialTopic: entry.value))),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            Text(entry.key, style: theme.textTheme.bodyMedium),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward,
                          size: 20, color: GfColors.actionBlue),
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
