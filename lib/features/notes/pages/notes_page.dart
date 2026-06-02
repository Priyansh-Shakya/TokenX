import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokenx/features/notes/models/github_content_model.dart';
import 'package:tokenx/features/notes/providers/notes_providers.dart';
import 'package:tokenx/features/notes/widgets/note_viewer.dart';
import 'package:tokenx/features/notes/widgets/notes_tree_view.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  String? currentTitle;
  String? currentDownloadUrl;

  @override
  Widget build(BuildContext context) {
    final notesTree = ref.watch(notesTreeProvider);
    final selectedPath = ref.watch(selectedNotePathProvider);
    final isWide = MediaQuery.sizeOf(context).width > 900;
    final fileContent = currentDownloadUrl != null
        ? ref.watch(markdownFileProvider(currentDownloadUrl!))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Explorer'),
        backgroundColor: const Color(0xFF0F0F1E),
        elevation: 0,
      ),
      drawer: !isWide
          ? Drawer(
              backgroundColor: const Color(0xFF0F0F1E),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Notes Folder',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: notesTree.when(
                        data: (items) => NotesTreeView(
                          items: items,
                          selectedPath: selectedPath,
                          onFileTap: _openNote,
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(
                          child: Text(
                            'Unable to load notes. Please try again.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: notesTree.when(
        data: (items) {
          if (selectedPath == null && currentDownloadUrl == null) {
            final firstFile = _findFirstFile(items);
            if (firstFile != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  currentDownloadUrl = firstFile.downloadUrl;
                  currentTitle = firstFile.name.replaceAll('.md', '');
                });
                ref.read(selectedNotePathProvider.notifier).state =
                    firstFile.downloadUrl;
              });
            }
          }

          return Row(
            children: [
              if (isWide)
                Container(
                  width: 320,
                  color: const Color(0xFF12122B),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Notes Explorer',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Browse your Notes folder structure and open markdown files.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: NotesTreeView(
                            items: items,
                            selectedPath: selectedPath,
                            onFileTap: _openNote,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  color: const Color(0xFF0F0F1E),
                  child: currentDownloadUrl != null && fileContent != null
                      ? NoteViewer(
                          title: currentTitle ?? 'Note',
                          content: fileContent,
                        )
                      : Center(
                          child: Text(
                            'Select a note from the sidebar to view its content.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white70),
                          ),
                        ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Unable to load notes. Please try again.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  GitHubContent? _findFirstFile(List<GitHubContent> items) {
    for (final item in items) {
      if (item.isFile && item.downloadUrl != null) {
        return item;
      }
      if (item.isDirectory) {
        final found = _findFirstFile(item.children);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  void _openNote(String downloadUrl, String title) {
    setState(() {
      currentDownloadUrl = downloadUrl;
      currentTitle = title;
    });
    ref.read(selectedNotePathProvider.notifier).state = downloadUrl;
  }
}
