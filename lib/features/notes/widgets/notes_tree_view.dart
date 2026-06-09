import 'package:flutter/material.dart';
import 'package:tokenx/features/notes/models/github_content_model.dart';

// ════════════════════════════════════════════════════════════════════════════
//  DESIGN TOKENS  (keep in sync with note_viewer.dart)
//  Tip: move this class to a shared app_tokens.dart and import it in both
//  files to avoid duplication.
// ════════════════════════════════════════════════════════════════════════════

class _T {
  static const bg = Color(0xFF16161E);
  static const surface = Color(0xFF1E1E2A);
  static const surfaceRaised = Color(0xFF252534);
  static const surfaceHover = Color(0xFF2A2A3A);
  static const border = Color(0xFF2E2E42);
  static const borderStrong = Color(0xFF3E3E58);

  static const textPrimary = Color(0xFFF0F0F8);
  static const textSecondary = Color(0xFFBCBCCC);
  static const textMuted = Color(0xFF7878A0);
  static const textDisabled = Color(0xFF4A4A68);

  static const accent = Color(0xFF8B5CF6);
  static const accentBright = Color(0xFFA78BFA);
  static const accentSoft = Color(0x228B5CF6);
  static const accentBorder = Color(0x558B5CF6);
  static const accentText = Color(0xFFBBA9FF);

  static const r4 = 4.0;
  static const r6 = 6.0;
  static const r8 = 8.0;
}

// ════════════════════════════════════════════════════════════════════════════
//  NOTES TREE VIEW  (public API)
// ════════════════════════════════════════════════════════════════════════════

class NotesTreeView extends StatefulWidget {
  final List<GitHubContent> items;
  final String? selectedPath;
  final void Function(String downloadUrl, String title) onFileTap;

  const NotesTreeView({
    super.key,
    required this.items,
    required this.onFileTap,
    this.selectedPath,
  });

  @override
  State<NotesTreeView> createState() => _NotesTreeViewState();
}

class _NotesTreeViewState extends State<NotesTreeView> {
  // ── Search ────────────────────────────────────────────────────────────────
  //! Search controller and query string.  Typing filters both folder names
  //! and file names across the full tree (recursive).
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Search filter helper ─────────────────────────────────────────────────
  //! Returns true if the item or any of its descendants match the query.
  bool _matches(GitHubContent item) {
    if (_query.isEmpty) return true;
    final name = item.name.toLowerCase();
    if (name.contains(_query)) return true;
    if (item.isDirectory) {
      return item.children.any(_matches);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = widget.items.where(_matches).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! ── Sidebar header ─────────────────────────────────────────────────
        //! Fixed 52 px bar — matches the note topbar height so both panels
        //! share the same baseline when placed side-by-side.
        _SidebarHeader(controller: _searchCtrl, query: _query),

        //! ── Tree list ───────────────────────────────────────────────────────
        Expanded(
          child: visibleItems.isEmpty
              ? _EmptySearch(query: _query)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 32),
                  children: visibleItems
                      .map((item) => _buildItem(item, 0))
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildItem(GitHubContent item, int depth) {
    if (item.isDirectory) {
      return _FolderTile(
        item: item,
        depth: depth,
        selectedPath: widget.selectedPath,
        onFileTap: widget.onFileTap,
        searchQuery: _query,
        // Root-level folders start collapsed; nested ones start expanded
        // so the user navigates top-down, not drowned in everything at once.
        initiallyExpanded: depth == 0 ? false : false,
      );
    }
    return _FileTile(
      item: item,
      depth: depth,
      isSelected: widget.selectedPath == item.downloadUrl,
      onTap: () {
        if (item.downloadUrl != null) {
          widget.onFileTap(item.downloadUrl!, _stripMd(item.name));
        }
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  SIDEBAR HEADER
// ════════════════════════════════════════════════════════════════════════════

class _SidebarHeader extends StatefulWidget {
  final TextEditingController controller;
  final String query;

  const _SidebarHeader({required this.controller, required this.query});

  @override
  State<_SidebarHeader> createState() => _SidebarHeaderState();
}

class _SidebarHeaderState extends State<_SidebarHeader> {
  bool _searchOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _T.surface,
        border: Border(bottom: BorderSide(color: _T.border, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //! Top row: "Notes" label + search toggle + new-note button
          SizedBox(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_stories_outlined,
                    size: 16,
                    color: _T.accentBright,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        color: _T.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  //! Search toggle button
                  _SidebarIconBtn(
                    icon: _searchOpen
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                    active: _searchOpen,
                    onTap: () => setState(() {
                      _searchOpen = !_searchOpen;
                      if (!_searchOpen) widget.controller.clear();
                    }),
                  ),
                  const SizedBox(width: 4),
                  //! New note button (placeholder — wire up as needed)
                  _SidebarIconBtn(icon: Icons.add_rounded, onTap: () {}),
                ],
              ),
            ),
          ),

          //! Search text field — slides in when _searchOpen is true.
          //! Fully functional: typing updates _query which filters the tree.
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: _searchOpen
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: TextField(
                      controller: widget.controller,
                      autofocus: true,
                      style: const TextStyle(
                        color: _T.textSecondary,
                        fontSize: 13,
                      ),
                      cursorColor: _T.accent,
                      decoration: InputDecoration(
                        hintText: 'Search notes…',
                        hintStyle: const TextStyle(
                          color: _T.textDisabled,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 16,
                          color: _T.textMuted,
                        ),
                        suffixIcon: widget.query.isNotEmpty
                            ? GestureDetector(
                                onTap: widget.controller.clear,
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 15,
                                  color: _T.textMuted,
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: _T.surfaceRaised,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_T.r6),
                          borderSide: const BorderSide(
                            color: _T.border,
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_T.r6),
                          borderSide: const BorderSide(
                            color: _T.border,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_T.r6),
                          borderSide: const BorderSide(
                            color: _T.accent,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ── Sidebar icon button ───────────────────────────────────────────────────────

class _SidebarIconBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _SidebarIconBtn({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  State<_SidebarIconBtn> createState() => _SidebarIconBtnState();
}

class _SidebarIconBtnState extends State<_SidebarIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: widget.active
              ? _T.accentSoft
              : _hovered
              ? _T.surfaceHover
              : Colors.transparent,
          borderRadius: BorderRadius.circular(_T.r6),
          border: Border.all(
            color: widget.active ? _T.accentBorder : Colors.transparent,
            width: 0.5,
          ),
        ),
        child: Icon(
          widget.icon,
          size: 15,
          color: widget.active ? _T.accentBright : _T.textMuted,
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  FILE TILE
// ════════════════════════════════════════════════════════════════════════════

class _FileTile extends StatefulWidget {
  final GitHubContent item;
  final int depth;
  final bool isSelected;
  final VoidCallback onTap;

  const _FileTile({
    required this.item,
    required this.depth,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FileTile> createState() => _FileTileState();
}

class _FileTileState extends State<_FileTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final title = _stripMd(widget.item.name);
    final active = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.only(left: widget.depth * 14.0, bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? _T.accentSoft
                : _hovered
                ? _T.surfaceHover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(_T.r6),
            border: Border.all(
              color: active ? _T.accentBorder : Colors.transparent,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              // Depth guide line for indented items
              if (widget.depth > 0)
                Container(
                  width: 1.5,
                  height: 15,
                  margin: const EdgeInsets.only(right: 8),
                  color: active ? _T.accentBorder : _T.border,
                ),

              Icon(
                Icons.article_outlined,
                size: 14,
                color: active ? _T.accentBright : _T.textMuted,
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: active ? _T.accentText : _T.textSecondary,
                    fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),

              // Active indicator dot
              if (active)
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: const BoxDecoration(
                    color: _T.accent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  FOLDER TILE
// ════════════════════════════════════════════════════════════════════════════

class _FolderTile extends StatefulWidget {
  final GitHubContent item;
  final int depth;
  final String? selectedPath;
  final void Function(String, String) onFileTap;
  final String searchQuery;
  final bool initiallyExpanded;

  const _FolderTile({
    required this.item,
    required this.depth,
    required this.selectedPath,
    required this.onFileTap,
    required this.searchQuery,
    this.initiallyExpanded = false, //! Default: folders start COLLAPSED
  });

  @override
  State<_FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<_FolderTile>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _ctrl;
  late final Animation<double> _rotation;
  late final Animation<double> _expand;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    //! If a search is active, auto-expand to reveal matching children.
    _expanded = widget.initiallyExpanded || widget.searchQuery.isNotEmpty;

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: _expanded ? 1.0 : 0.0,
    );
    _rotation = Tween<double>(
      begin: 0,
      end: 0.25,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(_FolderTile old) {
    super.didUpdateWidget(old);
    // Auto-expand when search is typed so results are visible
    if (widget.searchQuery.isNotEmpty && !_expanded) {
      _expanded = true;
      _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  /// True if any descendant file is currently selected.
  bool get _hasActiveChild => _containsSelected(widget.item);
  bool _containsSelected(GitHubContent node) {
    for (final c in node.children) {
      if (c.isDirectory) {
        if (_containsSelected(c)) return true;
      } else if (widget.selectedPath == c.downloadUrl)
        return true;
    }
    return false;
  }

  /// Filter children by search query (recursively).
  bool _matches(GitHubContent item) {
    if (widget.searchQuery.isEmpty) return true;
    if (item.name.toLowerCase().contains(widget.searchQuery)) return true;
    if (item.isDirectory) return item.children.any(_matches);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final folderName = widget.item.name.replaceFirst(RegExp(r'^\d+[.\s]*'), '');
    final highlight = _hasActiveChild;
    final children = widget.item.children.where(_matches).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Folder row ───────────────────────────────────────────────────
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.only(
                left: widget.depth * 14.0,
                top: widget.depth == 0 ? 10 : 4,
                bottom: 2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: _hovered ? _T.surfaceHover : Colors.transparent,
                borderRadius: BorderRadius.circular(_T.r6),
              ),
              child: Row(
                children: [
                  // Animated chevron
                  RotationTransition(
                    turns: _rotation,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 15,
                      color: highlight ? _T.accentBright : _T.textMuted,
                    ),
                  ),
                  const SizedBox(width: 5),

                  // Folder icon
                  Icon(
                    _expanded
                        ? Icons.folder_open_rounded
                        : Icons.folder_rounded,
                    size: 14,
                    color: highlight ? _T.accent : _T.textMuted,
                  ),
                  const SizedBox(width: 8),

                  // Folder name
                  Expanded(
                    child: Text(
                      folderName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: highlight ? _T.accentText : _T.textSecondary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  // Child-count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _T.surfaceRaised,
                      borderRadius: BorderRadius.circular(_T.r4),
                    ),
                    child: Text(
                      '${widget.item.children.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: _T.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Children (animated expand / collapse) ────────────────────────
        SizeTransition(
          sizeFactor: _expand,
          child: FadeTransition(
            opacity: _expand,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children.map(_buildChild).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChild(GitHubContent child) {
    if (child.isDirectory) {
      return _FolderTile(
        item: child,
        depth: widget.depth + 1,
        selectedPath: widget.selectedPath,
        onFileTap: widget.onFileTap,
        searchQuery: widget.searchQuery,
        initiallyExpanded: false, //! Nested folders also start collapsed
      );
    }
    return _FileTile(
      item: child,
      depth: widget.depth + 1,
      isSelected: widget.selectedPath == child.downloadUrl,
      onTap: () {
        if (child.downloadUrl != null) {
          widget.onFileTap(child.downloadUrl!, _stripMd(child.name));
        }
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  EMPTY SEARCH STATE
// ════════════════════════════════════════════════════════════════════════════

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.search_off_rounded, size: 28, color: _T.textDisabled),
        const SizedBox(height: 10),
        Text(
          'No results for "$query"',
          style: const TextStyle(color: _T.textMuted, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  HELPERS
// ════════════════════════════════════════════════════════════════════════════

String _stripMd(String name) => name.replaceAll(RegExp(r'\.md$'), '');
