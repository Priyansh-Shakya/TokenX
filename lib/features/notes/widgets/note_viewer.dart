import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:tokenx/core/utils/markdown_parser.dart';
import 'package:url_launcher/url_launcher.dart';

// ════════════════════════════════════════════════════════════════════════════
//  DESIGN TOKENS
//  Single source of truth for every color, size, and radius used in this
//  file.  If you move _T to a shared app_tokens.dart, remove this class and
//  import it here and in notes_tree_view.dart.
// ════════════════════════════════════════════════════════════════════════════

class _T {
  // ── Surfaces (light → dark) ───────────────────────────────────────────────
  // Bumped up from the original near-black values so text contrast is
  // comfortable without harsh brightness.
  static const bg = Color(0xFF16161E); //! page / scaffold background
  static const surface = Color(0xFF1E1E2A); //! card / panel background
  static const surfaceRaised = Color(
    0xFF252534,
  ); //! '> xxx' , code block header
  static const surfaceHover = Color(
    0xFF2A2A3A,
  ); //! hover state for interactive rows
  static const border = Color.fromARGB(255, 136, 136, 145); //! default border - code block borders , '---' seperators
  static const borderStrong = Color(0xFF3E3E58); //! emphasis border (hover)

  // ── Text ──────────────────────────────────────────────────────────────────
  // Lightened so all text is comfortable on the new surfaces.
  static const textPrimary = Color(0xFFF0F0F8); //! headings, active labels
  static const textSecondary = Color(
    0xFFBCBCCC,
  ); //! body text — readable, not glaring
  static const textMuted = Color(0xFF7878A0); //! meta, placeholders
  static const textDisabled = Color(0xFF4A4A68); //! truly de-emphasised

  // ── Accent — purple ───────────────────────────────────────────────────────
  static const accent = Color(0xFF8B5CF6); //! primary interactive colour
  static const accentBright = Color(
    0xFFA78BFA,
  ); //! lighter variant for text on dark bg
  static const accentSoft = Color(
    0x228B5CF6,
  ); //! tinted fill (selected row, tag bg)
  static const accentBorder = Color(0x558B5CF6); //! tinted border
  static const accentText = Color(0xFFBBA9FF); //! tag label, active file text

  // ── Syntax ────────────────────────────────────────────────────────────────
  static const syntaxInlineCode = Color(0xFFD19EFF); //! inline `code` text
  static const codeBlockBg = Color(
    0xFF12121A,
  ); //! HighlightView background — darker
  //                                                     than surface so it pops

  // ── Language dot palette ─────────────────────────────────────────────────
  static const langPython = Color(0xFF4E94D4);
  static const langJs = Color(0xFFE5C07B);
  static const langTs = Color(0xFF519ABA);
  static const langBash = Color(0xFF56B06C);
  static const langDart = Color(0xFF0288D1);
  static const langYaml = Color(0xFFE06C75);
  static const langJson = Color(0xFFE5C07B);

  // ── Radii ─────────────────────────────────────────────────────────────────
  static const r4 = 4.0;
  static const r6 = 6.0;
  static const r8 = 8.0;
  static const r20 = 20.0;
}

// ════════════════════════════════════════════════════════════════════════════
//  NOTE VIEWER  (public API)
// ════════════════════════════════════════════════════════════════════════════

class NoteViewer extends StatelessWidget {
  final String title;
  final AsyncValue<MarkdownWithFrontmatter> content;

  const NoteViewer({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.when(
      data: (parsed) => _NoteContent(title: title, parsed: parsed),
      loading: () => const _LoadingState(),
      error: (e, _) => const _ErrorState(),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  LOADED NOTE
// ════════════════════════════════════════════════════════════════════════════

class _NoteContent extends StatelessWidget {
  final String title;
  final MarkdownWithFrontmatter parsed;

  const _NoteContent({required this.title, required this.parsed});

  String get _title => parsed.metadata['title'] as String? ?? title;
  String? get _description => parsed.metadata['description'] as String?;
  List<String> get _tags => parsed.metadata['tags'] is List
      ? (parsed.metadata['tags'] as List).map((e) => e.toString()).toList()
      : [];

  // ── Markdown stylesheet ───────────────────────────────────────────────────
  MarkdownStyleSheet _styleSheet() => MarkdownStyleSheet(
    // Body
    p: const TextStyle(
      color: _T.textSecondary,
      fontSize: 15,
      height: 1.8,
      letterSpacing: 0.1,
    ),
    strong: const TextStyle(color: _T.textPrimary, fontWeight: FontWeight.w600),
    em: const TextStyle(color: _T.textSecondary, fontStyle: FontStyle.italic),
    del: const TextStyle(
      color: _T.textMuted,
      decoration: TextDecoration.lineThrough,
    ),

    // Headings — clear hierarchy, still readable on dark bg
    h1: const TextStyle(
      color: _T.textPrimary,
      fontSize: 26,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      height: 1.25,
    ),
    h1Padding: const EdgeInsets.only(top: 36, bottom: 12),

    h2: const TextStyle(
      color: _T.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.3,
    ),
    h2Padding: const EdgeInsets.only(top: 30, bottom: 10),

    h3: const TextStyle(
      color: _T.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.1,
    ),
    h3Padding: const EdgeInsets.only(top: 22, bottom: 8),

    h4: const TextStyle(
      color: _T.textSecondary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    h4Padding: const EdgeInsets.only(top: 16, bottom: 6),

    // Links
    a: const TextStyle(
      color: _T.accentBright,
      decoration: TextDecoration.underline,
      decorationColor: Color(0x668B5CF6),
      fontSize: 15,
    ),

    // Inline code — visible purple tint, clear background
    code: const TextStyle(
      color: _T.syntaxInlineCode,
      backgroundColor: _T.surfaceRaised,
      fontFamily: 'monospace',
      fontSize: 13,
      letterSpacing: 0.2,
    ),

    // Code block background is transparent — _CodeBlockBuilder owns the visuals
    codeblockDecoration: const BoxDecoration(color: Colors.transparent),
    codeblockPadding: EdgeInsets.zero,

    // Blockquote
    blockquote: const TextStyle(
      color: _T.textSecondary,
      fontSize: 14.5,
      fontStyle: FontStyle.italic,
      height: 1.7,
    ),
    blockquotePadding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
    blockquoteDecoration: BoxDecoration(
      color: _T.surfaceRaised,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(_T.r6),
        bottomRight: Radius.circular(_T.r6),
      ),
      border: const Border(left: BorderSide(color: _T.accent, width: 3)),
    ),

    // Lists
    listBullet: const TextStyle(color: _T.accentBright, fontSize: 15),
    listIndent: 24,
    listBulletPadding: const EdgeInsets.only(right: 10),

    // Tables
    tableHead: const TextStyle(
      color: _T.textPrimary,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
    tableBody: const TextStyle(color: _T.textSecondary, fontSize: 13),
    tableBorder: TableBorder.all(color: _T.border, width: 0.5),
    tableHeadAlign: TextAlign.left,
    tableCellsPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    tableColumnWidth: const FlexColumnWidth(),

    // HR
    horizontalRuleDecoration: const BoxDecoration(
      border: Border(top: BorderSide(color: _T.border, width: 0.5)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! ── Top action bar ────────────────────────────────────────────────
        //! Contains the breadcrumb trail (Notes › note title) on the left and
        //! three action buttons (Edit, Share, More) on the right.
        //! Height is fixed at 52 px to align flush with the sidebar header.
        _NoteTopBar(title: _title),

        //! ── Scrollable body ───────────────────────────────────────────────
        //! Expands to fill ALL remaining space after the topbar.
        //! maxWidth removed — content now fills the full available width.
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(36, 32, 36, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags row
                if (_tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _tags.map((t) => _TagChip(tag: t)).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Note title
                Text(
                  _title,
                  style: const TextStyle(
                    color: _T.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    height: 1.2,
                  ),
                ),

                // Optional description subtitle
                if (_description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _description!,
                    style: const TextStyle(
                      color: _T.textMuted,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],

                // Meta row (date · read time · word count)
                const SizedBox(height: 16),
                _MetaRow(content: parsed.content),

                const SizedBox(height: 22),
                const Divider(color: _T.border, height: 0.5, thickness: 0.5),
                const SizedBox(height: 28),

                // Markdown body — takes full width
                MarkdownBody(
                  data: parsed.content,
                  selectable: true,
                  extensionSet: md.ExtensionSet.gitHubFlavored,
                  styleSheet: _styleSheet(),
                  builders: {'code': _CodeBlockBuilder()},
                  onTapLink: (_, href, __) async {
                    if (href == null) return;
                    final uri = Uri.tryParse(href);
                    if (uri != null && await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  imageBuilder: (uri, title, alt) =>
                      _NoteImage(uri: uri, alt: alt ?? ''),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//! TOP ACTION BAR
//  Fixed 52 px bar at the top of the note pane.
//  Left  → breadcrumb: Notes icon › note title (truncated)
//  Right → three action buttons: Edit | Share | More (⋯)
//  Each button is 36×36 px with a visible border so they never disappear
//  against the background.
// ════════════════════════════════════════════════════════════════════════════

class _NoteTopBar extends StatelessWidget {
  final String title;
  const _NoteTopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: _T.surface,
        border: Border(bottom: BorderSide(color: _T.border, width: 0.5)),
      ),
      child: Row(
        children: [
          //! Breadcrumb — "Notes  ›  Note Title"
          const Icon(
            Icons.auto_stories_outlined,
            size: 15,
            color: _T.textMuted,
          ),
          const SizedBox(width: 6),
          const Text(
            'Notes',
            style: TextStyle(fontSize: 13, color: _T.textMuted),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '›',
              style: TextStyle(
                fontSize: 14,
                color: _T.textDisabled,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _T.textSecondary,
              ),
            ),
          ),

          //! Action buttons — deliberately sized at 36×36 with a visible
          //! border so they stand out against the dark topbar background.
          const SizedBox(width: 8),
          _ActionButton(
            icon: Icons.edit_outlined,
            tooltip: 'Edit note',
            onTap: () {},
          ),
          const SizedBox(width: 6),
          _ActionButton(
            icon: Icons.ios_share_outlined,
            tooltip: 'Share note',
            onTap: () {},
          ),
          const SizedBox(width: 6),
          _ActionButton(
            icon: Icons.more_horiz_rounded,
            tooltip: 'More options',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

//! Single icon button used in _NoteTopBar.
//! 36×36 px, bordered, with hover highlight.
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hovered ? _T.surfaceHover : Colors.transparent,
              borderRadius: BorderRadius.circular(_T.r6),
              border: Border.all(
                color: _hovered ? _T.borderStrong : _T.border,
                width: 0.5,
              ),
            ),
            child: Icon(widget.icon, size: 16, color: _T.textSecondary),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  META ROW  (date · read time · word count)
// ════════════════════════════════════════════════════════════════════════════

class _MetaRow extends StatelessWidget {
  final String content;
  const _MetaRow({required this.content});

  int get _wordCount => content.trim().split(RegExp(r'\s+')).length;
  String get _readTime => '${(_wordCount / 200).ceil()} min read';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = '${_month(now.month)} ${now.day}, ${now.year}';

    return Wrap(
      spacing: 18,
      runSpacing: 6,
      children: [
        _meta(Icons.calendar_today_outlined, date),
        _meta(Icons.schedule_outlined, _readTime),
        _meta(Icons.text_snippet_outlined, '$_wordCount words'),
      ],
    );
  }

  String _month(int m) => const [
    '',
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
  ][m];

  Widget _meta(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: _T.textMuted),
      const SizedBox(width: 5),
      Text(
        label,
        style: const TextStyle(
          color: _T.textMuted,
          fontSize: 12.5,
          letterSpacing: 0.1,
        ),
      ),
    ],
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  IMAGE BUILDER
// ════════════════════════════════════════════════════════════════════════════

class _NoteImage extends StatelessWidget {
  final Uri uri;
  final String alt;
  const _NoteImage({required this.uri, required this.alt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_T.r8),
            child: Image.network(
              uri.toString(),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                height: 96,
                decoration: BoxDecoration(
                  color: _T.surfaceRaised,
                  borderRadius: BorderRadius.circular(_T.r8),
                  border: Border.all(color: _T.border, width: 0.5),
                ),
                child: const Center(
                  child: Text(
                    'Image unavailable',
                    style: TextStyle(color: _T.textDisabled, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          if (alt.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              alt,
              style: const TextStyle(
                color: _T.textMuted,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  CODE BLOCK BUILDER  (MarkdownElementBuilder)
// ════════════════════════════════════════════════════════════════════════════

class _CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    // Inline code → fall through to stylesheet styling
    final isBlock =
        element.textContent.contains('\n') ||
        element.attributes['class'] != null;
    if (!isBlock) return null;

    String language = 'text';
    final cls = element.attributes['class'];
    if (cls != null && cls.startsWith('language-')) {
      final lang = cls.substring(9).toLowerCase().trim();
      if (lang.isNotEmpty) language = lang;
    }

    return _CodeBlock(
      code: element.textContent.trimRight(),
      language: language,
    );
  }
}

// ── Code block widget ─────────────────────────────────────────────────────────

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

  static const _aliases = {
    'py': 'python',
    'js': 'javascript',
    'ts': 'typescript',
    'sh': 'bash',
    'shell': 'bash',
    'zsh': 'bash',
    'md': 'markdown',
    'yml': 'yaml',
    'text': 'plaintext',
    'plaintext': 'plaintext',
  };

  String get _hlLanguage => _aliases[widget.language] ?? widget.language;

  static const _langColors = {
    'python': _T.langPython,
    'javascript': _T.langJs,
    'typescript': _T.langTs,
    'bash': _T.langBash,
    'dart': _T.langDart,
    'yaml': _T.langYaml,
    'json': _T.langJson,
  };

  Color get _langColor => _langColors[widget.language] ?? _T.accent;

  // Custom theme: same as atomOneDark but with our bg token so the
  // white-box artefact is eliminated.
  Map<String, TextStyle> get _theme => {
    ...atomOneDarkTheme,
    'root': TextStyle(
      color: const Color(0xFFABB2BF),
       backgroundColor: _T.codeBlockBg,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: _T.codeBlockBg,
        borderRadius: BorderRadius.circular(_T.r8),
        border: Border.all(color: const Color.fromARGB(255, 177, 177, 182), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _CodeHeader(
            language: widget.language,
            langColor: _langColor,
            copied: _copied,
            onCopy: _copy,
          ),
          // Body — horizontally scrollable for long lines
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(18),
            child: HighlightView(
              widget.code,
              language: _hlLanguage,
              theme: _theme,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13.5,
                height: 1.7,
                letterSpacing: 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Code block header bar ─────────────────────────────────────────────────────

class _CodeHeader extends StatelessWidget {
  final String language;
  final Color langColor;
  final bool copied;
  final VoidCallback onCopy;

  const _CodeHeader({
    required this.language,
    required this.langColor,
    required this.copied,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _T.surfaceRaised,
        border: const Border(bottom: BorderSide(color: _T.border, width: 0.5)),
      ),
      child: Row(
        children: [
          // Language indicator dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: langColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          // Language label
          Text(
            language,
            style: TextStyle(
              color: langColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
              letterSpacing: 0.8,
            ),
          ),
          const Spacer(),
          // Copy button with animated feedback
          GestureDetector(
            onTap: onCopy,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: copied
                  ? const _CopyLabel(
                      key: ValueKey('done'),
                      icon: Icons.check_rounded,
                      label: 'Copied',
                      color: Color(0xFF56B06C),
                    )
                  : const _CopyLabel(
                      key: ValueKey('copy'),
                      icon: Icons.copy_rounded,
                      label: 'Copy',
                      color: Color.fromARGB(255, 167, 167, 185),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CopyLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 5),
      Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  TAG CHIP
// ════════════════════════════════════════════════════════════════════════════

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _T.accentSoft,
        borderRadius: BorderRadius.circular(_T.r20),
        border: Border.all(color: _T.accentBorder, width: 0.5),
      ),
      child: Text(
        '#$tag',
        style: const TextStyle(
          color: _T.accentText,
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  LOADING / ERROR STATES
// ════════════════════════════════════════════════════════════════════════════

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) => const Center(
    child: SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(color: _T.accent, strokeWidth: 2),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline_rounded, size: 28, color: _T.textMuted),
        const SizedBox(height: 10),
        const Text(
          'Failed to load note',
          style: TextStyle(color: _T.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          'Check your connection and try again.',
          style: TextStyle(color: _T.textDisabled, fontSize: 12),
        ),
      ],
    ),
  );
}
