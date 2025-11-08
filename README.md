# Money Management App

A modern, modular **Flutter application** for managing your personal finances, built with clean architecture and feature-first organization.  
Supports multi-language localization, maintains clear separation of concerns, and can easily scale with new features.

---

## Features

- **Personal Finance Tracking:** Add, edit, and categorize your expenses.
- **Authentication:** Secure login and registration using best practices.
- **Dashboard:** Data visualization including category summaries and trends.
- **Feature-Based Architecture:** Each feature is self-contained, enabling fast development and easy maintenance.
- **State Management:** Uses Provider for scoped and shared state.
- **Localization:** Supports multiple languages (JSON-based, with ready-to-use English and Hindi files).
- **Theming:** Dynamic and consistent styling across the app.
- **Animations:** Enhanced user experience with Lottie assets.

---

## Project Structure

```text

assets/                                                            # All static assets used by the app
├── icons/                                                         # App icon assets (SVG, PNG, etc.)
├── images/                                                        # Image resources used in UI
├── lang/                                                          # Localization files for multi-language support
│   ├── en.json                                                    # English translations
│   └── hi.json                                                    # Hindi translations
└── lottie/                                                        # Lottie animation assets
    └── login_animation.json                                       # Example animation for login screen

lib/
├── config/                                                        # Global configuration files
│   ├── localization/
│   │   └── app_localizations.dart                                 # Localization setup and delegate
│   └── theme.dart                                                 # Global theme configuration (colors, fonts, etc.)

├── core/                                                          # Core app-level logic and utilities
│   ├── constants/
│   │   └── constants.dart                                         # App-wide constants (strings, keys, etc.)
│   ├── di/
│   │   └── injection.dart                                         # Dependency Injection setup (GetIt, etc.)
│   ├── presentation/
│   │   └── pages/
│   │       └── splash_screen.dart                                 # Splash screen UI
│   ├── theme/
│   │   └── app_theme.dart                                         # Theme data (light/dark modes)
│   └── utils/
│       ├── default_categories.dart                                # Default categories setup for first-time users
│       └── validation.dart                                        # Input validation utilities

├── features/                                                      # Feature-based folder structure
│
│   ├── auth/                                                      # Authentication feature
│   │   ├── data/                                                  # Data layer (API, Models, Repository implementation)
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart                    # Handles remote auth API calls
│   │   │   ├── models/
│   │   │   │   └── user_model.dart                                # Data model for user
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart                      # Implementation of auth repository
│   │   ├── domain/                                                # Business logic layer
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart                               # Entity representing user data
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart                           # Abstract auth repository interface
│   │   │   └── usecases/                                          # Auth-related use cases
│   │   │       ├── get_current_user_id.dart
│   │   │       ├── get_profile_usecase.dart
│   │   │       ├── sign_in_usecase.dart
│   │   │       ├── sign_out_usecase.dart
│   │   │       ├── sign_up_usecase.dart
│   │   │       ├── update_avatar_usecase.dart
│   │   │       └── update_profile_usecase.dart
│   │   └── presentation/
│   │       ├── pages/                                             # Authentication pages (responsive)
│   │       │   ├── signin/
│   │       │   │   ├── signin_page.dart
│   │       │   │   ├── signin_mobile.dart
│   │       │   │   ├── signin_tablet.dart
│   │       │   │   └── signin_desktop.dart
│   │       │   └── signup/
│   │       │       ├── signup_page.dart
│   │       │       ├── signup_mobile.dart
│   │       │       ├── signup_tablet.dart
│   │       │       └── signup_desktop.dart
│   │       ├── provider/
│   │       │   └── auth_provider.dart                             # State management for auth
│   │       └── widgets/                                           # Reusable widgets for auth screens
│
│   ├── category/                                                  # Category management feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── category_remote_datasource.dart
│   │   │   │   └── category_remote_datasource_impl.dart
│   │   │   ├── models/
│   │   │   │   └── category_model.dart
│   │   │   └── repositories/
│   │   │       └── category_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── category_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── category_repository.dart
│   │   │   └── usecases/
│   │   │       ├── add_category_usecase.dart
│   │   │       ├── add_default_categories.dart
│   │   │       ├── delete_category_usecase.dart
│   │   │       ├── get_categories_usecase.dart
│   │   │       └── update_category_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── category_page.dart
│   │       │   ├── category_mobile_page.dart
│   │       │   ├── category_tablet_page.dart
│   │       │   └── category_desktop_page.dart
│   │       ├── provider/
│   │       │   └── category_provider.dart
│   │       ├── utils/
│   │       │   └── category_utils.dart
│   │       └── widgets/
│   │           ├── category_dropdown.dart
│   │           ├── category_form.dart
│   │           ├── category_form_wrapper.dart
│   │           ├── category_list.dart
│   │           └── color_picker_field.dart
│
│   ├── dashboard/                                                 # Dashboard & analytics
│   │   ├── data/
│   │   │   ├── datasources/                                       # (Optional future)
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── category_summary_entity.dart
│   │   │   │   └── spending_trend_entity.dart
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │       ├── calculate_category_summary_usecase.dart
│   │   │       ├── calculate_spending_trends_usecase.dart
│   │   │       └── get_recent_transactions_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── dashboard_desktop.dart
│   │       │   ├── dashboard_mobile.dart
│   │       │   ├── dashboard_page.dart
│   │       │   └── desktop_home_screen.dart
│   │       ├── provider/
│   │       │   └── dashboard_provider.dart
│   │       ├── sections/
│   │       │   ├── recent_transactions/
│   │       │   │   ├── desktop_recent_transactions_section.dart
│   │       │   │   ├── desktop_transaction_item.dart
│   │       │   │   └── recent_transactions_section.dart
│   │       │   ├── spending_trends/
│   │       │   │   ├── desktop_spending_chart_section.dart
│   │       │   │   └── spending_trends_section.dart
│   │       │   ├── stats_cards/
│   │       │   │   └── desktop_stats_cards_section.dart
│   │       │   ├── top_bar/
│   │       │   │   ├── custom_sliver_appbar.dart
│   │       │   │   └── desktop_top_bar.dart
│   │       │   ├── top_merchants/
│   │       │   │   ├── desktop_top_merchants_section.dart
│   │       │   │   └── top_merchants_section.dart
│   │       │   ├── top_spend_category/
│   │       │   │   ├── desktop_category_breakdown_section.dart
│   │       │   │   └── top_spend_category_section.dart
│   │       └── widgets/
│   │           ├── desktop/
│   │           │   └── stats_cards/
│   │           │       └── desktop_stats_card.dart
│   │           ├── section_header.dart
│   │           ├── summary_cards.dart
│   │           └── time_range_selector.dart
│
│   ├── profile/                                                   # User profile management
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── profile_page.dart
│   │       │   ├── profile_mobile.dart
│   │       │   ├── profile_tablet.dart
│   │       │   └── profile_desktop.dart
│   │       ├── provider/
│   │       └── widgets/
│   │           ├── profile_field_tile.dart
│   │           ├── profile_header_card.dart
│   │           └── profile_section_card.dart
│
│   └── transaction/                                               # Transaction CRUD feature
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── transaction_remote_datasource.dart
│       │   │   └── transaction_remote_datasource_impl.dart
│       │   ├── models/
│       │   │   └── transaction_model.dart
│       │   └── repositories/
│       │       └── transaction_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── transaction_entity.dart
│       │   ├── repositories/
│       │   │   └── transaction_repository.dart
│       │   ├── usecases/
│       │   │   ├── add_transaction_usecase.dart
│       │   │   ├── delete_transaction_usecase.dart
│       │   │   ├── get_transaction_usecase.dart
│       │   │   └── update_transaction_usecase.dart
│       │   └── utils/
│       │       ├── get_today_amount_status_usecase.dart
│       │       └── transaction_filter.dart
│       └── presentation/
│           ├── pages/
│           │   ├── transaction_page.dart
│           │   ├── transaction_mobile_page.dart
│           │   ├── transaction_tablet_page.dart
│           │   └── transaction_desktop_page.dart
│           ├── provider/
│           │   └── transaction_provider.dart
│           ├── utils/
│           │   ├── delete_dialogs.dart
│           │   └── transaction_filter.dart
│           └── widgets/
│               ├── date_selector_widget.dart
│               ├── income_expense_switch.dart
│               ├── merchant_card.dart
│               ├── transaction_form.dart
│               ├── transaction_form_wrapper.dart
│               ├── transaction_list.dart
│               └── transaction_search_filter_bar.dart
│
├── shared/                                                        # Shared, reusable UI and logic
│   ├── provider/
│   │   ├── locale_provider.dart                                   # Language switching provider
│   │   └── theme_provider.dart                                    # Theme switching provider
│   └── widgets/
│       ├── custom_elevated_button.dart
│       ├── custom_input_field.dart
│       └── responsive_layout.dart                                 # Handles desktop/mobile/tablet layout
└── firebase_options.dart                                          # Firebase configuration (auto-generated)
└── main.dart                                                      # App entry point
└── router.dart                                                    # App route management
```
---

## Getting Started

1. **Install dependencies:**
    ```
    flutter pub get
    ```

2. **Run the app:**
    ```
    flutter run
    ```

3. **Localization:**
    - Translation files are under `assets/lang/` (add new languages/keys as needed).

4. **Add a new feature:**
    - Create a folder in `lib/features/`, following the domain/data/presentation structure.
    - Register new routes in `router.dart`.

---

## Directory Details

- **lib/config/**: Holds localization code and theming logic.
- **lib/core/**: For DI (dependency injection) and base utilities/constants.
- **lib/features/**: Every feature (auth, dashboard, transaction, category, etc.) has its own data, domain, and presentation layers.
- **lib/shared/**: Widgets and providers used app-wide.

---

## Contribution

Pull requests are welcome!  
Please keep changes modular and follow the code style and architectural patterns in place.

---

## License

MIT

---

## Credits

Built using [Flutter](https://flutter.dev/), [Provider](https://pub.dev/packages/provider), [flutter_iconpicker](https://pub.dev/packages/flutter_iconpicker), [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker), and other open-source packages.

---

## Tags

`flutter` `personal-finance` `clean-architecture` `provider` `localization` `modular` `dart` `money-management` `cross-platform` `open-source`

---
