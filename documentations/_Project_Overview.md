# TokenX Developer Quick Reference

> Updated against actual codebase (June 2026)

---

# What is TokenX?

TokenX is a Flutter Web platform for:

* Showcasing AI/ML experiments
* Hosting educational notes/articles from GitHub markdown files
* Displaying developer profiles
* Serving as a public portfolio/knowledge hub

Current architecture is feature-based and designed for future GitHub/API integration.

---

# Project Flow

```text
main.dart
 └─ app/my_app.dart
     └─ core/app_starter.dart
         └─ features/shell/pages/main_shell.dart
```

Application starts here and loads the main navigation shell.

---

# Folder Structure

```text
lib/
├── app/
├── core/
├── features/
│
├── home/
├── experiments/
├── notes/
├── about/
└── shell/
```

---

# Core Layer

## app/

### my_app.dart

Main application configuration.

Handles:

* Material App setup
* Theme configuration
* Global settings

---

## core/app_starter.dart

Application bootstrap.

Used before entering UI shell.

---

## core/dio_client/

### dio_client_provider.dart

Shared Dio HTTP client.

Purpose:

* GitHub API requests
* Future backend requests
* Centralized networking

Edit here if:

* API base URL changes
* Headers/interceptors are added
* Authentication is introduced

---

## core/utils/

### markdown_parser.dart

Markdown utility.

Responsibilities:

* Parse markdown files
* Extract YAML frontmatter
* Separate metadata from content

Used by Notes feature.

---

# Feature: Home

Location:

```text
features/home/
```

Purpose:

Landing page and project presentation.

---

## pages/home_page.dart

Main homepage.

Contains:

* Hero section
* Branding
* Intro content
* Featured experiments
* CTA sections

Edit this file when:

* Updating homepage text
* Changing sections
* Modifying layout

---

## helper_widgets/icon_widgets.dart

Reusable icon/visual widgets.

Created to reduce HomePage size.

Use here for:

* Shared icons
* Animated visual elements
* Reusable homepage widgets

---

# Feature: Experiments

Location:

```text
features/experiments/
```

Purpose:

Display AI/ML experiments.

---

## models/experiment_model.dart

Experiment data model.

Contains fields like:

* title
* description
* author
* tags
* difficulty
* github link
* concepts
* dates

---

## data/sample_experiments.dart

MOST COMMONLY EDITED FILE.

Add new experiments here.

Typical workflow:

```text
Copy existing ExperimentModel
↓
Modify values
↓
Refresh app
```

---

## widgets/experiment_card.dart

Experiment card UI.

Handles:

* Card layout
* Gradients
* Difficulty badges
* Tags
* Hover effects
* Responsive behavior

Edit here when:

* Changing card appearance
* Adding card features
* Modifying tag colors

---

# Feature: Notes

Location:

```text
features/notes/
```

Purpose:

GitHub-powered knowledge base.

Current implementation already exists.

---

## models/github_content_model.dart

Represents GitHub API content.

Used when reading GitHub files/folders.

---

## models/note_model.dart

Represents parsed notes.

Stores:

* metadata
* content
* title
* tags
* dates

---

## services/notes_service.dart

Notes data layer.

Responsibilities:

* GitHub requests
* Loading markdown files
* Building note structures

Edit when:

* GitHub structure changes
* API logic changes

---

## providers/notes_providers.dart

Riverpod state management.

Connects:

```text
UI
 ↓
Provider
 ↓
Service
 ↓
GitHub
```

---

## widgets/notes_tree_view.dart

File/folder explorer.

Displays notes hierarchy.

---

## widgets/note_viewer.dart

Markdown renderer.

Responsible for displaying note content.

---

## pages/notes_page.dart

Main Notes page.

Combines:

* Tree view
* Note viewer
* Providers

---

# Feature: About

Location:

```text
features/about/
```

Purpose:

Developer/member profiles.

---

## dev_members.dart

Member registry.

Add new developers here.

If someone should appear in About section:

```text
Create page
↓
Register member
```

---

## pages/_generic_aboutme.dart

Reusable profile template.

All developer pages should use this.

Edit here for global About page styling.

---

## pages/priyansh_aboutme.dart

Priyansh profile content.

---

## pages/aryan_aboutme.dart

Aryan profile content.

---

# Feature: Shell

Location:

```text
features/shell/
```

Purpose:

Application navigation.

---

## pages/main_shell.dart

Most important navigation file.

Controls:

* Navigation
* Tabs
* Page switching
* Overall application structure

Think of it as:

```text
Home
Notes
About
```

controller.

Edit when:

* Adding pages
* Removing pages
* Changing navigation

---

# Adding New Experiment

Edit:

```text
features/experiments/data/sample_experiments.dart
```

Steps:

1. Copy existing ExperimentModel
2. Change values
3. Save
4. Reload app

No other files required.

---

# Adding New Note

Preferred workflow:

```text
Create markdown file
↓
Push to GitHub Notes repository
↓
TokenX loads it automatically
```

If loading logic changes:

```text
notes_service.dart
```

---

# Adding New Developer

Create:

```text
features/about/pages/new_person_aboutme.dart
```

Register inside:

```text
dev_members.dart
```

Done.

---

# Design System

## Main Colors

```text
Background      #0F0F1E
Primary         #667EEA
Secondary       #764BA2
Text            #FFFFFF
```

---

## Difficulty Colors

```text
Beginner      Green
Intermediate  Amber
Advanced      Red
```

---

## Responsive Breakpoints

```text
Mobile     < 600px
Tablet     600 - 1200px
Desktop    > 1200px
```

---

# Important Files Cheat Sheet

## Homepage

```text
features/home/pages/home_page.dart
```

---

## Navigation

```text
features/shell/pages/main_shell.dart
```

---

## Experiments Data

```text
features/experiments/data/sample_experiments.dart
```

---

## Experiment Card UI

```text
features/experiments/widgets/experiment_card.dart
```

---

## Notes Loading

```text
features/notes/services/notes_service.dart
```

---

## Notes Viewer

```text
features/notes/widgets/note_viewer.dart
```

---

## Developer Registry

```text
features/about/dev_members.dart
```

---

## Markdown Parsing

```text
core/utils/markdown_parser.dart
```

---

## Networking

```text
core/dio_client/dio_client_provider.dart
```

---

# Current Mental Model

```text
TokenX
│
├── Home
│   └── Landing page
│
├── Experiments
│   └── AI/ML project showcase
│
├── Notes
│   └── GitHub markdown knowledge base
│
├── About
│   └── Developer profiles
│
├── Shell
│   └── Navigation system
│
└── Core
    ├── Dio networking
    └── Markdown parsing
```

---

# Before Editing Anything

Ask:

```text
Am I changing:
- Data?
- UI?
- Navigation?
- Notes loading?
- Profile content?
```

Then jump directly to the corresponding feature folder.

This project follows a clean feature-based structure. Most future work should happen inside individual features rather than touching global files.
