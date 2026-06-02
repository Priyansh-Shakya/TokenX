import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Small animated pill used under the hero to visualize a token stream.
// Appears as a subtle purple chip that fades and rises into view.
class _TokenPill extends StatelessWidget {
  const _TokenPill({super.key, required this.label, required this.delay});

  final String label;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.08),
            border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF7B74FF),
              letterSpacing: 0.05,
              fontSize: 10,
            ),
          ),
        )
        .animate()
        .fadeIn(delay: delay, duration: 600.ms)
        .moveY(begin: 8, end: 0, duration: 600.ms, delay: delay);
  }
}

// The main hero widget for the home page. Stacks the bracketed icon,
// the `TokenX` wordmark, and the token stream. Sized responsively
// to fill most of the viewport so experiments sit off-screen until scroll.
class TokenXHero extends StatelessWidget {
  const TokenXHero({super.key, required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TokenXLogoIcon(size: isMobile ? 120 : 180),
        const SizedBox(height: 30),
        _TokenXWordmark(isMobile: isMobile),
        const SizedBox(height: 36),
        const _TokenXTokenStream(),
        const SizedBox(height: 36),
        SizedBox(
              width: isMobile ? screenWidth * 0.95 : 760,
              child: Text(
                'Exploring AI, Machine Learning & Research through experiments, documentation, and cutting-edge solutions',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  height: 1.8,
                  fontSize: isMobile ? 15 : 18,
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 800.ms)
            .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 200.ms),
      ],
    );
  }
}

// Renders the bracketed square icon mark. Uses a custom painter
// so the mark matches the SVG look and scales crisply.
class _TokenXLogoIcon extends StatelessWidget {
  const _TokenXLogoIcon({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _TokenXIconPainter()).animate().scale(
        duration: 900.ms,
        begin: const Offset(0.92, 0.92),
        end: const Offset(1.0, 1.0),
        curve: Curves.easeInOut,
      ),
    );
  }
}

// Renders the `TokenX` wordmark. The `X` is drawn as an outlined
// character layered over a faint offset to create the embossed look.
class _TokenXWordmark extends StatelessWidget {
  const _TokenXWordmark({super.key, required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final wordmarkStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
      fontSize: isMobile ? 56 : 94,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.03,
      height: 1,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Token',
              style: wordmarkStyle?.copyWith(color: const Color(0xFFF0F0FF)),
            ),
            const SizedBox(width: 6),
            Stack(
              children: [
                Transform.translate(
                  offset: const Offset(3, 3),
                  child: Text(
                    'X',
                    style: wordmarkStyle?.copyWith(
                      color: const Color(0xFF6C63FF).withOpacity(0.18),
                    ),
                  ),
                ),
                Text(
                  'X',
                  style: wordmarkStyle?.copyWith(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = const Color(0xFF6C63FF),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'AI · ML · Community',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF5A567A),
            letterSpacing: 1.6,
            fontSize: isMobile ? 12 : 14,
          ),
        ),
      ],
    );
  }
}

// Group of small token chips below the wordmark to add motion and flavor.
class _TokenXTokenStream extends StatelessWidget {
  const _TokenXTokenStream({super.key});

  @override
  Widget build(BuildContext context) {
    const tokens = [
      '<bos>',
      'learn',
      '▸ embed',
      'experiment',
      '▸ infer',
      'build',
      '<eos>',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(
        tokens.length,
        (index) => _TokenPill(
          label: tokens[index],
          delay: Duration(milliseconds: 150 * index),
        ),
      ),
    );
  }
}

// Paints the bracketed square icon mark used by the hero.
// Draws left/right brackets, a simple alphabetic `X` (two crossing
// straight strokes), a center node and small corner accents.
class _TokenXIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 64;
    final rect = Offset.zero & size;
    final backgroundShader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1A1730), Color(0xFF0D0D18)],
    ).createShader(rect);

    final backgroundPaint = Paint()..shader = backgroundShader;
    final borderPaint = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(14));
    canvas.drawRRect(rrect, backgroundPaint);
    canvas.drawRRect(rrect, borderPaint);

    final bracketShader = const LinearGradient(
      colors: [Color(0xFF4F46E5), Color(0xFF7C73FF)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(rect);

    final bracketPaint = Paint()
      ..shader = bracketShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5);

    final leftBracket = Path()
      ..moveTo(14 * scale, 20 * scale)
      ..lineTo(8 * scale, 20 * scale)
      ..lineTo(8 * scale, 44 * scale)
      ..lineTo(14 * scale, 44 * scale);
    final rightBracket = Path()
      ..moveTo(50 * scale, 20 * scale)
      ..lineTo(56 * scale, 20 * scale)
      ..lineTo(56 * scale, 44 * scale)
      ..lineTo(50 * scale, 44 * scale);

    canvas.drawPath(leftBracket, bracketPaint);
    canvas.drawPath(rightBracket, bracketPaint);

    // Draw a simple, solid alphabetic X without gradient/blur to keep it
    // crisp and typographic (no metallic/cylindrical appearance).
    final xPaint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.butt;

    canvas.drawLine(
      Offset(22 * scale, 22 * scale),
      Offset(42 * scale, 42 * scale),
      xPaint,
    );
    canvas.drawLine(
      Offset(42 * scale, 22 * scale),
      Offset(22 * scale, 42 * scale),
      xPaint,
    );

    final centerDot = Paint()..color = const Color(0xFF6C63FF);
    canvas.drawCircle(Offset(32 * scale, 32 * scale), 4 * scale, centerDot);
    canvas.drawCircle(
      Offset(32 * scale, 32 * scale),
      2 * scale,
      Paint()..color = const Color(0xFFC4C0FF),
    );

    final accentPaint = Paint()
      ..color = const Color(0xFF4F46E5).withOpacity(0.7);
    const dots = [
      Offset(22, 22),
      Offset(42, 22),
      Offset(22, 42),
      Offset(42, 42),
    ];
    for (final dot in dots) {
      canvas.drawCircle(
        Offset(dot.dx * scale, dot.dy * scale),
        2 * scale,
        accentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
