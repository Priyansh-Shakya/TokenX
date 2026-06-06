import 'package:flutter/material.dart';
import 'package:tokenx/features/notes/models/github_content_model.dart';

class NotesTreeView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: items.map((item) => _buildItem(context, item, 0)).toList(),
    );
  }

  Widget _buildItem(BuildContext context, GitHubContent item, int depth) {
    if (item.isDirectory) {
      return _FolderTile(
        item: item,
        depth: depth,
        selectedPath: selectedPath,
        onFileTap: onFileTap,
      );
    }

    final title = item.name.replaceAll('.md', '');
    final isSelected = selectedPath == item.downloadUrl;

    return GestureDetector(
      onTap: () {
        if (item.downloadUrl != null) onFileTap(item.downloadUrl!, title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(left: depth * 12.0, bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6C63FF).withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFF6C63FF).withOpacity(0.4))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 15,
              color: isSelected
                  ? const Color(0xFF9d99ff)
                  : Colors.white38,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? const Color(0xFFd0ceff) : Colors.white60,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.circle, size: 6, color: Color(0xFF6C63FF)),
          ],
        ),
      ),
    );
  }
}

class _FolderTile extends StatefulWidget {
  final GitHubContent item;
  final int depth;
  final String? selectedPath;
  final void Function(String, String) onFileTap;

  const _FolderTile({
    required this.item,
    required this.depth,
    required this.selectedPath,
    required this.onFileTap,
  });

  @override
  State<_FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<_FolderTile> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            margin: EdgeInsets.only(
                left: widget.depth * 12.0, top: 10, bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: _expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.chevron_right,
                      size: 16, color: Colors.white38),
                ),
                const SizedBox(width: 6),
                Icon(
                  _expanded ? Icons.folder_open : Icons.folder,
                  size: 15,
                  color: const Color(0xFF6C63FF).withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    // strip leading number prefixes like "1 " or "2 "
                    widget.item.name.replaceFirst(RegExp(r'^\d+ '), ''),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          ...widget.item.children.map(
            (child) => _buildChild(context, child),
          ),
      ],
    );
  }

  Widget _buildChild(BuildContext context, GitHubContent child) {
    if (child.isDirectory) {
      return _FolderTile(
        item: child,
        depth: widget.depth + 1,
        selectedPath: widget.selectedPath,
        onFileTap: widget.onFileTap,
      );
    }
    final title = child.name.replaceAll('.md', '');
    final isSelected = widget.selectedPath == child.downloadUrl;

    return GestureDetector(
      onTap: () {
        if (child.downloadUrl != null) {
          widget.onFileTap(child.downloadUrl!, title);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(
            left: (widget.depth + 1) * 12.0, bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6C63FF).withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.4))
              : null,
        ),
        child: Row(
          children: [
            Icon(Icons.article_outlined,
                size: 14,
                color: isSelected
                    ? const Color(0xFF9d99ff)
                    : Colors.white30),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isSelected
                      ? const Color(0xFFd0ceff)
                      : Colors.white54,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.circle,
                  size: 5, color: Color(0xFF6C63FF)),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:tokenx/features/notes/models/github_content_model.dart';

// class NotesTreeView extends StatelessWidget {
//   final List<GitHubContent> items;
//   final String? selectedPath;
//   final void Function(String downloadUrl, String title) onFileTap;

//   const NotesTreeView({
//     super.key,
//     required this.items,
//     required this.onFileTap,
//     this.selectedPath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       children: items.map((item) => _buildItem(context, item)).toList(),
//     );
//   }

//   Widget _buildItem(BuildContext context, GitHubContent item) {
//     if (item.isDirectory) {
//       return ExpansionTile(
//         iconColor: Colors.white70,
//         collapsedIconColor: Colors.white70,
//         title: Text(
//           item.name,
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         children: item.children
//             .map((child) => _buildItem(context, child))
//             .toList(),
//       );
//     }

//     final title = item.name.replaceAll('.md', '');
//     final isSelected = selectedPath == item.downloadUrl;

//     return ListTile(
//       dense: true,
//       contentPadding: const EdgeInsets.only(left: 20, right: 16),
//       title: Text(
//         title,
//         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//           color: isSelected ? Colors.white : Colors.white70,
//           fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
//         ),
//       ),
//       onTap: () {
//         if (item.downloadUrl != null) {
//           onFileTap(item.downloadUrl!, title);
//         }
//       },
//       selected: isSelected,
//       selectedTileColor: Colors.white12,
//       trailing: const Icon(Icons.chevron_right, color: Colors.white54),
//     );
//   }
// }
