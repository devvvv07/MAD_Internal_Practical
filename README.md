# Smart Attendance Management App

A robust Flutter mobile application implementing Smart Attendance Management functionality using Firebase Authentication and Firestore Database. Designed with clean MVVM architecture principles and Material Design components.

## Features
- **Firebase Authentication**: Secure Email/Password login and registration.
- **Three User Roles**: 
  1. **Admin**: Can view system logs, all students, and analytics. (For academic scope, viewing all attendance)
  2. **Instructor**: Can initiate attendance sessions and view their section's attendance.
  3. **Student**: Can view personal attendance history and mark their own attendance contextually.
- **Role-Based Routing**: Cleanly redirects users to their appropriate dashboard after authentication.
- **Cloud Firestore**: Real-time attendance data syncing.
- **Material Design**: Follows modern Google Material UI/UX practices.

## Folder Structure
We adhere to a standard clean architecture for Flutter apps:
```
lib/
  models/        # Data schemas and serialization (UserModel, AttendanceModel)
  screens/       # UI Widgets corresponding to full screens (Login, Dashboards)
  services/      # APIs, Databases, external communication (FirebaseService)
  viewmodels/    # State management handling business logic via Provider
  widgets/       # Reusable modular UI components (e.g. AppBars, Custom Buttons)
  main.dart      # Application entry point & Routing
```

## Setup Instructions

### Prerequisites
- Flutter SDK (latest stable)
- A Firebase Project (configured via Firebase Console)

### 1. Link Firebase
Due to environment restrictions, platform files (`android/`, `ios/`) might need refreshing.
Run the following in the project root:
```bash
# Re-generate necessary platform files
flutter create .

# Configure Firebase locally
flutterfire configure
```
Select the platforms you need (Android/iOS) and allow it to generate `firebase_options.dart`.

### 2. Initialize Firebase in Code
Once `flutterfire configure` completes, open `lib/main.dart` and uncomment the Firebase initialization code:
```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ... run app
}
```

### 3. Run the Application
Start up an emulator or connect a physical device.
```bash
flutter run
```

## Technical Debt / Future Improvements
- Implement QR Code scanning or geolocation logic for students marking attendance.
- Expand Instructor role to manage individual courses and classes.
- Add detailed statistics and export features for Admins.
