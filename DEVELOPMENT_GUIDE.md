# TokenX - Development Guide

## Quick Start

### Running the App
```bash
cd e:\priyansh\Code\Websites\TokenX
flutter pub get
flutter run -d chrome  # For web development
```

## Adding More Experiments

### Step 1: Edit `sample_experiments.dart`
Location: `lib/features/experiments/data/sample_experiments.dart`

```dart
ExperimentModel(
  id: 'exp_004',  // Unique identifier
  title: 'Your Experiment Title',
  description: 'Comprehensive description of what this experiment does...',
  author: 'Priyansh Shakya',
  tags: ['Tag1', 'Tag2', 'Tag3'],  // These determine the gradient color
  difficulty: 'Intermediate',  // 'Beginner', 'Intermediate', or 'Advanced'
  concepts: 'Concept1, Concept2, Concept3',  // Comma-separated concepts
  githubLink: 'https://github.com/Priyansh-Shakya/AIML-experiments-learning/blob/main/path/to/notebook.ipynb',
  notebookName: 'notebook_name.ipynb',
  createdAt: DateTime(2025, 11, 15),  // Month, Day, Year
)
```

### Available Tags & Their Colors
- `Deep Learning` - Purple gradient (667EEA to 764BA2)
- `NLP` - Pink-Red gradient (F093FB to F5576C)
- `LLM` - Cyan gradient (4FACFE to 00F2FE)
- `CNN` - Orange-Yellow gradient (FA709A to FECE34)
- `Classification` - Teal-Purple gradient (30CFD0 to 330867)
- `Transformers` - Blue-Cyan gradient (1FA2FF to 12D8FA)
- `Vector DB` - Mint-Pink gradient (A8EDEA to FED6E3)
- `RAG` - Orange-Red gradient (FF9A56 to FF6A88)

**Any tag not in this list defaults to purple gradient**. To add more colors, edit the `gradientMap` in `experiment_card.dart`.

## Adding Notes/Articles Section (Phase 2)

### Markdown with Frontmatter Format

Create markdown files in `Notes/` folder with this format:

```markdown
---
title: Understanding Transformers
author: Priyansh Shakya
date: 2025-01-15
updated: 2025-01-20
category: AI/ML
tags: [Transformers, NLP, Deep Learning]
description: A comprehensive guide to transformer architecture
---

# Understanding Transformers

Your markdown content here with **bold**, *italic*, etc.

## Subsection
More content...
```

### Parser Utility
The `MarkdownParser` class in `lib/core/utils/markdown_parser.dart` automatically handles:
- Extracting YAML frontmatter
- Parsing metadata
- Separating content from metadata

Usage:
```dart
import 'package:flutter_starter_template/core/utils/markdown_parser.dart';

final parsed = MarkdownParser.parse(markdownContent);
print(parsed.metadata['title']);
print(parsed.content);
```

## Notes Data Model

Location: `lib/features/notes/models/note_model.dart`

Create NoteModel instances:
```dart
NoteModel.fromMarkdown(
  id: 'note_001',
  content: markdownContent,
  metadata: {
    'title': 'My Note',
    'author': 'Priyansh',
    'date': '2025-01-15',
    'tags': ['AI', 'ML'],
    'category': 'AI/ML',
  },
)
```

## Project Structure for Future Growth

```
Notes/
├── about_me.md                 # Your bio/portfolio info
├── experiments_data.md         # Experiment metadata
├── AI_ML/
│   ├── transformers.md
│   ├── rag_systems.md
│   └── fine_tuning.md
├── Flutter/
│   ├── state_management.md
│   └── web_responsive_design.md
└── Research/
    ├── papers_simplified.md
    └── ideas.md
```

## Theme Customization

### Dark Mode Colors
Edit `lib/app/my_app.dart`:
```dart
theme: ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0F0F1E),  // Change this
  // Add more theme properties as needed
)
```

### Hero Section Colors
Edit `lib/features/home/pages/home_page.dart`:
```dart
colors: [
  const Color(0xFF667EEA).withOpacity(0.1),  // Primary color
  const Color(0xFF764BA2).withOpacity(0.05),  // Secondary color
]
```

## Adding New Features

### Feature-Based Folder Structure
For each new feature:
1. Create folder under `lib/features/feature_name/`
2. Add subdirectories:
   - `models/` - Data models
   - `widgets/` - Reusable UI components
   - `pages/` - Full page widgets
   - `providers/` - Riverpod state management (optional)
   - `data/` - Local data or repository layer

### Example: Notes Feature
```
features/notes/
├── models/
│   └── note_model.dart
├── widgets/
│   ├── note_card.dart
│   └── markdown_viewer.dart
├── pages/
│   ├── notes_list_page.dart
│   └── note_detail_page.dart
└── providers/
    └── notes_provider.dart
```

## State Management (Riverpod)

Already set up in the starter template. Example provider:

```dart
final experimentsProvider = FutureProvider<List<ExperimentModel>>((ref) async {
  // Fetch from GitHub API
  return fetchExperimentsFromGitHub();
});
```

## Responsive Design Principles

All UI components should adapt to screen sizes:

```dart
final isMobile = MediaQuery.sizeOf(context).width < 600;
final isTablet = MediaQuery.sizeOf(context).width < 1200;

if (isMobile) {
  // Mobile layout
} else if (isTablet) {
  // Tablet layout
} else {
  // Desktop layout
}
```

## Animation Library

Using `flutter_animate` package. Common patterns:

```dart
widget
  .animate()
  .fadeIn(duration: 800.ms)
  .slideX(begin: -0.3, end: 0, duration: 800.ms)
```

## Deploying to Web

### Build for Production
```bash
flutter build web --release
```

### Host on Cloudflare Pages (Recommended)
1. Push code to GitHub
2. Connect repo to Cloudflare Pages
3. Build command: `flutter build web --release`
4. Publish directory: `build/web`

### Host on Firebase
```bash
npm install -g firebase-tools
firebase login
firebase init hosting
flutter build web --release
firebase deploy
```

## Future API Integration

When ready to connect to FastAPI backend:

```dart
import 'package:dio/dio.dart';

final dio = Dio();
final response = await dio.get('http://your-backend/api/experiments');
```

All API calls should be wrapped in Riverpod providers for reactive state management.

## Performance Tips

1. **Images**: Use WebP format, compress to < 50KB
2. **Animations**: Keep frame count reasonable (limit to essential animations)
3. **Loading**: Implement skeleton loaders for async content
4. **Caching**: Use Riverpod's caching for expensive computations
5. **Lazy Loading**: Load content as user scrolls

## Helpful Resources

- [Flutter Web Documentation](https://flutter.dev/web)
- [Riverpod Documentation](https://riverpod.dev)
- [Flutter Animate Package](https://pub.dev/packages/flutter_animate)
- [Material Design 3](https://m3.material.io/)

## Common Issues & Solutions

### Issue: "Unused import" warnings
**Solution**: Remove unused imports or use them (e.g., if not using `flutter_animate`, remove the import)

### Issue: Responsive layout looks wrong on tablet
**Solution**: Add specific breakpoint handling for 600px < width < 1200px range

### Issue: Animations feel sluggish
**Solution**: Reduce duration values, lower animation complexity, or use `shouldRasterize: true` on complex widgets (use sparingly)

## Next Steps

1. **Short-term**: Add Notes rendering page with markdown support
2. **Medium-term**: Create About/Developer section
3. **Medium-term**: Integrate GitHub API for dynamic experiment fetching
4. **Long-term**: Connect to FastAPI backend
5. **Long-term**: Add authentication, user profiles, bookmarks

---

**Happy coding! The architecture is ready for growth.** 🚀
