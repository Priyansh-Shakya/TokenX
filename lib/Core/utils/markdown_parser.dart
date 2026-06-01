import 'package:yaml/yaml.dart';

class MarkdownWithFrontmatter {
  final Map<String, dynamic> metadata;
  final String content;

  MarkdownWithFrontmatter({required this.metadata, required this.content});
}

class MarkdownParser {
  /// Parse markdown file with YAML frontmatter
  /// Format:
  /// ---
  /// title: Example Title
  /// author: Name
  /// date: 2025-01-01
  /// tags: [tag1, tag2]
  /// ---
  /// # Content here
  static MarkdownWithFrontmatter parse(String fileContent) {
    final lines = fileContent.split('\n');

    if (lines.isEmpty || lines[0] != '---') {
      // No frontmatter, return entire content
      return MarkdownWithFrontmatter(
        metadata: {},
        content: _normalizeHtml(fileContent),
      );
    }

    // Find closing ---
    int closingIndex = -1;
    for (int i = 1; i < lines.length; i++) {
      if (lines[i] == '---') {
        closingIndex = i;
        break;
      }
    }

    if (closingIndex == -1) {
      // Malformed frontmatter, return entire sanitized content
      return MarkdownWithFrontmatter(
        metadata: {},
        content: _normalizeHtml(fileContent),
      );
    }

    // Extract frontmatter and content
    final frontmatterText = lines.sublist(1, closingIndex).join('\n');
    final contentText = lines.sublist(closingIndex + 1).join('\n').trim();

    // Parse YAML
    Map<String, dynamic> metadata = {};
    try {
      final yamlMap = loadYaml(frontmatterText);
      if (yamlMap is YamlMap) {
        metadata = Map<String, dynamic>.from(yamlMap);
      }
    } catch (e) {
      // Failed to parse YAML, ignore
    }

    return MarkdownWithFrontmatter(
      metadata: metadata,
      content: _normalizeHtml(contentText),
    );
  }

  static String _normalizeHtml(String input) {
    var output = input;

    output = output.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n\n',
    );
    output = output.replaceAllMapped(
      RegExp(r'<a\s+href="([^"]+)"[^>]*>([\s\S]*?)</a>', caseSensitive: false),
      (match) => '[${match[2]}](${match[1]})',
    );
    output = output.replaceAllMapped(
      RegExp(r'<span[^>]*>([\s\S]*?)</span>', caseSensitive: false),
      (match) => match[1] ?? '',
    );
    output = output.replaceAll(RegExp(r'</div>', caseSensitive: false), '\n');
    output = output.replaceAll(
      RegExp(r'<div[^>]*>', caseSensitive: false),
      '\n',
    );
    output = output.replaceAll(
      RegExp(r'<!--[\s\S]*?-->', caseSensitive: false),
      '',
    );
    output = output.replaceAll(RegExp(r'<\/?[^>]+>', caseSensitive: false), '');
    return output.trim();
  }

  /// Extract specific metadata field
  static dynamic getMetadata(String fileContent, String key) {
    final parsed = parse(fileContent);
    return parsed.metadata[key];
  }

  /// Get all metadata fields as a pretty string
  static String metadataAsString(Map<String, dynamic> metadata) {
    final buffer = StringBuffer();
    metadata.forEach((key, value) {
      if (value is List) {
        buffer.writeln('$key: ${value.join(", ")}');
      } else {
        buffer.writeln('$key: $value');
      }
    });
    return buffer.toString();
  }
}
