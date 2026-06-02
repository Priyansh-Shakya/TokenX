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
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: items.map((item) => _buildItem(context, item)).toList(),
    );
  }

  Widget _buildItem(BuildContext context, GitHubContent item) {
    if (item.isDirectory) {
      return ExpansionTile(
        iconColor: Colors.white70,
        collapsedIconColor: Colors.white70,
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        children: item.children
            .map((child) => _buildItem(context, child))
            .toList(),
      );
    }

    final title = item.name.replaceAll('.md', '');
    final isSelected = selectedPath == item.downloadUrl;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 20, right: 16),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      onTap: () {
        if (item.downloadUrl != null) {
          onFileTap(item.downloadUrl!, title);
        }
      },
      selected: isSelected,
      selectedTileColor: Colors.white12,
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
    );
  }
}
