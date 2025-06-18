# State Management Enhancement Plan for Hotel Mobile App

## Overview

This document outlines the steps needed to enhance state management in the Hotel Mobile App using Riverpod and freezed packages according to the project guidelines. The goal is to implement a clean architecture pattern with clear separation of concerns.

## Dependencies to Add

Update `pubspec.yaml` with the following dependencies:

```yaml
dependencies:
  # Existing dependencies...
  
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Dependency Injection
  get_it: ^7.6.7

dev_dependencies:
  # Existing dev dependencies...
  
  # Code Generation
  riverpod_generator: ^2.3.9
  custom_lint: ^0.5.11
  riverpod_lint: ^2.3.7
```

## Project Structure Changes

1. Create a dependency injection setup:
   - `lib/core/di/service_locator.dart` for GetIt configuration
   
2. Create base state classes:
   - `lib/core/state/ui_state.dart` for handling loading, success, and error states
   
3. Implement Riverpod providers:
   - `lib/core/providers/` directory to house all global providers
   - Move locale management from ChangeNotifier to Riverpod

4. Create controllers for each feature:
   - `lib/features/home/controller/home_controller.dart`
   - `lib/features/auth/controller/auth_controller.dart`
   - etc.

5. Create domain entities with freezed:
   - `lib/features/home/domain/entities/featured_hotel.dart`
   - etc.

## Implementation Steps

### 1. Set Up Dependency Injection

Use GetIt as a service locator to manage dependencies, following these patterns:
- Singleton for services and repositories
- Factory for use cases
- Lazy singleton for controllers

### 2. Create Base UI State

Implement a freezed-based UI state class that can handle:
- Initial state
- Loading state
- Success state with data
- Error state with message

### 3. Implement Feature Controllers

For each feature, create a controller that:
- Uses Riverpod for state management
- Follows the controller pattern for business logic
- Takes methods as input and updates the UI state
- Uses the repository pattern for data access

### 4. Update UI Components

Convert existing UI components to use Riverpod:
- Replace `StatefulWidget` with `ConsumerStatefulWidget`
- Replace `StatelessWidget` with `ConsumerWidget`
- Use `ref.watch()` to access state
- Use `ref.read().method()` to trigger actions

### 5. Model Domain Entities

Use freezed to create immutable domain entities that represent:
- Hotel data
- User data
- Booking data
- etc.

## Migration Strategy

1. Create parallel implementations first (e.g., `home_page_riverpod.dart` alongside `home_page.dart`)
2. Test each feature with the new implementation
3. Replace implementations one by one
4. Remove old state management code (BLoC/Cubit/Provider)

## Code Generation

After setting up all the files, run the following command to generate the necessary code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Benefits of Enhanced State Management

- More predictable state changes with immutable state
- Better separation of concerns with controllers
- Improved testability
- TypeSafe dependency injection
- Code generation reduces boilerplate
- Structured error handling with UI states

## Sample Pattern for a Feature

```
features/
  feature_name/
    controller/
      feature_controller.dart  # Riverpod controller
    domain/
      entities/                # Freezed models
      repositories/            # Repository interfaces
    data/
      repositories/            # Repository implementations
      datasources/             # Data sources (API, local)
    presentation/
      pages/                   # Screen widgets
      widgets/                 # UI components
```
