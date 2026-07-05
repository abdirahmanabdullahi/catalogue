import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Illustrative pump performance curve (Flow Q vs Head H).
///
/// The curve shape follows the standard centrifugal-pump relation
/// H = H0·(1 − (Q/Qmax)²); H0 (max head) and Qmax (max flow) are read
/// from the product's real technical data when available, so the plotted
/// envelope matches the catalogue figures. Marked as "illustrative" in the
/// UI because the true per-model curve lives behind Qiantao' sizing engine.
class PumpCurveChart extends StatelessWidget {
  final double maxFlow; // Qmax, m³/h
  final double maxHead; // H0,  m
  final String flowUnit;
  final String headUnit;

  const PumpCurveChart({
    super.key,
    required this.maxFlow,
    required this.maxHead,
    this.flowUnit = 'm³/h',
    this.headUnit = 'm',
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: CustomPaint(
          painter: _CurvePainter(maxFlow: maxFlow, maxHead: maxHead,
              flowUnit: flowUnit, headUnit: headUnit),
        ),
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  final double maxFlow, maxHead;
  final String flowUnit, headUnit;

  _CurvePainter({
    required this.maxFlow,
    required this.maxHead,
    required this.flowUnit,
    required this.headUnit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padLeft = 40.0, padBottom = 30.0, padTop = 10.0, padRight = 12.0;
    final plot = Rect.fromLTRB(
        padLeft, padTop, size.width - padRight, size.height - padBottom);

    final axisPaint = Paint()
      ..color = GfColors.grey300
      ..strokeWidth = 1;
    final gridPaint = Paint()
      ..color = GfColors.grey200
      ..strokeWidth = 1;

    // Gridlines + axis ticks (4 divisions each way).
    final textStyle = TextStyle(color: GfColors.grey600, fontSize: 10);
    for (var i = 0; i <= 4; i++) {
      final y = plot.bottom - plot.height * i / 4;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      final hVal = (maxHead * i / 4);
      _label(canvas, hVal.toStringAsFixed(0), Offset(plot.left - 6, y),
          textStyle, alignRight: true);

      final x = plot.left + plot.width * i / 4;
      final qVal = (maxFlow * i / 4);
      _label(canvas, qVal.toStringAsFixed(qVal < 10 ? 1 : 0),
          Offset(x, plot.bottom + 6), textStyle, center: true);
    }
    canvas.drawLine(plot.bottomLeft, plot.bottomRight, axisPaint);
    canvas.drawLine(plot.topLeft, plot.bottomLeft, axisPaint);

    Offset pt(double q, double h) => Offset(
          plot.left + plot.width * (q / maxFlow),
          plot.bottom - plot.height * (h / maxHead),
        );

    // Three duty curves (min / mid / max speed) — the family envelope.
    final speeds = [
      (1.0, GfColors.curveBlue, 3.0),
      (0.82, GfColors.curveMid, 2.0),
      (0.64, GfColors.curveLight, 2.0),
    ];
    for (final (frac, color, width) in speeds) {
      final path = Path();
      for (var i = 0; i <= 60; i++) {
        final q = maxFlow * i / 60;
        final h = maxHead * frac * (1 - math.pow(q / maxFlow, 2));
        final o = pt(q, h.clamp(0, maxHead).toDouble());
        i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      }
      // Soft fill under the top curve only.
      if (frac == 1.0) {
        final fill = Path.from(path)
          ..lineTo(pt(maxFlow, 0).dx, pt(maxFlow, 0).dy)
          ..lineTo(pt(0, 0).dx, pt(0, 0).dy)
          ..close();
        canvas.drawPath(
            fill,
            Paint()
              ..shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  GfColors.curveBlue.withValues(alpha: 0.16),
                  GfColors.curveBlue.withValues(alpha: 0.0),
                ],
              ).createShader(plot));
      }
      canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = width
            ..strokeCap = StrokeCap.round);
    }

    // Duty point marker at ~55% flow on the top curve.
    final q = maxFlow * 0.55;
    final h = maxHead * (1 - math.pow(q / maxFlow, 2));
    final dp = pt(q, h.toDouble());
    canvas.drawCircle(dp, 6, Paint()..color = GfColors.white);
    canvas.drawCircle(
        dp,
        6,
        Paint()
          ..color = GfColors.actionBlue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);

    // Axis unit labels.
    _label(canvas, 'Q [$flowUnit]',
        Offset(plot.center.dx, size.height - 2), textStyle, center: true);
  }

  void _label(Canvas canvas, String text, Offset at, TextStyle style,
      {bool center = false, bool alignRight = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = at.dx;
    if (center) dx -= tp.width / 2;
    if (alignRight) dx -= tp.width;
    var dy = at.dy;
    if (alignRight) dy -= tp.height / 2; // vertical center for y-axis
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(_CurvePainter old) =>
      old.maxFlow != maxFlow || old.maxHead != maxHead;
}
