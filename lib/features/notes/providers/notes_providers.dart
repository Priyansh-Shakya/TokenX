import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/features/notes/models/github_content_model.dart';
import 'package:flutter_starter_template/features/notes/services/notes_service.dart';
import 'package:flutter_starter_template/core/utils/markdown_parser.dart';

final notesServiceProvider = Provider<NotesService>((ref) {
  return NotesService();
});

final notesTreeProvider = FutureProvider<List<GitHubContent>>((ref) async {
  final service = ref.read(notesServiceProvider);
  return service.fetchNotesTree();
});

final selectedNotePathProvider = StateProvider<String?>((ref) => null);

final markdownFileProvider =
    FutureProvider.family<MarkdownWithFrontmatter, String>((
      ref,
      downloadUrl,
    ) async {
      final service = ref.read(notesServiceProvider);
      final fileText = await service.fetchNoteContent(downloadUrl);
      return MarkdownParser.parse(fileText);
    });

final selectedTabProvider = StateProvider<int>((ref) => 0);
