# GlobGram P2P

A Flutter WebRTC peer-to-peer chat application with real-time messaging capabilities.

## Features

- ✅ P2P WebRTC Connection
- ✅ Real-time Chat Messaging
- ✅ Room-based Communication
- ✅ Modern Material 3 UI
- ✅ State Management with BloC
- ✅ Dependency Injection with GetIt
- ✅ Local State Persistence with HydratedBloC

## Architecture

This application follows Clean Architecture principles:

```
lib/
├── core/
│   ├── service_locator.dart    # Dependency injection setup
│   └── app_router.dart         # Go Router configuration
├── features/
│   ├── chat/
│   │   ├── domain/
│   │   │   └── chat_message.dart
│   │   ├── data/
│   │   │   └── webrtc_service.dart
│   │   └── presentation/
│   │       ├── chat_bloc.dart
│   │       └── chat_page.dart
│   └── room_selection/
│       └── presentation/
│           └── room_selection_page.dart
└── main.dart
```

## Build Instructions

### Prerequisites

- Flutter SDK ≥ 3.8.1
- Dart SDK ≥ 3.8.1
- Chrome browser (for web testing)

### Setup

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate code (for Freezed models):**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the application:**
   ```bash
   # For web (recommended for WebRTC testing)
   flutter run -d chrome
   
   # For mobile platforms
   flutter run -d <device-id>
   ```

### Development Commands

```bash
# Code generation
flutter packages pub run build_runner build

# Watch mode for development
flutter packages pub run build_runner watch

# Clean build
flutter clean && flutter pub get

# Analyze code
flutter analyze

# Run tests
flutter test
```

## Usage

1. **Home Screen**: Launch the application
2. **Room Selection**: Enter or create a room ID
3. **Chat Interface**: 
   - Real-time messaging with WebRTC
   - Connection status indicators:
     - ⏸ Grey: Disconnected
     - ⚡ Yellow: Connecting
     - ✅ Green: Connected & Ready
   - Message bubbles:
     - Self messages: Right-aligned, light green (#E1FFC7)
     - Peer messages: Left-aligned, grey-white
   - Input controls: Emoji, text field, attach, send

## WebRTC Configuration

For development and testing, you may need to configure Firestore security rules:

```javascript
// Firestore Security Rules for WebRTC Signaling
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access to signaling data
    match /rooms/{roomId}/signals/{signalId} {
      allow read, write: if true; // For development only
    }
    
    // Allow read/write access to room metadata
    match /rooms/{roomId} {
      allow read, write: if true; // For development only
    }
  }
}
```

**⚠️ Security Notice**: The above rules are for development only. In production, implement proper authentication and authorization.

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **WebRTC**: Real-time peer-to-peer communication
- **BloC**: State management pattern
- **GetIt**: Dependency injection
- **HydratedBloC**: State persistence
- **Go Router**: Declarative routing
- **Freezed**: Code generation for immutable classes
- **Logger**: Structured logging

## Firebase Setup

This application requires Firebase configuration for Firestore-based signaling. Follow these steps to set up Firebase:

### Prerequisites

Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

### Configuration Steps

1. **Configure Firebase Project**
   ```bash
   flutterfire configure --project <YOUR_FIREBASE_PROJECT>
   ```
   
2. **Update firebase_options.dart**
   
   After running the configure command, check `lib/firebase_options.dart` and replace any TODO placeholders with actual values:
   - `TODO: Add your API key`
   - `TODO: Add your App ID`
   - `TODO: Add your Messaging Sender ID`
   - `TODO: Add your Project ID`
   - `TODO: Add your Auth Domain`
   - `TODO: Add your Storage Bucket`
   - `TODO: Add your Measurement ID`

3. **Enable Firestore**
   
   In the [Firebase Console](https://console.firebase.google.com):
   - Navigate to your project
   - Go to **Firestore Database**
   - Click **Create database**
   - Choose **Start in production mode** (or test mode for development)

### Development Warning

⚠️ **SECURITY WARNING**: Do NOT commit production API keys with permissive security rules to version control. Use environment-specific configurations and proper access controls for production deployments.

### Quick Troubleshooting

If you encounter **"Unable to initialize Firebase"** errors:

1. **Check Internet Connection**: Ensure your device/emulator has internet access
2. **Verify Options File**: Confirm `lib/firebase_options.dart` contains valid project configuration
3. **Restart Application**: Try hot restart (not just hot reload) after configuration changes
4. **Check Console**: Look for detailed error messages in the Flutter console

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

## Development

### Upcoming Refactor

This project includes draft Freezed state implementations in preparation for Phase 5 refactor:
- `lib/features/chat/presentation/bloc/draft_chat_state.dart` - Type-safe ChatState with Freezed
- `lib/features/room_selection/presentation/bloc/draft_room_selection_state.dart` - Type-safe RoomSelectionState with Freezed

These draft implementations will replace the current Equatable-based states to provide better type safety and immutability.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
