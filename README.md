# Flutter_Starter_Template

# Flutter Clean Starter Template

A reusable Flutter starter template built for fast project setup, clean architecture, scalability, and solo development productivity.

Packages Included:

- Riverpod
- Freezed
- Dio
- GoRouter
- JSON Serializable
- Build Runner
- flutter_launcher_icons

Boilerplate Code and Stcuture Includes:
- Feature based folder architecture
- Dio provider with interceptors
- flutter_launcher_icons pubspec.ymal code , initilized with default Flutter logo
- Bootstrap class which will handle app start logic, keeping main function clean
- .env file with befault variables present (env file will load at app start in bootstrap app_starter.dart file)

The goal is to avoid repeating setup work for every new Flutter project.



---

# Ideology

This template is intentionally kept lightweight.

Instead of hardcoding dependency versions inside `pubspec.yaml`, dependencies are installed using terminal scripts so that every new project fetches the latest compatible package versions automatically.

This keeps the template:
- future-proof
- easier to maintain
- less dependent on stale package versions

---

# Included Setup

## Architecture

Feature-first folder structure:

```text
lib/
  core/
  features/
  shared/
```

---

## State Management

- flutter_riverpod

Using:
- AsyncNotifier
- AsyncValue
- Provider-based architecture

Avoids unnecessary boilerplate state classes for simple CRUD apps.

---

## Networking

- dio

Prepared for:
- REST APIs
- interceptors
- token handling
- clean repository pattern

Backend-friendly for FastAPI integration.

---

## Model Generation

- freezed
- json_serializable
- build_runner

Used for:
- immutable DTOs
- JSON parsing
- copyWith
- equality
- cleaner models

Example:

```dart
@freezed
class NoteModel with _$NoteModel {
  const factory NoteModel({
    int? id,
    String? title,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json)
      => _$NoteModelFromJson(json);
}
```

---

## Routing

- go_router

Prepared for scalable navigation architecture.

---

## Environment Variables

- flutter_dotenv

Supports:
- API URLs
- environment configs
- secrets separation

---

# Dependency Installation

Dependencies are installed using terminal scripts instead of pre-written versions in `pubspec.yaml`.

Example script:

```bash
flutter pub add flutter_riverpod
flutter pub add dio
flutter pub add go_router
flutter pub add flutter_dotenv

flutter pub add freezed_annotation
flutter pub add json_annotation

flutter pub add --dev build_runner
flutter pub add --dev freezed
flutter pub add --dev json_serializable
flutter pub add --dev riverpod_generator
```

---

# Scripts

Recommended folder:

```text
scripts/
```

Example:

```text
scripts/setup_dependencies.sh
```

Run:

```bash
bash scripts/setup_dependencies.sh
```

---

# Bash Script Comments

Bash files support comments using:

```bash
# this is a comment
```

Example:

```bash
# Optional Firebase setup
# flutter pub add firebase_core
# flutter pub add firebase_auth
```

Useful for keeping optional package groups inside the same setup script.

---

# Recommended Workflow

## 1. Create New Project

Use GitHub Template Repository feature.

This creates:
- fresh git history
- independent repository
- clean project setup

---

## 2. Clone Project

```bash
git clone <repo-url>
```

---

## 3. Install Dependencies

```bash
bash scripts/setup_dependencies.sh
```

---

## 4. Run Code Generation

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

# Why This Template Exists

As a solo developer, repeatedly setting up:
- Riverpod
- Dio
- Freezed
- folder structures
- routing
- environment configs

for every Flutter project becomes repetitive and error-prone.

This template provides:
- consistency
- scalability
- faster startup
- cleaner architecture
- reduced boilerplate

while still keeping flexibility for future package updates.

---

# Long-Term Goal

Potential future starter variants:

- flutter_starter_crud
- flutter_starter_ecommerce
- flutter_starter_chat
- flutter_starter_admin

Built on the same architectural foundation.
