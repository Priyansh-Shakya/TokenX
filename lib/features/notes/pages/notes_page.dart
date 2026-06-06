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
  // In _NotesPageState, replace the drawer + body with this:

  @override
  Widget build(BuildContext context) {
    final notesTree = ref.watch(notesTreeProvider);
    final selectedPath = ref.watch(selectedNotePathProvider);
    final isWide = MediaQuery.sizeOf(context).width > 900;
    final fileContent = currentDownloadUrl != null
        ? ref.watch(markdownFileProvider(currentDownloadUrl!))
        : null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Mobile: floating button to open notes list
      floatingActionButton: !isWide
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF6C63FF),
              mini: true,
              onPressed: () => _showMobileNotesPicker(context, notesTree),
              child: const Icon(
                Icons.menu_book_outlined,
                color: Colors.white,
                size: 20,
              ),
            )
          : null,
      body: notesTree.when(
        data: (items) {
          // auto-select first file
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
                  width: 280,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0C0B1A),
                    border: Border(right: BorderSide(color: Color(0xFF1e1e35))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.menu_book_outlined,
                              color: Color(0xFF6C63FF),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Notes',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'AI · ML · Research',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white30,
                                letterSpacing: 1,
                                fontSize: 10,
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFF1e1e35), height: 1),
                      const SizedBox(height: 8),
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
              Expanded(
                child: Container(
                  color: const Color(0xFF0F0F1E),
                  child: currentDownloadUrl != null && fileContent != null
                      ? NoteViewer(
                          title: currentTitle ?? 'Note',
                          content: fileContent,
                        )
                      : const Center(
                          child: Text(
                            'Select a note to read',
                            style: TextStyle(color: Colors.white24),
                          ),
                        ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
        error: (e, _) {
          debugPrint("Error: $e");
          return Center(
            child: Text(
              'Unable to load notes.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white54),
            ),
          );
        },
      ),
    );
  }

  void _showMobileNotesPicker(BuildContext context, AsyncValue notesTree) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C0B1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (_, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    color: Color(0xFF6C63FF),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Notes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Color(0xFF1e1e35)),
            Expanded(
              child: notesTree.when(
                data: (items) => NotesTreeView(
                  items: items,
                  selectedPath: ref.read(selectedNotePathProvider),
                  onFileTap: (url, title) {
                    _openNote(url, title);
                    Navigator.pop(context);
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                ),
                error: (e, _) => const Center(
                  child: Text(
                    'Failed to load',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
              ),
            ),
          ],
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

  //   @override
  //   Widget build(BuildContext context) {
  //     final notesTree = ref.watch(notesTreeProvider);
  //     final selectedPath = ref.watch(selectedNotePathProvider);
  //     final isWide = MediaQuery.sizeOf(context).width > 900;
  //     final fileContent = currentDownloadUrl != null
  //         ? ref.watch(markdownFileProvider(currentDownloadUrl!))
  //         : null;

  //     return Scaffold(
  //       backgroundColor: Colors.transparent,
  //       // appBar: AppBar(
  //       //   title: const Text('Notes Explorer'),
  //       //   backgroundColor: const Color(0xFF0F0F1E),
  //       //   elevation: 0,
  //       // ),
  //       drawer: !isWide
  //           ? Drawer(
  //               backgroundColor: const Color(0xCC0F0F1E),
  //               child: SafeArea(
  //                 child: Column(
  //                   children: [
  //                     const SizedBox(height: 20),
  //                     Text(
  //                       'Notes Folder',
  //                       style: Theme.of(context).textTheme.headlineSmall
  //                           ?.copyWith(
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                     ),
  //                     const SizedBox(height: 12),
  //                     Expanded(
  //                       child: notesTree.when(
  //                         data: (items) => NotesTreeView(
  //                           items: items,
  //                           selectedPath: selectedPath,
  //                           onFileTap: _openNote,
  //                         ),
  //                         loading: () =>
  //                             const Center(child: CircularProgressIndicator()),
  //                         error: (error, stack) => Center(
  //                           child: Text(
  //                             'Unable to load notes. Please try again.',
  //                             style: Theme.of(context).textTheme.bodyLarge
  //                                 ?.copyWith(color: Colors.white),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           : null,
  //       body: notesTree.when(
  //         data: (items) {
  //           if (selectedPath == null && currentDownloadUrl == null) {
  //             final firstFile = _findFirstFile(items);
  //             if (firstFile != null) {
  //               WidgetsBinding.instance.addPostFrameCallback((_) {
  //                 setState(() {
  //                   currentDownloadUrl = firstFile.downloadUrl;
  //                   currentTitle = firstFile.name.replaceAll('.md', '');
  //                 });
  //                 ref.read(selectedNotePathProvider.notifier).state =
  //                     firstFile.downloadUrl;
  //               });
  //             }
  //           }

  //           return Row(
  //             children: [
  //               if (isWide)
  //                 Container(
  //                   width: 320,
  //                   color: const Color(0xCC12122B),
  //                   child: SafeArea(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const SizedBox(height: 24),
  //                         Padding(
  //                           padding: const EdgeInsets.symmetric(horizontal: 20),
  //                           child: Text(
  //                             'Notes Explorer',
  //                             style: Theme.of(context).textTheme.headlineSmall
  //                                 ?.copyWith(
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Padding(
  //                           padding: const EdgeInsets.symmetric(horizontal: 20),
  //                           child: Text(
  //                             'Browse your Notes folder structure and open markdown files.',
  //                             style: Theme.of(context).textTheme.bodyMedium
  //                                 ?.copyWith(color: Colors.white70),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 16),
  //                         Expanded(
  //                           child: NotesTreeView(
  //                             items: items,
  //                             selectedPath: selectedPath,
  //                             onFileTap: _openNote,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               Expanded(
  //                 child: Container(
  //                   color: const Color(0xC90F0F1E),
  //                   child: currentDownloadUrl != null && fileContent != null
  //                       ? NoteViewer(
  //                           title: currentTitle ?? 'Note',
  //                           content: fileContent,
  //                         )
  //                       : Center(
  //                           child: Text(
  //                             'Select a note from the sidebar to view its content.',
  //                             style: Theme.of(context).textTheme.bodyLarge
  //                                 ?.copyWith(color: Colors.white70),
  //                           ),
  //                         ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //         loading: () => const Center(child: CircularProgressIndicator()),
  //         error: (error, stack) => Center(
  //           child: Text(
  //             'Unable to load notes. Please try again.',
  //             style: Theme.of(
  //               context,
  //             ).textTheme.bodyLarge?.copyWith(color: Colors.white),
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   GitHubContent? _findFirstFile(List<GitHubContent> items) {
  //     for (final item in items) {
  //       if (item.isFile && item.downloadUrl != null) {
  //         return item;
  //       }
  //       if (item.isDirectory) {
  //         final found = _findFirstFile(item.children);
  //         if (found != null) {
  //           return found;
  //         }
  //       }
  //     }
  //     return null;
  //   }

  //   void _openNote(String downloadUrl, String title) {
  //     setState(() {
  //       currentDownloadUrl = downloadUrl;
  //       currentTitle = title;
  //     });
  //     ref.read(selectedNotePathProvider.notifier).state = downloadUrl;
  //   }
  // }
}
