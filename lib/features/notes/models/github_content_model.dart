class GitHubContent {
  final String name;
  final String path;
  final String type;
  final String? downloadUrl;
  final List<GitHubContent> children;

  GitHubContent({
    required this.name,
    required this.path,
    required this.type,
    this.downloadUrl,
    this.children = const [],
  });

  bool get isDirectory => type == 'dir';
  bool get isFile => type == 'file';

  factory GitHubContent.fromJson(Map<String, dynamic> json) {
    return GitHubContent(
      name: json['name'] as String,
      path: json['path'] as String,
      type: json['type'] as String,
      downloadUrl: json['download_url'] as String?,
    );
  }

  GitHubContent copyWith({List<GitHubContent>? children}) {
    return GitHubContent(
      name: name,
      path: path,
      type: type,
      downloadUrl: downloadUrl,
      children: children ?? this.children,
    );
  }
}
