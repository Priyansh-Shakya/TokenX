import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:tokenx/core/utils/markdown_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteViewer extends StatelessWidget {
  final String title;
  final AsyncValue<MarkdownWithFrontmatter> content;

  const NoteViewer({super.key, required this.title, required this.content});

  MarkdownStyleSheet _buildStyleSheet(BuildContext context) {
    return MarkdownStyleSheet(
      // Body text
      p: const TextStyle(
        color: Color(0xFFDCDCDC),
        fontSize: 15,
        height: 1.75,
        letterSpacing: 0.1,
      ),
      strong: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      em: const TextStyle(color: Color(0xFFCBCBCD)),
      del: const TextStyle(
        color: Color(0xFF888888),
        decoration: TextDecoration.lineThrough,
      ),

      // Headings
      h1: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      h1Padding: const EdgeInsets.only(top: 36, bottom: 10),
      h2: const TextStyle(
        color: Color(0xFFF0F0F0),
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      h2Padding: const EdgeInsets.only(top: 28, bottom: 8),
      h3: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      h3Padding: const EdgeInsets.only(top: 22, bottom: 6),
      h4: const TextStyle(
        color: Color(0xFFD0D0D0),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      h4Padding: const EdgeInsets.only(top: 16, bottom: 4),

      // Links
      a: const TextStyle(
        color: Color(0xFF9580FF),
        decoration: TextDecoration.underline,
        decorationColor: Color(0x559580FF),
      ),

      // Inline code
      code: const TextStyle(
        color: Color(0xFFFF9580),
        backgroundColor: Color(0xFF1E1E2E),
        fontFamily: 'monospace',
        fontSize: 13.5,
        letterSpacing: 0.2,
      ),

      // Code block background (builder overrides this visually)
      codeblockDecoration: const BoxDecoration(color: Colors.transparent),
      codeblockPadding: EdgeInsets.zero,

      // Blockquote
      blockquote: const TextStyle(
        color: Color(0xFF999999),
        fontSize: 15,
        fontStyle: FontStyle.italic,
        height: 1.6,
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      blockquoteDecoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(4),
        border: const Border(
          left: BorderSide(color: Color(0xFF7C3AED), width: 3.5),
        ),
      ),

      // Lists
      listBullet: const TextStyle(color: Color(0xFF9580FF), fontSize: 15),
      listIndent: 24,
      listBulletPadding: const EdgeInsets.only(right: 8),

      // Table
      tableHead: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      tableBody: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
      tableBorder: TableBorder.all(color: const Color(0xFF2A2A3E), width: 1),
      tableHeadAlign: TextAlign.left,
      tableCellsPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      tableColumnWidth: const FlexColumnWidth(),

      // Divider
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF2A2A3E), width: 1)),
      ),
    );
  }

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
            : <String>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 80),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Note title ──────────────────────────────────
                Text(
                  noteTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    height: 1.2,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: tags.map((t) => _TagChip(tag: t)).toList(),
                  ),
                ],
                const SizedBox(height: 28),
                const Divider(color: Color(0xFF2A2A3E), height: 1),
                const SizedBox(height: 32),

                // ── Markdown body ────────────────────────────────
                MarkdownBody(
                  data: parsed.content,
                  selectable: true,
                  extensionSet: md.ExtensionSet.gitHubFlavored,
                  styleSheet: _buildStyleSheet(context),
                  builders: {'code': _CodeBlockBuilder()},
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
                  imageBuilder: (uri, title, alt) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        uri.toString(),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E2E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Image unavailable',
                              style: TextStyle(color: Colors.white38),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
      ),
      error: (e, _) => const Center(
        child: Text(
          'Failed to load note.',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}

// ── Code block builder ───────────────────────────────────────────

class _CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    // Let inline code pass through to default styling
    final isBlock =
        element.textContent.contains('\n') ||
        element.attributes['class'] != null;
    if (!isBlock) return null;

    // Parse language from class="language-python"
    String language = 'text';
    final cls = element.attributes['class'];
    if (cls != null && cls.startsWith('language-')) {
      language = cls.substring(9).toLowerCase().trim();
      if (language.isEmpty) language = 'text';
    }

    final code = element.textContent.trimRight();

    return _CodeBlock(code: code, language: language);
  }
}

class _CodeBlock extends StatefulWidget {
  final String code;
  final String language;
  const _CodeBlock({required this.code, required this.language});

  @override
  State<_CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<_CodeBlock> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  // Map common aliases to highlight.js language ids
  String get _hlLanguage {
    const map = {
      'py': 'python',
      'js': 'javascript',
      'ts': 'typescript',
      'sh': 'bash',
      'shell': 'bash',
      'zsh': 'bash',
      'md': 'markdown',
      'yml': 'yaml',
      'plaintext': 'plaintext',
      'text': 'plaintext',
    };
    return map[widget.language] ?? widget.language;
  }

  static const _langColors = {
    'python': Color(0xFF3B7EBF),
    'javascript': Color(0xFFF7DF1E),
    'typescript': Color(0xFF3178C6),
    'bash': Color(0xFF4EAA25),
    'dart': Color(0xFF0175C2),
    'yaml': Color(0xFFCB171E),
    'json': Color(0xFFFFD700),
    'markdown': Color(0xFF6B6B6B),
  };

  Color get _langColor =>
      _langColors[widget.language] ?? const Color(0xFF6C63FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF252538)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header bar ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF13132A),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(9),
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0xFF252538)),
              ),
            ),
            child: Row(
              children: [
                // Language dot + label
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _langColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.language,
                  style: TextStyle(
                    color: _langColor.withOpacity(0.9),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),

                // Copy button
                GestureDetector(
                  onTap: _copy,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _copied
                        ? const Row(
                            key: ValueKey('done'),
                            children: [
                              Icon(
                                Icons.check_rounded,
                                size: 13,
                                color: Color(0xFF4EAA25),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Copied',
                                style: TextStyle(
                                  color: Color(0xFF4EAA25),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            key: ValueKey('copy'),
                            children: [
                              Icon(
                                Icons.copy_rounded,
                                size: 13,
                                color: Color(0xFF666680),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Copy',
                                style: TextStyle(
                                  color: Color(0xFF666680),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),

          // ── Code body ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: HighlightView(
              widget.code,
              language: _hlLanguage,
              theme: atomOneDarkTheme,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13.5,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tag chip ─────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.4)),
      ),
      child: Text(
        '#$tag',
        style: const TextStyle(
          color: Color(0xFFAA99FF),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// // FIX: Pointing to the correct singular "flutter_highlight" package locations
// import 'package:flutter_highlight/flutter_highlight.dart';
// import 'package:flutter_highlight/themes/atom-one-dark.dart';
// // FIX: Pointing to the correct singular "flutter_highlight"
// import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:markdown/markdown.dart' as md;
// import 'package:tokenx/core/utils/markdown_parser.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NoteViewer extends StatelessWidget {
//   final String title;
//   final AsyncValue<MarkdownWithFrontmatter> content;

//   const NoteViewer({super.key, required this.title, required this.content});

//   // Reusable styling sheet matching Obsidian Default Dark Theme exactly
//   MarkdownStyleSheet _buildObsidianTheme(BuildContext context) {
//     const primaryText = Color(0xFFE2E2E3);
//     const mutedText = Color(0xFFA3A3A3);
//     const accentPurple = Color(0xFF7C3AED); // Obsidian default accent purple

//     return MarkdownStyleSheet(
//       p: const TextStyle(color: primaryText, fontSize: 15, height: 1.6),
//       strong: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
//       em: const TextStyle(color: Color(0xFFCBCBCD)),

//       // Headings
//       h1: const TextStyle(
//         color: Colors.white,
//         fontSize: 26,
//         fontWeight: FontWeight.w700,
//       ),
//       h1Padding: const EdgeInsets.only(top: 28, bottom: 8),
//       h2: const TextStyle(
//         color: Color(0xFFE5E5E5),
//         fontSize: 20,
//         fontWeight: FontWeight.w600,
//       ),
//       h2Padding: const EdgeInsets.only(top: 22, bottom: 6),
//       h3: const TextStyle(
//         color: Color(0xFFD4D4D4),
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//       ),
//       h3Padding: const EdgeInsets.only(top: 18, bottom: 4),

//       // Hyperlinks
//       a: const TextStyle(
//         color: accentPurple,
//         decoration: TextDecoration.underline,
//       ),

//       // Inline Code Blocks (single backticks)
//       code: const TextStyle(
//         color: Color(0xFFE06C75),
//         backgroundColor:
//             Colors.transparent, // ← was Color(0xFF262626), remove it
//         fontFamily: 'Fira Code',
//         fontSize: 13,
//       ),

//       // Add this new property:
//       codeblockDecoration: const BoxDecoration(
//         color: Colors.transparent, // ← prevents the default whitish block bg
//       ),

//       // Blockquotes
//       blockquote: const TextStyle(
//         color: mutedText,
//         fontStyle: FontStyle.italic,
//       ),
//       blockquotePadding: const EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: 8,
//       ),
//       blockquoteDecoration: const BoxDecoration(
//         color: Color(0xFF202020),
//         border: Border(left: BorderSide(color: Color(0xFF404040), width: 4)),
//       ),

//       // Dividers (<hr>)
//       horizontalRuleDecoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: Color(0xFF2F2F2F), width: 1)),
//       ),

//       // Markdown Tables
//       tableHead: const TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//       ),
//       tableBody: const TextStyle(color: primaryText),
//       tableBorder: TableBorder.all(color: const Color(0xFF2F2F2F), width: 1),
//       tableCellsPadding: const EdgeInsets.all(10),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return content.when(
//       data: (parsed) {
//         final noteTitle = parsed.metadata['title'] as String? ?? title;
//         final description = parsed.metadata['description'] as String?;
//         final tags = parsed.metadata['tags'] is List
//             ? (parsed.metadata['tags'] as List)
//                   .map((e) => e.toString())
//                   .toList()
//             : <String>[];

//         return SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(32, 32, 32, 48),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title Header
//               Text(
//                 noteTitle,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 32,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: -0.5,
//                 ),
//               ),
//               if (description != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     color: Color(0xFFA3A3A3),
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//               if (tags.isNotEmpty) ...[
//                 const SizedBox(height: 14),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 6,
//                   children: tags.map((tag) => _TagChip(tag: tag)).toList(),
//                 ),
//               ],
//               const SizedBox(height: 24),
//               const Divider(color: Color(0xFF2F2F2F)),
//               const SizedBox(height: 20),

//               // Clean Native Markdown Renderer Block
//               MarkdownBody(
//                 data: parsed.content,
//                 selectable: true,
//                 styleSheet: _buildObsidianTheme(context),

//                 // Binding our language-specific parser into code rendering lifecycle
//                 builders: {'code': CodeBlockBuilder()},

//                 onTapLink: (text, href, title) async {
//                   if (href != null) {
//                     final uri = Uri.parse(href);
//                     if (await canLaunchUrl(uri)) {
//                       await launchUrl(
//                         uri,
//                         mode: LaunchMode.externalApplication,
//                       );
//                     }
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//       loading: () => const Center(
//         child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
//       ),
//       error: (e, _) => const Center(
//         child: Text(
//           'Failed to load note.',
//           style: TextStyle(color: Colors.white54),
//         ),
//       ),
//     );
//   }
// }

// /// Custom UI Parser that intercepts code fences and attaches language headers + highlighters
// class CodeBlockBuilder extends MarkdownElementBuilder {
//   @override
//   Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
//     // Gracefully fallback to default markdown styling if text represents generic inline code
//     if (!element.textContent.contains('\n') &&
//         element.attributes['class'] == null) {
//       return null;
//     }

//     // Extract language identifier from class tag string (e.g. "language-python")
//     String language = '';
//     if (element.attributes['class'] != null) {
//       final String classAttribute = element.attributes['class'] as String;
//       if (classAttribute.startsWith('language-')) {
//         language = classAttribute.substring(9);
//       }
//     }

//     final codeSnippet = element.textContent.trimRight();

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: const Color(0xFF161616), // Obsidian standard code blocks
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: const Color(0xFF2C2C2C)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Upper Language Identification Bar
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//             decoration: const BoxDecoration(
//               color: Color(0xFF1E1E1E),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(5),
//                 topRight: Radius.circular(5),
//               ),
//               border: Border(bottom: BorderSide(color: Color(0xFF2C2C2C))),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   language.isEmpty ? 'text' : language.toLowerCase(),
//                   style: const TextStyle(
//                     color: Color(0xFF8E8E8F),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'monospace',
//                   ),
//                 ),
//                 const Icon(
//                   Icons.copy_rounded,
//                   size: 14,
//                   color: Color(0xFF8E8E8F),
//                 ),
//               ],
//             ),
//           ),
//           // Multi-color dynamic highlighted code segment
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: HighlightView(
//   codeSnippet,
//   language: language.isEmpty ? 'plaintext' : language,
//   theme: atomOneDarkTheme,
//   padding: EdgeInsets.zero, // ← removes any internal padding that may show bg
//   textStyle: const TextStyle(
//     fontFamily: 'Fira Code',
//     fontSize: 13.5,
//     height: 1.5,
//   ),
// ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TagChip extends StatelessWidget {
//   final String tag;
//   const _TagChip({required this.tag});
//   @override
//   Widget build(BuildContext context) => Chip(label: Text(tag));
// }
