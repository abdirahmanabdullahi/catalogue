import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../screens/tools_screen.dart';
import '../theme.dart';
import 'brand_logo.dart';

/// Page scaffold with the Qiantao header bar and the
/// "Products & services" menu, shared by every screen.
class GfScaffold extends StatelessWidget {
  final List<Widget> children;

  const GfScaffold({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: GestureDetector(
          onTap: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          child: const BrandLogo(height: 26),
        ),
        actions: [
          IconButton(
            tooltip: 'search',
            icon: const Icon(Icons.search, color: GfColors.ink),
            onPressed: () => Navigator.of(context).pushNamed('/search'),
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      drawer: const GfMenuDrawer(),
      body: ListView(children: children),
    );
  }
}

/// The site's "Products & services" mega menu, restyled as a modern
/// drawer: branded header, iconed destinations and grouped tool sections.
class GfMenuDrawer extends StatelessWidget {
  const GfMenuDrawer({super.key});

  static const _applicationTools = [
    'Hot Water Recirculation Sizing Tool',
    'iGRID Configurator',
    'Pit Creator',
    'Pumping Station Creator',
  ];
  static const _productTools = [
    'Build your own Pump',
    'MIXIT Sizing Tool',
    'Eica Selection Tool',
    'Dosing Skid Configurator (US)',
    'Dosing Skid Configurator (Europe)',
    'Digital Dosing Pump Selection Tool',
  ];

  void _openTool(BuildContext context, String title) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ToolScreen(tool: AppTool.byTitle(title))));
  }

  @override
  Widget build(BuildContext context) {
    void go(String route) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(route);
    }

    Widget section(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
                color: GfColors.grey600,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2),
          ),
        );

    Widget item(String text, IconData icon,
            {VoidCallback? onTap, bool primary = false}) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            dense: !primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primary
                    ? GfColors.actionBlue.withValues(alpha: 0.1)
                    : GfColors.grey100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  size: 19,
                  color: primary ? GfColors.actionBlue : GfColors.grey700),
            ),
            title: Text(text,
                style: TextStyle(
                    fontSize: primary ? 15.5 : 14,
                    fontWeight: primary ? FontWeight.w700 : FontWeight.w400,
                    color: GfColors.ink)),
            trailing: onTap == null
                ? null
                : const Icon(Icons.chevron_right,
                    size: 18, color: GfColors.grey500),
            onTap: onTap,
          ),
        );

    return Drawer(
      backgroundColor: GfColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Branded header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [GfColors.darkBlue, GfColors.deepBlue],
              ),
            ),
            padding: EdgeInsets.fromLTRB(
                24, MediaQuery.paddingOf(context).top + 28, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLogo(height: 24, onDark: true),
                const SizedBox(height: 14),
                const Text('Products & services',
                    style: TextStyle(
                        fontFamily: 'Qiantao-Extd',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: GfColors.white)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: GfColors.white.withValues(alpha: 0.2),
                      child: Text(
                        Session.instance.displayName.isNotEmpty
                            ? Session.instance.displayName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            color: GfColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        Session.instance.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: GfColors.white.withValues(alpha: 0.9),
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const SizedBox(height: 10),
                item('Qiantao Assist  ·  AI', Icons.auto_awesome,
                    onTap: () => go('/assistant'), primary: true),
                item('Applications', Icons.water_drop_outlined,
                    onTap: () => go('/applications'), primary: true),
                item('Categories', Icons.grid_view_rounded,
                    onTap: () => go('/categories'), primary: true),
                item('Products A-Z', Icons.format_list_bulleted_rounded,
                    onTap: () => go('/products'), primary: true),
                section('Application Tools'),
                for (final t in _applicationTools)
                  item(t, Icons.handyman_outlined,
                      onTap: () => _openTool(context, t)),
                section('Product tools'),
                for (final t in _productTools)
                  item(t, Icons.build_circle_outlined,
                      onTap: () => _openTool(context, t)),
                section('More'),
                item('Calculators', Icons.calculate_outlined, onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const CalculatorsScreen()));
                }),
                item('Product Compare Variants', Icons.compare_arrows_rounded,
                    onTap: () => go('/compare')),
                item('Recently viewed products', Icons.history_rounded,
                    onTap: () => go('/recently-viewed')),
                item('Catalogue Settings', Icons.settings_outlined,
                    onTap: () => go('/settings')),
                item('Contact us', Icons.mail_outline_rounded,
                    onTap: () => go('/contact')),
                const Divider(height: 24, indent: 20, endIndent: 20),
                item('Sign out', Icons.logout_rounded, onTap: () async {
                  Navigator.of(context).pop();
                  await Session.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context)
                        .popUntil((route) => route.isFirst);
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
