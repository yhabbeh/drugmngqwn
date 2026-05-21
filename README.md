# Home Pharmacy Management & Medication Reminders

A comprehensive Android application for managing home pharmacy inventory and medication reminders, built with **Clean Architecture** and **BLoC/Cubit** state management. This is an **Offline-First** application.

## 🏗️ Project Structure (Clean Architecture)

```
lib/
├── core/                           # Core utilities shared across layers
│   ├── constants/                  # App-wide constants
│   ├── error/                      # Error handling utilities
│   ├── failure/                    # Failure classes for functional error handling
│   ├── network/                    # Network-related utilities (for future API integration)
│   ├── services/                   # Core services
│   │   ├── notification/           # Notification service implementations
│   │   └── background/             # Background task handlers
│   ├── utils/                      # Helper functions and extensions
│   └── widgets/                    # Reusable UI components
│
├── domain/                         # Business Logic Layer (Pure Dart)
│   ├── entities/                   # Core business objects
│   │   ├── entity.dart             # Base entity class
│   │   ├── user/                   # User profile entities
│   │   ├── medication/             # Medication entities
│   │   ├── schedule/               # Schedule/dosing regimen entities
│   │   ├── dose_log/               # Dose tracking log entities
│   │   └── interaction/            # Drug interaction entities
│   ├── repositories/               # Repository interfaces (contracts)
│   │   ├── scanner_repository.dart     # Scanner operations contract
│   │   └── schedule_repository.dart    # Schedule & dose log operations contract
│   ├── usecases/                   # Business use cases (not yet implemented)
│   └── validators/                 # Domain validators
│
├── data/                           # Data Layer
│   ├── datasources/                # Data sources
│   │   ├── local/                  # Local data sources (Isar/Sqflite)
│   │   └── remote/                 # Remote data sources (APIs - future)
│   ├── models/                     # Data models (DTOs)
│   │   ├── user/                   # User data models
│   │   ├── medication/             # Medication data models
│   │   ├── schedule/               # Schedule data models
│   │   ├── dose_log/               # Dose log data models
│   │   └── interaction/            # Drug interaction data models
│   ├── mappers/                    # Model ↔ Entity mappers
│   └── repositories/               # Repository implementations
│
└── presentation/                   # Presentation Layer (UI + State Management)
    ├── bloc/                       # Global BLoCs
    ├── cubit/                      # Global Cubits
    ├── screens/                    # App screens
    ├── widgets/                    # Reusable widgets
    ├── themes/                     # App theming
    ├── medication/                 # Medication feature module
    │   ├── bloc/                   # Medication BLoCs
    │   ├── cubit/                  # Medication Cubits
    │   ├── screens/                # Medication screens
    │   └── widgets/                # Medication widgets
    ├── user/                       # User management feature module
    ├── schedule/                   # Scheduling feature module
    ├── inventory/                  # Inventory management feature module
    ├── scanner/                    # Scanner feature module
    └── notification/               # Notification handling feature module
```

## 📦 Key Dependencies (pubspec.yaml)

### State Management & Architecture
- `flutter_bloc` ^8.1.3 - BLoC/Cubit state management
- `bloc` ^8.1.2 - BLoC library
- `equatable` ^2.0.5 - Value equality for entities
- `get_it` ^7.6.4 - Dependency injection
- `injectable` ^2.3.2 - Code generation for DI
- `dartz` ^0.10.1 - Functional programming (Either type)

### Database (Offline-First)
- `isar` ^3.1.0+1 - Fast NoSQL database (recommended)
- `isar_flutter_libs` ^3.1.0+1 - Isar Flutter libraries
- `isar_generator` ^3.1.0+1 - Code generation for Isar

### Scanning & OCR
- `mobile_scanner` ^3.5.5 - Barcode/QR code scanning
- `google_mlkit_text_recognition` ^0.11.0 - OCR for blister packs
- `google_mlkit_commons` ^0.6.1 - ML Kit common utilities

### Notifications & Background Services
- `awesome_notifications` ^0.9.3+1 - Full-screen notifications with actions
- `flutter_local_notifications` ^16.3.2 - Local notifications
- `workmanager` ^0.5.2 - Background task execution
- `android_alarm_manager_plus` ^3.0.4 - Alarm manager for critical doses

### Utilities
- `intl` ^0.18.1 - Internationalization and date formatting
- `timezone` ^0.9.2 - Timezone handling
- `logger` ^2.0.2+1 - Logging
- `permission_handler` ^11.1.0 - Runtime permissions
- `shared_preferences` ^2.2.2 - Local storage for settings

### Future: Drug Interactions
- `http` ^1.1.2 - HTTP client for API calls
- `dio` ^5.4.0 - Advanced HTTP client

## 🎯 Core Features Implemented

### 1. Smart Scanner Module
- **Barcode Scanner**: Fetch medication data via free/open APIs
- **OCR Fallback**: Extract medication names and expiry dates from blister packs using Google ML Kit
- Repository pattern ready for multiple data sources

### 2. Inventory Management
- Track medication quantities and expiration dates
- Proactive alerts: low stock warnings, near-expiry alerts
- Automatic stock deduction on confirmed dose intake

### 3. Multi-Profile Support
- Multiple user profiles (family members)
- Individual schedules and dose logs per user
- Age verification for adult medications

### 4. Flexible Scheduling
- **Chronic Medications**: Continuous dosing with refill alerts
- **Course Medications**: Fixed start/end dates (e.g., antibiotics)
- **PRN Medications**: As-needed dosing
- Customizable frequency and timing

### 5. Actionable Notifications
- Standard push notifications or Full-Screen Alarm Intents
- Action buttons: "Take" / "Skip"
- Inventory deducted ONLY on explicit confirmation
- Ignored notifications automatically marked as "Missed"

### 6. Drug Interaction Framework
- Repository pattern designed for future interaction checking
- Active ingredient tracking for cross-medication analysis
- Severity levels: Minor, Moderate, Severe, Contraindicated

## 🔑 Domain Entities

### UserEntity
- Profile management for family members
- Date of birth, avatar, active status

### MedicationEntity
- Complete medication details (name, brand, generic, manufacturer)
- Barcode, batch number, active ingredients
- Quantity tracking, expiry dates
- Storage instructions, dosage form, strength

### ScheduleEntity
- Links medication to user with dosing regimen
- Supports chronic, course, and PRN medications
- Multiple daily dose times
- Day-of-week scheduling
- Critical dose flag for full-screen alarms

### DoseLogEntity
- Tracks each scheduled dose event
- Status: pending, taken, skipped, missed, partial
- Action source: notification, manual, automatic
- Inventory deduction tracking
- Adherence statistics support

### DrugInteractionEntity
- Interaction between two medications/ingredients
- Severity classification
- Clinical effects and management recommendations

## 📝 Repository Interfaces

### ScannerRepository
```dart
- scanBarcode(String barcode) → ScanResult
- performOCR(String imagePath) → OcrScanResult
- searchMedicationByName(String query) → List<ScanResult>
- fetchMedicationFromApi(String barcode) → ScanResult
- isValidBarcode(String barcode) → bool
```

### ScheduleRepository
```dart
// Schedule Operations
- createSchedule(ScheduleEntity) → ScheduleEntity
- updateSchedule(ScheduleEntity) → ScheduleEntity
- deleteSchedule(String id) → bool
- getSchedules({filter}) → List<ScheduleEntity>
- getActiveSchedulesForUser(String userId) → List<ScheduleEntity>
- pauseSchedule/resumeSchedule/completeSchedule()

// Dose Log Operations
- logDoseTaken() → DoseLogEntity (deducts inventory)
- logDoseSkipped() → DoseLogEntity (no inventory change)
- markDoseAsMissed() → DoseLogEntity (no inventory change)
- getDoseLogsForUser() → List<DoseLogEntity>
- getAdherenceStats() → Map<String, dynamic>
- generateUpcomingDoseLogs() → int (background service)
- autoMarkMissedDoses() → int (background service)
```

## 🚀 Getting Started

1. **Clone the repository**
2. **Install dependencies**: `flutter pub get`
3. **Run build runner**: `flutter pub run build_runner build --delete-conflicting-outputs`
4. **Configure platform-specific settings** (AndroidManifest.xml, Info.plist)
5. **Run the app**: `flutter run`

## 📱 Platform Support

- **Android**: Full support (notifications, alarms, background services)
- **iOS**: Partial support (limited background execution)

## 🏛️ Architecture Principles

1. **Dependency Rule**: Dependencies point inward (Data → Domain, Presentation → Domain)
2. **Single Responsibility**: Each class has one reason to change
3. **Separation of Concerns**: Clear boundaries between layers
4. **Testability**: Domain layer is pure Dart, easily testable
5. **Functional Error Handling**: Using `Either<Failure, Success>` pattern

## 🔮 Future Enhancements

- Cloud sync for multi-device support
- AI-powered medication recognition from images
- Integration with pharmacy databases for real-time drug interactions
- Telemedicine consultation booking
- Medication adherence reports for healthcare providers

---

**Built with ❤️ using Flutter and Clean Architecture**
