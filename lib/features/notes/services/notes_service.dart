import 'package:dio/dio.dart';
import 'package:flutter_starter_template/features/notes/models/github_content_model.dart';

class NotesService {
  static const _baseUrl = 'https://api.github.com';
  static const _owner = 'Priyansh-Shakya';
  static const _repo = 'TokenX';
  final Dio _dio;

  NotesService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: _baseUrl));

  Future<List<GitHubContent>> fetchNotesTree() async {
    return _fetchDirectory('Notes');
  }

  Future<List<GitHubContent>> _fetchDirectory(String path) async {
    final url = '/repos/$_owner/$_repo/contents/${Uri.encodeComponent(path)}';
    final response = await _dio.get(url);
    final data = response.data as List<dynamic>;

    final items = <GitHubContent>[];
    for (final raw in data) {
      final item = GitHubContent.fromJson(raw as Map<String, dynamic>);
      if (item.isDirectory) {
        final children = await _fetchDirectory(item.path);
        items.add(item.copyWith(children: children));
      } else {
        items.add(item);
      }
    }

    items.sort((a, b) {
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return items;
  }

  Future<String> fetchNoteContent(String downloadUrl) async {
    final response = await _dio.get<String>(downloadUrl);
    return response.data ?? '';
  }
}
