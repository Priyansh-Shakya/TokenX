import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_starter_template/features/experiments/models/experiment_model.dart';

class ExperimentCard extends StatefulWidget {
  final ExperimentModel experiment;
  final int index;

  const ExperimentCard({super.key, required this.experiment, this.index = 0});

  @override
  State<ExperimentCard> createState() => _ExperimentCardState();
}

class _ExperimentCardState extends State<ExperimentCard> {
  bool isHovered = false;

  // Gradient colors for different tag types
  static const Map<String, List<Color>> gradientMap = {
    'Deep Learning': [Color(0xFF667EEA), Color(0xFF764BA2)],
    'NLP': [Color(0xFFF093FB), Color(0xFFF5576C)],
    'LLM': [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    'CNN': [Color(0xFFFA709A), Color(0xFFFECE34)],
    'Classification': [Color(0xFF30CFD0), Color(0xFF330867)],
    'Transformers': [Color(0xFF1FA2FF), Color(0xFF12D8FA)],
    'Vector DB': [Color(0xFFA8EDEA), Color(0xFFFED6E3)],
    'RAG': [Color(0xFFFF9A56), Color(0xFFFF6A88)],
  };

  List<Color> _getGradientForTag(String tag) {
    return gradientMap[tag] ??
        [const Color(0xFF667EEA), const Color(0xFF764BA2)];
  }

  String _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 'Beginner • 🟢';
      case 'intermediate':
        return 'Intermediate • 🟡';
      case 'advanced':
        return 'Advanced • 🔴';
      default:
        return difficulty;
    }
  }

  Future<void> _launchGithub() async {
    final Uri uri = Uri.parse(widget.experiment.githubLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Animate(
        effects: [
          SlideEffect(
            duration: 600.ms,
            delay: (widget.index * 100).ms,
            begin: const Offset(0, 20),
            end: Offset.zero,
          ),
          FadeEffect(duration: 600.ms, delay: (widget.index * 100).ms),
        ],
        child: Container(
          margin: EdgeInsets.only(bottom: isMobile ? 16 : 20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _launchGithub,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isHovered ? 0.3 : 0.1),
                      blurRadius: isHovered ? 20 : 10,
                      offset: Offset(0, isHovered ? 8 : 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Gradient Background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getGradientForTag(
                              widget.experiment.tags.first,
                            ).first.withOpacity(0.15),
                            _getGradientForTag(
                              widget.experiment.tags.first,
                            ).last.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                    // Glass morphism effect
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.05),
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Title and Difficulty Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.experiment.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'by ${widget.experiment.author}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _getDifficultyColor(
                                        widget.experiment.difficulty,
                                      ).contains('Beginner')
                                      ? const Color(0xFF10B981).withOpacity(0.2)
                                      : _getDifficultyColor(
                                          widget.experiment.difficulty,
                                        ).contains('Intermediate')
                                      ? const Color(0xFFFBBF24).withOpacity(0.2)
                                      : const Color(
                                          0xFFEF4444,
                                        ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        _getDifficultyColor(
                                          widget.experiment.difficulty,
                                        ).contains('Beginner')
                                        ? const Color(0xFF10B981)
                                        : _getDifficultyColor(
                                            widget.experiment.difficulty,
                                          ).contains('Intermediate')
                                        ? const Color(0xFFFBBF24)
                                        : const Color(0xFFEF4444),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getDifficultyColor(
                                    widget.experiment.difficulty,
                                  ),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Description
                          Text(
                            widget.experiment.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          // Concepts (if available)
                          if (widget.experiment.concepts != null &&
                              widget.experiment.concepts!.isNotEmpty) ...[
                            Text(
                              'Concepts',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.experiment.concepts!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontStyle: FontStyle.italic,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                          ],
                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.experiment.tags
                                .take(3)
                                .map((tag) => _buildTagChip(tag))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          // Bottom Row: Date and CTA Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Published: ${widget.experiment.createdAt.day} ${_getMonthName(widget.experiment.createdAt.month)} ${widget.experiment.createdAt.year}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: Colors.white60),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child:
                                    Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                _getGradientForTag(
                                                  widget.experiment.tags.first,
                                                ).first,
                                                _getGradientForTag(
                                                  widget.experiment.tags.first,
                                                ).last,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            boxShadow: isHovered
                                                ? [
                                                    BoxShadow(
                                                      color: _getGradientForTag(
                                                        widget
                                                            .experiment
                                                            .tags
                                                            .first,
                                                      ).first.withOpacity(0.5),
                                                      blurRadius: 12,
                                                      spreadRadius: 0,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Text(
                                            'View Notebook',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        )
                                        .animate(target: isHovered ? 1 : 0)
                                        .scale(
                                          duration: 200.ms,
                                          begin: const Offset(1, 1),
                                          end: const Offset(1.05, 1.05),
                                        ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    final colors = _getGradientForTag(tag);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '#$tag',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
