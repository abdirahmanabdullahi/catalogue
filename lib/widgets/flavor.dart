import 'package:flutter/material.dart';

import '../theme.dart';

/// Small uppercase eyebrow label above section headings.
class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;

  const Eyebrow(this.text, {super.key, this.color = GfColors.actionBlue});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    );
  }
}

/// A compact metric tile (big number + label) used in stat rows.
class StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final bool onDark;

  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.onDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueColor = onDark ? GfColors.white : GfColors.darkBlue;
    final labelColor = onDark ? GfColors.grey300 : GfColors.grey600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: onDark ? GfColors.white.withValues(alpha: 0.08) : GfColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: onDark
                ? GfColors.white.withValues(alpha: 0.18)
                : GfColors.grey200),
        boxShadow: onDark ? null : gfCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: onDark ? GfColors.lightBlue : GfColors.actionBlue),
            const SizedBox(height: 8),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: 'Qiantao-Extd',
                    fontWeight: FontWeight.w700,
                    fontSize: 21,
                    height: 1.0,
                    color: valueColor)),
          ),
          const SizedBox(height: 4),
          Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5, height: 1.25, color: labelColor)),
        ],
      ),
    );
  }
}

/// Gradient hero band with eyebrow, title, subtitle and optional actions.
class GradientHero extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? trailing;
  final Gradient gradient;
  final EdgeInsets padding;

  const GradientHero({
    super.key,
    this.eyebrow,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.trailing,
    this.gradient = GfGradients.hero,
    this.padding = const EdgeInsets.fromLTRB(20, 40, 20, 36),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (eyebrow != null) ...[
            Eyebrow(eyebrow!, color: GfColors.lightBlue),
            const SizedBox(height: 10),
          ],
          Text(title,
              style: const TextStyle(
                  fontFamily: 'Qiantao-Extd',
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  height: 1.12,
                  color: GfColors.white)),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Text(subtitle!,
                style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: GfColors.white.withValues(alpha: 0.9))),
          ],
          if (trailing != null) ...[const SizedBox(height: 20), trailing!],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 24),
            Wrap(spacing: 12, runSpacing: 12, children: actions),
          ],
        ],
      ),
    );
  }
}

/// White pill button for use on dark/gradient surfaces.
class LightPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;

  const LightPillButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Flexible(
          child: Text(label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
    return filled
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: GfColors.white,
              foregroundColor: GfColors.deepBlue,
            ),
            onPressed: onPressed,
            child: child,
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: GfColors.white,
              side: const BorderSide(color: GfColors.white, width: 1.5),
            ),
            onPressed: onPressed,
            child: child,
          );
  }
}

/// Rounded feature card with an icon chip, title and body.
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.iconColor = GfColors.actionBlue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GfColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GfColors.grey200),
        boxShadow: gfCardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 14),
                Text(title,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: GfColors.ink)),
                const SizedBox(height: 6),
                Text(body,
                    style: const TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: GfColors.grey700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
