import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/core/utils/markdown_parser.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

class NoteViewer extends StatelessWidget {
  final String title;
  final AsyncValue<MarkdownWithFrontmatter> content;

  const NoteViewer({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.when(
      data: (parsed) {
        final noteTitle = parsed.metadata['title'] as String? ?? title;
        final description = parsed.metadata['description'] as String?;
        final tags = parsed.metadata['tags'] is List
            ? (parsed.metadata['tags'] as List)
                  .map((e) => e.toString())
                  .toList()
            : [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                noteTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
              ],
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '#$tag',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 20),
              MarkdownBody(
                data: parsed.content,
                selectable: true,
                extensionSet: md.ExtensionSet.gitHubWeb,
                imageBuilder: (uri, title, alt) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 860),
                      child: Image.network(
                        uri.toString(),
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImageFallback(context, uri, alt),
                      ),
                    ),
                  ),
                ),
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                      p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.6,
                      ),
                      h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      h2: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      h3: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      em: const TextStyle(color: Colors.white70),
                      blockquote: TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        backgroundColor: Colors.white10,
                      ),
                      code: TextStyle(
                        color: Colors.greenAccent.shade100,
                        backgroundColor: Colors.transparent,
                        fontFamily: 'monospace',
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      codeblockPadding: const EdgeInsets.all(16),
                      listBullet: TextStyle(color: Colors.white70),
                      tableHead: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      tableBody: TextStyle(color: Colors.white70),
                    ),
                onTapLink: (text, href, title) async {
                  if (href != null) {
                    final uri = Uri.parse(href);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Failed to load note. Please try again.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildImageFallback(BuildContext context, Uri uri, String? alt) {
    final label = alt?.isNotEmpty == true ? alt : uri.toString();
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: TextButton(
          onPressed: () async {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Text(
            'Open image: $label',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
