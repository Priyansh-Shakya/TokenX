# TokenX - AI/ML Research & Experiments Platform

## Project Overview

TokenX is a Flutter Web application serving as a personal technical identity and public knowledge platform for AI/ML research, experiments, and learning documentation.

## Features Completed

### 1. **Stunning Landing Page**
- Dark, modern theme with gradient accents
- "TokenX" branding with "Solve with AI" tagline
- Animated hero section with smooth fade-in and scale effects
- Call-to-action buttons with gradient backgrounds
- Fully responsive design (mobile, tablet, desktop)

### 2. **Experiments Showcase**
- Beautiful experiment cards with:
  - Colorful gradient backgrounds based on experiment tags
  - Difficulty badges (Beginner, Intermediate, Advanced)
  - Concept listings
  - Publication dates
  - Multi-colored tag chips with gradient styling
  - "View Notebook" CTA buttons with hover animations
  - Glass-morphism effects with border accents

### 3. **Sample Experiments Data**
Three sample experiments included to demonstrate the platform:
- MNIST Digit Recognition (Beginner - Deep Learning)
- Transformer Architecture from Scratch (Advanced - NLP/LLM)
- RAG System Implementation (Intermediate - LLM/Vector DB)

### 4. **Animation & Interactions**
- Page load animations with staggered effects
- Smooth hover states on cards
- Button scale animations
- Shimmer effect on main title
- Gradient text effects

## Project Structure

```
lib/
├── main.dart                           # Entry point
├── app/
│   └── my_app.dart                    # App configuration with theme
├── Core/
│   └── app_starter.dart               # Bootstrap initialization
└── features/
    ├── home/
    │   └── pages/
    │       └── home_page.dart         # Landing page with hero & experiments section
    └── experiments/
        ├── models/
        │   └── experiment_model.dart  # ExperimentModel class with JSON support
        ├── data/
        │   └── sample_experiments.dart # Sample experiment data (easily editable)
        └── widgets/
            └── experiment_card.dart    # Reusable ExperimentCard widget
```

## Key Files for Future Modifications

### Adding More Experiments
Edit `lib/features/experiments/data/sample_experiments.dart`:
```dart
ExperimentModel(
  id: 'exp_004',
  title: 'Your Experiment Title',
  description: 'Description here',
  author: 'Your Name',
  tags: ['Tag1', 'Tag2'],
  difficulty: 'Intermediate',
  concepts: 'Concept1, Concept2',
  githubLink: 'https://github.com/...',
  notebookName: 'notebook.ipynb',
  createdAt: DateTime(2025, 11, 1),
)
```

### Customizing Card Styling
Edit gradients in `lib/features/experiments/widgets/experiment_card.dart`:
- `gradientMap`: Modify color schemes for different tags
- Box shadows, borders, and animations can be tuned

### Changing Theme Colors
Edit `lib/app/my_app.dart` theme configuration for dark mode colors

## Dependencies Added

- `flutter_animate: ^4.5.0` - Smooth animations
- `flutter_markdown: ^0.7.2` - Markdown rendering (for future notes)
- `markdown: ^7.2.2` - Markdown parsing
- `yaml: ^3.1.2` - YAML frontmatter parsing
- `url_launcher: ^6.2.6` - Open GitHub links
- `flutter_svg: ^2.0.10` - SVG support for logos
- `intl: ^0.19.0` - Date formatting

## Next Steps

### Phase 2: Notes/Articles Section
- Parse markdown files from Notes folder
- Extract YAML frontmatter for metadata
- Render with `flutter_markdown`
- Create list/grid view with filtering

### Phase 3: About Developer Section
- Use GitHub API to fetch content
- Display profile information
- Link to GitHub, LinkedIn, etc.

### Phase 4: Backend Integration
- Connect to FastAPI backend
- Fetch experiments dynamically from GitHub API
- Implement caching for performance

### Phase 5: Experiments with GitHub API
- Dynamic fetching from your AIML repository
- Parsing notebook metadata
- Auto-generating experiment cards

## Responsive Breakpoints

- **Mobile**: < 600px
- **Tablet**: 600px - 1200px  
- **Desktop**: > 1200px

All layouts adapt automatically based on screen size.

## Color Scheme

- **Background**: `#0F0F1E` (Deep dark blue)
- **Primary Gradient**: `#667EEA` to `#764BA2` (Purple)
- **Secondary Accents**: Various neon gradients for different tags
- **Text**: White with opacity variations

## Notes

- Uses Riverpod for state management (set up in starter template)
- Feature-based folder structure maintained
- Clean Architecture principles followed
- No hardcoded dimensions (fully responsive)
- Null-safe code throughout
