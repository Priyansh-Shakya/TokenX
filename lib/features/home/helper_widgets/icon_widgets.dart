import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Small animated pill used under the hero to visualize a token stream.
// <bos> [embedd] [infer ] ... <eos> etc
// Appears as a subtle purple chip that fades and rises into view.
class _TokenPill extends StatelessWidget {
  const _TokenPill({super.key, required this.label, required this.delay});

  final String label;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.25),
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
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(delay: delay, duration: 800.ms)
        .then()
        .fade(begin: 0.4, end: 1.0, duration: 1500.ms)
        .then()
        .fade(begin: 1.0, end: 0.4, duration: 1500.ms);
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
        _TokenXLogoIconImpl(size: isMobile ? 120 : 180), //! creates Logo
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

class _TokenXLogoIconImpl extends StatefulWidget {
  const _TokenXLogoIconImpl({required this.size});

  final double size;

  @override
  State<_TokenXLogoIconImpl> createState() => _TokenXLogoIconImplState();
}

class _TokenXLogoIconImplState extends State<_TokenXLogoIconImpl>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _glowController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _introController, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(begin: 0.18, end: 0.30).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_introController, _glowController]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Breathing glow
            Container(
              width: widget.size * 0.75,
              height: widget.size * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF6C63FF,
                    ).withOpacity(_glowAnimation.value),
                    blurRadius: widget.size * 0.22,
                    spreadRadius: widget.size * 0.03,
                  ),
                ],
              ),
            ),

            // Logo
            Image.asset(
              'web_logo.png',
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ],
        ),
      ),
    );
  }
}


//! Old code of logo which has full glitch effect.
/*
 Uses the logo PNG and animates it. 
 class _TokenXLogoIconImpl extends StatefulWidget { 
  const _TokenXLogoIconImpl({required this.size});
  final double size;
  @override State<_TokenXLogoIconImpl> createState() => _TokenXLogoIconImplState(); 
} 
class _TokenXLogoIconImplState extends State<_TokenXLogoIconImpl> with TickerProviderStateMixin {
 late final AnimationController _introController;
  late final AnimationController _floatController;
   late final Animation<double> _scaleAnimation;
    late final Animation<double> _fadeAnimation; @override void initState() {
     super.initState(); _introController = AnimationController( vsync: this,
      duration: const Duration(milliseconds: 900), );
      _floatController = AnimationController( vsync: this, duration: const Duration(seconds: 4),
       )..repeat(reverse: true); _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
        CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic), ); 
        _fadeAnimation = Tween<double>( begin: 0, end: 1, ).animate(CurvedAnimation(parent:
         _introController, curve: Curves.easeOut)); _introController.forward();
          } @override void dispose() { _introController.dispose();
           _floatController.dispose(); super.dispose(); 
           } @override Widget build(BuildContext context) {
            return AnimatedBuilder( animation: 
            Listenable.merge([_introController, _floatController]),
             builder: (context, child) { 
             final floatOffset = (0.5 - (_floatController.value - 0.5).abs()) * 10; 
             return Opacity( opacity: _fadeAnimation.value, 
             child: Transform.translate( offset: Offset(0, -floatOffset), 
             child: Transform.scale(scale: _scaleAnimation.value, child: child), ), ); },
              child: SizedBox( width: widget.size, height: widget.size,
               child: Stack( alignment: Alignment.center, 
               children: [ // Glow Container( width: widget.size * 0.75, height: widget.size * 0.75,
                decoration: BoxDecoration( shape: BoxShape.circle,
                 boxShadow: [ BoxShadow( color: const Color(0xFF6C63FF).withOpacity(0.25),
                  blurRadius: widget.size * 0.35, spreadRadius: widget.size * 0.05, ), ], ), ),
                   // Logo Image.asset( 'web_logo.png', width: widget.size, height: widget.size, f
                   //it: BoxFit.contain, filterQuality: FilterQuality.high, ), ], ), ), ); } }
*/