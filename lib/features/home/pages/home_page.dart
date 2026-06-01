import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/features/experiments/data/sample_experiments.dart';
import 'package:flutter_starter_template/features/experiments/widgets/experiment_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _experimentsKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToExperiments() {
    final context = _experimentsKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Section with TokenX branding
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF667EEA).withOpacity(0.1),
                    const Color(0xFF764BA2).withOpacity(0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: isMobile ? 60 : 100,
                ),
                child: Column(
                  children: [
                    // Logo/Icon Animation
                    Container(
                      width: isMobile ? 80 : 120,
                      height: isMobile ? 80 : 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'TX',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ).animate().scale(
                      duration: 800.ms,
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                    ),
                    const SizedBox(height: 32),
                    // Main Title
                    Text(
                          'TokenX',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                        )
                        .animate(
                          onComplete: (controller) =>
                              controller.repeat(reverse: false),
                        )
                        .shimmer(
                          duration: 3000.ms,
                          color: const Color(0xFF667EEA).withOpacity(0.3),
                        ),
                    const SizedBox(height: 16),
                    // Tagline with gradient text effect
                    ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF667EEA),
                              Color(0xFFF093FB),
                              Color(0xFFF5576C),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Solve with AI',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 1000.ms)
                        .slideY(begin: 0.5, end: 0, duration: 1000.ms),
                    const SizedBox(height: 24),
                    // Subtitle
                    SizedBox(
                          width: isMobile ? screenWidth * 0.85 : 600,
                          child: Text(
                            'Exploring AI, Machine Learning & Research through experiments, documentation, and cutting-edge solutions',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                  height: 1.6,
                                ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 800.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: 800.ms,
                          delay: 200.ms,
                        ),
                    const SizedBox(height: 32),
                    // CTA Buttons
                    Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildCTAButton(
                              context,
                              'Explore Experiments',
                              const Color(0xFF667EEA),
                              const Color(0xFF764BA2),
                              _scrollToExperiments,
                            ),
                            _buildCTAButton(
                              context,
                              'View Source',
                              const Color(0xFFF093FB),
                              const Color(0xFFF5576C),
                              () async {
                                final uri = Uri.parse(
                                  'https://github.com/Priyansh-Shakya/TokenX',
                                );
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              isOutlined: true,
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 800.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: 800.ms,
                          delay: 400.ms,
                        ),
                  ],
                ),
              ),
            ),
            // Experiments Section
            Container(
              key: _experimentsKey,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 48,
                vertical: isMobile ? 60 : 80,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Text(
                        'Latest Experiments',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideX(begin: -0.3, end: 0, duration: 800.ms),
                  const SizedBox(height: 12),
                  // Section Subtitle
                  Text(
                        'Dive into AI/ML research and experiments with detailed notebooks and implementations',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 800.ms)
                      .slideX(
                        begin: -0.3,
                        end: 0,
                        duration: 800.ms,
                        delay: 100.ms,
                      ),
                  const SizedBox(height: 40),
                  // Experiments Grid
                  Column(
                    children: List.generate(
                      sampleExperiments.length,
                      (index) => ExperimentCard(
                        experiment: sampleExperiments[index],
                        index: index,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 48,
                vertical: 40,
              ),
              child: Column(
                children: [
                  Text(
                    '© 2025 TokenX. All rights reserved.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Designed to showcase AI/ML research and experiments',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTAButton(
    BuildContext context,
    String label,
    Color startColor,
    Color endColor,
    VoidCallback onPressed, {
    bool isOutlined = false,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            gradient: isOutlined
                ? null
                : LinearGradient(colors: [startColor, endColor]),
            border: isOutlined ? Border.all(color: startColor, width: 2) : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: !isOutlined
                ? [
                    BoxShadow(
                      color: startColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    ).animate().scale(
      duration: 600.ms,
      begin: const Offset(0.8, 0.8),
      end: const Offset(1, 1),
    );
  }
}
