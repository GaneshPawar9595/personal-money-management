<<<<<<< HEAD
# personal-money-management
=======
# money_management

Overview
This Flutter project is architected using clean architecture principles and feature-based modularization to ensure scalability, maintainability, and testability.

## Project Structure

├── assets/                 # Static assets including localization files and animations
│   ├── lang/               # Localization JSON files for supported languages (e.g., en.json, hi.json)
│   ├── lottie/             # Animation assets (e.g., login_animation.json)
├── lib/                    # Main Dart source code
│   ├── config/             # App-wide configurations like localization and theming
│   │   ├── localization/   # Localization setup and classes
│   │   └── theme.dart      # App-wide theme definitions
│   ├── core/               # Core utilities, constants, and dependency injection setup
│   ├── features/           # Modular features with domain, data, and presentation layers
│   │   ├── auth/           # Authentication feature with clean separation of layers
│   │   │   ├── data/       # Data sources, repositories, and models
│   │   │   ├── domain/     # Entities, use cases, and repository contracts
│   │   │   ├── presentation/ # UI pages, widgets, providers
│   │   ├── dashboard/      # Dashboard feature organized similarly
│   ├── shared/             # Shared widgets, providers, and utilities reusable across features
│   ├── main.dart           # App entry point
│   └── router.dart         # Navigation routes setup

## Key Architectural Patterns

- **Clean Architecture:** Distinct domain, data, and presentation layers per feature.
- **Feature-First Organization:** Each feature encapsulates its logic and UI independently.
- **Dependency Injection:** Centralized injection managed under `core/di`.
- **State Management:** Scoped providers per feature and shared providers handle global state.
- **Localization:** JSON-based translations loaded via `config/localization`.
- **Theming:** Centralized theme management under `config/theme.dart`.

## Setup and Usage
**Install dependencies:**
flutter pub get

**Run the app:**
flutter run

**Localization files:** update JSON files under assets/lang/ for new languages or text changes.

**To add a new feature:**
Create a new folder under features/.
Follow the existing layer structure (data/, domain/, presentation/).