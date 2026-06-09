import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokenx/features/experiments/data/sample_experiments.dart';
import 'package:tokenx/features/experiments/widgets/experiment_card.dart';
import 'package:tokenx/features/home/helper_widgets/hero_widgets.dart';
import 'package:tokenx/features/home/helper_widgets/home_action.dart';
import 'package:tokenx/features/notes/providers/notes_providers.dart';

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

  void _showTemporaryMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isMobile = screenSize.width < 600;
    final heroHeight = screenSize.height * 0.96;
    final actionSectionHeight = screenSize.height * 0.94;
    final cardWidth = isMobile ? double.infinity : 520.0;
    final actionItems = [
      HomeActionItem(
        title: 'Explore Experiments',
        subtitle: 'AIML Project notebooks to study with.',
        iconData: Icons.science_outlined,
        gradientColors: const [Color(0xFF7C73FF), Color(0xFF5ED0FA)],
        onTap: _scrollToExperiments,
      ),
      HomeActionItem(
        title: 'AI Tools and Models',
        subtitle: 'AI products developed by us.',
        iconData: Icons.smart_toy_outlined,
        gradientColors: const [Color(0xFFFA7AEA), Color(0xFF5A86FF)],
        onTap: () => _showTemporaryMessage('AI Products coming soon'),
      ),
      HomeActionItem(
        title: 'Notes',
        subtitle: 'Learn from our community developers personal notes.',
        iconData: Icons.book_outlined,
        gradientColors: const [Color(0xFF8EF9B7), Color(0xFF6D7BFF)],
        onTap: () => ref.read(selectedTabProvider.notifier).state = 2,
      ),
      HomeActionItem(
        title: 'Community',
        subtitle: 'Join discussions, updates, and ideas',
        iconData: Icons.forum_outlined,
        gradientColors: const [Color(0xFFFF8A6F), Color(0xFF9855FF)],
        onTap: () =>
            _showTemporaryMessage('Community features are coming soon'),
      ),
      // HomeActionItem(
      //   title: 'Source Code',
      //   subtitle: 'Open the GitHub repository',
      //   iconData: Icons.code_outlined,
      //   gradientColors: const [Color(0xFF6F86FF), Color(0xFF42D7FF)],
      //   onTap: () => _launchUrl('https://github.com/Priyansh-Shakya/TokenX'),
      // ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Full-screen hero section
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: heroHeight),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x8A12152E), Color(0x7A0B0E22)],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.white54, width: 1),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 56,
                  vertical: isMobile ? 44 : 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TokenXHero(isMobile: isMobile),
                    const SizedBox(height: 24),
                    Text(
                      'A bold AI lab for new ideas, products, and experiments.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.78),
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 700.ms),
                    const SizedBox(height: 24),
                    Text(
                      'Explore every layer of the UX, research, and AI tooling in a connected product playground.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.6),
                        height: 1.6,
                      ),
                    ).animate().fadeIn(delay: 350.ms, duration: 700.ms),
                  ],
                ),
              ),
            ),
            // Full-screen action cards section
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: actionSectionHeight),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 56,
                vertical: isMobile ? 36 : 52,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start here',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(duration: 700.ms),
                  const SizedBox(height: 12),
                  Text(
                    'Dive straight into the code, models, and research.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.72),
                    ),
                  ).animate().fadeIn(delay: 120.ms, duration: 700.ms),
                  const SizedBox(height: 32),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: actionItems
                          .map(
                            (item) => SizedBox(
                              width: cardWidth,
                              child: HomeActionCard(item: item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            // Experiments Section
            Container(
              key: _experimentsKey,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 56,
                vertical: isMobile ? 60 : 80,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                        'Dive into AI/ML research and experiments with detailed notebooks and implementations.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.72),
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
                horizontal: isMobile ? 24 : 56,
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
                    'Designed to showcase AI/ML research and experiments.',
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
}
