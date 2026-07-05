import 'package:flutter/material.dart';

import '../theme.dart';

/// Section header used by the site's "deck" blocks
/// (e.g. "Select by category", "Explore our offerings").
class DeckHeader extends StatelessWidget {
  final String title;
  final String? description;
  final bool centered;

  const DeckHeader(
      {super.key, required this.title, this.description, this.centered = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final align =
        centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(title,
              textAlign: centered ? TextAlign.center : TextAlign.start,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontSize: 24, color: GfColors.darkBlue)),
          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(description!,
                textAlign: centered ? TextAlign.center : TextAlign.start,
                style: theme.textTheme.bodyLarge),
          ],
        ],
      ),
    );
  }
}

/// Image tile card used across the category / application / product grids.
///
/// Mirrors the site's card component: optional grey label chip (eyebrow),
/// blue title and a circled arrow button.
class TileCard extends StatelessWidget {
  final String? image;
  final String? eyebrow;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final Widget? badge;
  final double imageHeight;
  final bool bordered;

  /// Cover for photography, contain for product shots on white.
  final BoxFit imageFit;

  const TileCard({
    super.key,
    this.image,
    this.eyebrow,
    required this.title,
    this.description,
    this.onTap,
    this.badge,
    this.imageHeight = 160,
    this.bordered = true,
    this.imageFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 0,
      color: GfColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(bordered ? 8 : 0),
        side: bordered
            ? const BorderSide(color: GfColors.grey300)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              Image.asset(
                image!,
                height: imageHeight,
                width: double.infinity,
                fit: imageFit,
                errorBuilder: (_, _, _) => Container(
                  height: imageHeight,
                  color: GfColors.grey100,
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: GfColors.grey400),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eyebrow != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      color: GfColors.grey500,
                      child: Text(eyebrow!,
                          style: const TextStyle(
                              color: GfColors.white, fontSize: 12)),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 18, color: GfColors.actionBlue)),
                      ),
                      ?badge,
                    ],
                  ),
                  if (description != null && description!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      description!,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: GfColors.grey700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: GfColors.actionBlue, width: 1.5),
                    ),
                    child: const Icon(Icons.arrow_forward,
                        size: 18, color: GfColors.actionBlue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Sizeable" pill shown on sizable product families.
class SizeableBadge extends StatelessWidget {
  const SizeableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: GfColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GfColors.grey300),
      ),
      child: const Text('Sizeable',
          style: TextStyle(fontSize: 12, color: GfColors.grey800)),
    );
  }
}

/// Full-width hero with background image and title, as on the site's
/// standard-hero components.
class PageHero extends StatelessWidget {
  final String title;
  final String? description;
  final String? image;
  final bool dark;

  const PageHero({
    super.key,
    required this.title,
    this.description,
    this.image,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
        image != null || dark ? GfColors.white : GfColors.darkBlue;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      decoration: BoxDecoration(
        color: dark ? GfColors.darkBlue : GfColors.grey100,
        image: image != null
            ? DecorationImage(
                image: AssetImage(image!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.35), BlendMode.darken),
              )
            : null,
      ),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title,
              style: theme.textTheme.displaySmall
                  ?.copyWith(color: textColor, fontSize: 30)),
          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(description!,
                style: theme.textTheme.bodyLarge?.copyWith(color: textColor)),
          ],
        ],
      ),
    );
  }
}
