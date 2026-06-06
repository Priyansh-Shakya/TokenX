import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokenx/features/notes/models/github_content_model.dart';

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
    // Use SharedPreferences to cache note contents.
    final prefs = await SharedPreferences.getInstance();
    final key = _cacheKeyFor(downloadUrl);

    // If cache exists, return it immediately and refresh in background.
    final cached = prefs.getString(key);
    if (cached != null && cached.isNotEmpty) {
      // Start background refresh but don't await it — consumers get cached immediately.
      _refreshAndCache(downloadUrl, key);
      return cached;
    }

    // No cache: fetch, store, and return.
    final response = await _dio.get<String>(downloadUrl);
    debugPrint('Fetched content from $downloadUrl');
    final data = response.data ?? '';
    try {
      await prefs.setString(key, data);
    } catch (_) {}
    return data;
  }

  String _cacheKeyFor(String downloadUrl) =>
      'note_cache:${Uri.encodeComponent(downloadUrl)}';

  void _refreshAndCache(String downloadUrl, String key) async {
    try {
      final response = await _dio.get<String>(downloadUrl);
      final fresh = response.data ?? '';
      final prefs = await SharedPreferences.getInstance();
      final previous = prefs.getString(key);
      if (fresh.isNotEmpty && fresh != previous) {
        await prefs.setString(key, fresh);
      }
    } catch (_) {
      // Ignore background refresh errors.
    }
  }
}
