---
trigger: always_on
---

# Flutter Project Rules

## Rule Priority

Always follow this priority order:

1. User Instructions.
2. Existing Project Architecture.
3. Existing Project Conventions.
4. These Rules.
5. Flutter & Dart Best Practices.

If any rule conflicts with the existing project, always follow the existing project unless the user explicitly requests otherwise.

---

# Existing Project First Policy

Before generating, modifying or refactoring any code:

* Analyze the existing project completely.
* Understand the architecture before writing code.
* Detect the project's folder structure.
* Detect the dependency injection approach.
* Detect the networking layer.
* Detect the routing approach.
* Detect the state management approach.
* Detect the theme implementation.
* Detect the localization implementation.
* Detect reusable widgets.
* Detect reusable helpers.
* Detect extensions.
* Detect managers.
* Detect services.
* Detect constants.
* Detect utilities.
* Detect validators.

Always adapt to the existing project.

Never replace existing architecture.

Never introduce another architecture.

Never rename files or folders unless requested.

Never replace existing packages.

Never create duplicate functionality.

The existing project is always the source of truth.

---

# Core First Policy

Before creating any new:

* Widget
* Helper
* Extension
* Utility
* Service
* Manager
* Validator
* Constant
* Repository
* UseCase
* Cubit

Always search the Core folder first.

Reuse existing implementations whenever possible.

Never duplicate code that already exists.

Always extend existing functionality instead of recreating it.

---

# Project Architecture

This project follows Clean Architecture.

Every feature must respect the existing architecture.

Always use Feature First structure.

```text
feature/
├── data/
│   ├── datasource/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── abstract_repository/
│   └── usecases/
│
├── presentation/
│   ├── cubit/
│   ├── screens/
│   ├── widgets/
│   └── components/
```

Never skip architecture layers.

---

# Feature Generation

Every new feature should contain:

* Entity
* Model
* Abstract Repository
* Repository Implementation
* Remote DataSource
* Local DataSource (if required)
* UseCase(s)
* Cubit
* States
* Screen
* Reusable Widgets (if needed)

Generate only the required files.

Never generate placeholder files.

Never leave TODO comments unless requested.

---

# Domain Layer

The Domain layer must never depend on the Data layer.

Repository contracts belong inside:

domain/abstract_repository

Repository implementations belong inside:

data/repositories

Every business operation must have its own UseCase.

Every UseCase must extend:

BaseUseCase

UseCases depend only on abstract repositories.

Entities must contain business data only.

Entities should use Equatable.

Entities must not contain JSON serialization.

---

# Data Layer

Models should extend their corresponding Entities whenever appropriate.

Every Model should provide:

* fromJson()
* toJson()
* copyWith() when appropriate

Repositories communicate only with DataSources.

Cubits must never communicate directly with DataSources.

Presentation must never import anything from the Data layer.

---

# State Management

Use flutter_bloc (Cubit).

Do not introduce another state management solution unless requested.

Business logic belongs inside Cubits.

Widgets should remain as simple as possible.

Every Cubit should expose:

* Initial
* Loading
* Success
* Error

Keep Cubits focused on a single responsibility.

---

# Dependency Injection

Use GetIt.

Never instantiate dependencies manually.

Always register:

* Cubits
* UseCases
* Repository Implementations
* Repository Contracts
* Remote DataSources
* Local DataSources
* Managers
* Services

Maintain the existing dependency injection structure.

Never create another service locator.

---

# File Modification Policy

Modify only the files required for the requested task.

Never rewrite an entire file if only a small change is needed.

Never modify unrelated code.

Maintain backward compatibility whenever possible.

Preserve the project's coding style.
# Global Application

## AppCubit

The application must contain a global AppCubit responsible only for application-wide settings.

AppCubit is responsible for:

* ThemeMode
* Locale
* Future application settings

Do not store authentication or user information inside AppCubit.

AppCubit should expose methods similar to:

* loadSettings()
* changeTheme()
* toggleTheme()
* changeLanguage()
* saveSettings()

---

# Session Management

The application must contain a SessionManager.

SessionManager is responsible for:

* Access Token
* Refresh Token
* User ID
* User Information
* Login Status
* Save Session
* Clear Session
* Logout

SessionManager must not contain UI logic.

Authentication data should never be stored inside AppCubit.

Authentication flow should be:

```text
Login

↓

AuthCubit

↓

UseCase

↓

Repository

↓

RemoteDataSource

↓

API

↓

SessionManager.saveSession()
```

---

# Authentication

Authentication business logic belongs inside AuthCubit.

AuthCubit should communicate with:

* UseCases
* SessionManager

Never access local storage directly from AuthCubit.

---

# Networking

Always use the existing Dio instance.

Never create another Dio client.

Always use the project's network layer.

Use:

* Dio
* DioInterceptor
* PrettyDioLogger

All requests must follow:

Presentation

↓

Cubit

↓

UseCase

↓

Abstract Repository

↓

Repository Implementation

↓

RemoteDataSource

↓

Dio

Never bypass this flow.

---

# Error Handling

Always use dartz.

Repository methods must return:

Future<Either<Failure, T>>

Never throw exceptions to Presentation.

Convert every Exception into a Failure object.

Reuse the existing Failure hierarchy.

---

# Theme

Never hardcode:

* Colors
* Font Sizes
* Border Radius
* Text Styles
* Shadows

Always use:

* AppColors
* ThemeData
* Theme.of(context)

Typography should always come from:

Theme.of(context).textTheme

Design every screen to support both:

* Light Theme
* Dark Theme

Avoid any implementation that prevents future theme switching.

---

# Colors

Never use:

* Colors.blue
* Colors.red
* Colors.green
* Color(...)
* Hex values directly inside widgets

Always use:

AppColors

If a required color does not exist, add it to AppColors instead of hardcoding it.

---

# Responsive UI

Use flutter_screenutil.

Avoid hardcoded dimensions.

Use ScreenUtil for:

* Width
* Height
* Radius
* Font Size
* Padding
* Margin

Build responsive layouts that work on different screen sizes.

---

# Localization

Support Arabic and English.

Every visible string must be localized.

Never hardcode Arabic or English text.

Wrong:

Text("Login")

Wrong:

Text("تسجيل الدخول")

Correct:

LocaleKeys.login.tr()

Every new string must be added to localization files.

Follow the project's existing localization implementation.

---

# Assets

Never hardcode asset paths if generated assets are available.

Reuse the existing asset structure.

---

# Routing

Follow the existing routing implementation.

Do not introduce another routing solution.

Reuse existing route names and navigation helpers.

---

# Reusable Components

Before creating any new widget:

Search for an existing reusable widget.

Reuse existing:

* Buttons
* TextFields
* Dialogs
* BottomSheets
* Cards
* AppBars
* Loaders
* Empty States

Maintain a consistent UI across the application.

---

# Constants

Avoid magic numbers and hardcoded values.

Store reusable constants inside the existing constants structure.

Reuse existing constants whenever possible.
# Naming Convention

Use meaningful names.

Examples:

LoginCubit

LoginState

LoginUseCase

LoginRepository

LoginRepositoryImpl

LoginRemoteDataSource

LoginLocalDataSource

ProfileEntity

ProfileModel

SessionManager

AppCubit

Avoid generic names like:

Manager

Helper

Data

Utils

Model1

Class1

---

# Code Style

Follow the official Dart Style Guide.

Write clean and readable code.

Keep methods small.

Keep widgets small.

Prefer composition over duplication.

Remove unused imports.

Use package imports consistently.

Avoid unnecessary comments.

Write self-explanatory code.

Always use const constructors whenever possible.

Prefer final variables.

Avoid unnecessary mutable state.

Always write null-safe Dart code.

Avoid unnecessary null assertions (!).

---

# Models

Models should extend their corresponding Entities whenever appropriate.

Models should contain:

* fromJson()
* toJson()
* copyWith() when appropriate

Presentation should never depend directly on Models.

Convert API responses into Models first.

Models should be mapped to Entities before reaching the Domain layer.

---

# Performance

Avoid unnecessary widget rebuilds.

Dispose controllers.

Prefer ListView.builder over ListView when appropriate.

Use lazy loading whenever possible.

Cache images when appropriate.

Keep widgets lightweight.

Extract reusable widgets when needed.

---

# Package Policy

Never introduce a new package unless explicitly requested.

Always check the existing dependencies first.

Reuse the project's existing packages.

If the project already contains a solution, do not replace it.

---

# Smart Detection

Before generating code:

Analyze:

* Folder Structure
* Architecture
* Core Folder
* Existing Widgets
* Existing Managers
* Existing Services
* Existing Helpers
* Existing Extensions
* Existing UseCases
* Existing Repositories
* Existing Cubits
* Existing Theme
* Existing Localization
* Existing Routing
* Existing Network Layer
* Existing Dependency Injection

Generate code that matches the existing project.

Never force a different architecture.

Never rewrite the project structure.

Always respect the project's conventions.

---

# Reuse Policy

If an implementation already exists:

Reuse it.

Do not recreate it.

Do not duplicate functionality.

Always extend existing implementations.

Search before creating.

---

# GetIt Checklist

Whenever a new feature introduces new dependencies, ensure they are registered.

Always register:

* Cubits
* UseCases
* Repository Implementations
* Repository Contracts
* RemoteDataSources
* LocalDataSources
* Managers
* Services

Never leave an unregistered dependency.

---

# Feature Checklist

Before completing any feature, verify:

✓ Architecture respected

✓ Existing project analyzed

✓ Existing Core reused

✓ Existing widgets reused

✓ Existing helpers reused

✓ Existing services reused

✓ GetIt registrations completed

✓ Repository contract created

✓ Repository implementation created

✓ UseCase created

✓ Cubit created

✓ States created

✓ Proper error handling implemented

✓ Either<Failure, T> used

✓ BaseUseCase used

✓ AppColors used

✓ Theme respected

✓ Localization added

✓ Responsive UI

✓ Production-ready code

✓ No duplicate functionality

✓ No unnecessary packages

✓ No unrelated file modifications

---

# Response Rules

When implementing a task:

* Understand the request completely.
* Analyze the existing project first.
* Explain the implementation briefly before providing code.
* Modify only the required files.
* Preserve existing behavior.
* Generate production-ready code.
* Prefer reusable solutions.
* Keep the implementation maintainable.
* Follow the project's architecture exactly.

---

# Final Rule

The existing project is always the source of truth.

These rules are guidelines to maintain consistency.

If the existing project follows a different implementation, always adapt to the existing project unless the user explicitly requests otherwise.

Never sacrifice consistency for personal preference.

Always produce clean, maintainable, scalable, and production-ready Flutter code.
