import 'package:flutter/material.dart';

import '../theme.dart';

/// Qiantao wordmark: an emerald droplet mark + "Qiantao" set in the
/// extended display cut. Used in the app bar, drawer and auth screens.
class BrandLogo extends StatelessWidget {
  final double height;
  final bool onDark;

  const BrandLogo({super.key, this.height = 26, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final textColor = onDark ? GfColors.white : GfColors.ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Droplet mark.
        SizedBox(
          width: height * 0.82,
          height: height,
          child: CustomPaint(
            painter: _DropletPainter(
                onDark ? GfColors.white : GfColors.actionBlue),
          ),
        ),
        SizedBox(width: height * 0.28),
        Text('Qiantao',
            style: TextStyle(
              fontFamily: 'Qiantao-Extd',
              fontWeight: FontWeight.w700,
              fontSize: height * 0.78,
              letterSpacing: -0.5,
              color: textColor,
            )),
      ],
    );
  }
}

class _DropletPainter extends CustomPainter {
  final Color color;
  _DropletPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // A rounded water droplet: pointed top, round bottom.
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.5, h * 0.28, w, h * 0.42, w, h * 0.64)
      ..arcToPoint(Offset(w * 0.0, h * 0.64),
          radius: Radius.circular(w * 0.5), clockwise: false)
      ..cubicTo(0, h * 0.42, w * 0.5, h * 0.28, w * 0.5, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    // Inner highlight leaf.
    final leaf = Path()
      ..moveTo(w * 0.5, h * 0.32)
      ..quadraticBezierTo(w * 0.74, h * 0.52, w * 0.5, h * 0.78)
      ..quadraticBezierTo(w * 0.5, h * 0.52, w * 0.5, h * 0.32)
      ..close();
    canvas.drawPath(
        leaf,
        Paint()
          ..color = (color == GfColors.white ? GfColors.actionBlue : GfColors.white)
              .withValues(alpha: 0.9));
  }

  @override
  bool shouldRepaint(_DropletPainter old) => old.color != color;
}
