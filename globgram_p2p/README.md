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

This application follows Clean Architecture principles with WebRTC P2P communication:

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              GlobGram P2P Architecture                        │
└─────────────────────────────────────────────────────────────────────────────┘

   User A Device                                              User B Device
┌─────────────────┐                                        ┌─────────────────┐
│   UI Layer      │                                        │   UI Layer      │
│ ┌─────────────┐ │                                        │ ┌─────────────┐ │
│ │ ChatPage    │ │                                        │ │ ChatPage    │ │
│ │ MessageList │ │                                        │ │ MessageList │ │
│ │ TextInput   │ │                                        │ │ TextInput   │ │
│ └─────────────┘ │                                        │ └─────────────┘ │
│        │        │                                        │        │        │
│ ┌─────────────┐ │                                        │ ┌─────────────┐ │
│ │  ChatBloc   │ │                                        │ │  ChatBloc   │ │
│ │ (BlocState) │ │                                        │ │ (BlocState) │ │
│ └─────────────┘ │                                        │ └─────────────┘ │
│        │        │                                        │        │        │
│ ┌─────────────┐ │                                        │ ┌─────────────┐ │
│ │WebRTCService│ │     ┌─────────────────────────┐        │ │WebRTCService│ │
│ │             │ │────▶│    Firestore Signaling  │◀───────│ │             │ │
│ │ PeerConn    │ │     │                         │        │ │ PeerConn    │ │
│ │ DataChannel │ │     │ ┌─────────────────────┐ │        │ │ DataChannel │ │
│ └─────────────┘ │     │ │ /rooms/{roomId}/    │ │        │ └─────────────┘ │
│        │        │     │ │ ├─ offer             │ │        │        │        │
│        │        │     │ │ ├─ answer            │ │        │        │        │
│        │        │     │ │ └─ iceCandidates/    │ │        │        │        │
│        │        │     │ └─────────────────────┘ │        │        │        │
│        │        │     └─────────────────────────┘        │        │        │
│        │        │                                        │        │        │
│ ┌──────▼──────┐ │                                        │ ┌──────▼──────┐ │
│ │             │ │◀═══════════════════════════════════════▶│ │             │ │
│ │ WebRTC P2P  │ │     Direct Data Channel Connection     │ │ WebRTC P2P  │ │
│ │ Connection  │ │          (Encrypted Messages)          │ │ Connection  │ │
│ │             │ │                                        │ │             │ │
│ └─────────────┘ │                                        │ └─────────────┘ │
└─────────────────┘                                        └─────────────────┘

Flow:
1. UI triggers ChatBloc events
2. ChatBloc calls WebRTCService methods  
3. WebRTCService uses Firestore for signaling
4. WebRTC establishes direct P2P connection
5. Messages flow through encrypted data channel
6. State updates propagate back through BlocBuilder
```

### Directory Structure

```
lib/
├── core/
│   ├── service_locator.dart    # Dependency injection setup
│   ├── app_router.dart         # Go Router configuration
│   └── app_theme.dart          # Material 3 theming
├── features/
│   ├── chat/
│   │   ├── domain/
│   │   │   ├── chat_message.dart        # Message entity
│   │   │   └── webrtc_service.dart      # WebRTC interface
│   │   ├── data/
│   │   │   ├── webrtc_service_impl.dart # WebRTC implementation
│   │   │   └── webrtc_service_mock.dart # Mock for testing
│   │   └── presentation/
│   │       ├── chat_bloc.dart           # Chat state management
│   │       ├── chat_state.dart          # Freezed state classes
│   │       ├── chat_page.dart           # Main chat UI
│   │       └── widgets/
│   │           ├── message_bubble.dart  # Message display
│   │           └── connection_status_widget.dart
│   └── room_selection/
│       ├── data/
│       │   └── datasources/
│       │       ├── signaling_data_source.dart    # Signaling interface
│       │       ├── firestore_signaling_data_source.dart
│       │       └── in_memory_signaling_data_source.dart
│       └── presentation/
│           └── room_selection_page.dart
└── main.dart
```

## Development Launch Instructions

### Prerequisites

- Flutter SDK ≥ 3.8.1
- Dart SDK ≥ 3.8.1
- Chrome browser (for web testing)
- Android Studio with Android SDK (for Android development)
- Xcode (for iOS development on macOS)

### Step-by-Step Setup

#### 1. Initial Setup
```bash
# Clone the repository
git clone <repository-url>
cd globgram_p2p

# Install dependencies
flutter pub get

# Generate code (for Freezed models)
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 2. Firebase Configuration
```bash
# Install FlutterFire CLI (if not already installed)
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure

# Follow prompts to select/create Firebase project
# This updates lib/firebase_options.dart automatically
```

#### 3. Launch for Web Development

**Option A: VS Code**
```bash
# Launch with Chrome
flutter run -d chrome --web-port 8080

# Or with web-server for lightweight testing
flutter run -d web-server --web-port 8080
```

**Option B: Command Line**
```bash
# Debug mode with hot reload
flutter run -d chrome --web-port 8080 --dart-define=FLUTTER_WEB_USE_SKIA=true

# Release mode for performance testing
flutter run -d chrome --web-port 8080 --release
```

**Web Development Tips:**
- Use Chrome DevTools for WebRTC debugging
- Enable Developer Tools → Application → Service Workers for debugging
- Check Network tab for Firestore signaling traffic
- Use chrome://webrtc-internals/ for WebRTC connection details

#### 4. Launch for Android Development

**Device Setup:**
```bash
# List available devices
flutter devices

# Launch on physical device
flutter run -d <device-id>

# Launch on emulator
flutter run -d emulator-5554
```

**Android-Specific Setup:**
```bash
# Ensure Android SDK is properly configured
flutter doctor -v

# For WebRTC permissions, ensure these are in android/app/src/main/AndroidManifest.xml:
# <uses-permission android:name="android.permission.INTERNET" />
# <uses-permission android:name="android.permission.RECORD_AUDIO" />
# <uses-permission android:name="android.permission.CAMERA" />
```

**Android Development Tips:**
- Use Android Studio's logcat for debugging
- Test on both physical device and emulator
- WebRTC works best on physical devices for audio/video features
- Use `flutter logs` to see real-time debug output

### Development Workflow Commands

```bash
# Hot reload during development
r (in flutter run session)

# Hot restart (full restart)
R (in flutter run session)

# Watch mode for code generation
flutter packages pub run build_runner watch

# Code analysis
flutter analyze --no-fatal-infos

# Testing
flutter test

# Clean build (when dependencies change)
flutter clean && flutter pub get

# Build for production
flutter build web --release
flutter build apk --release
```

### Environment Configuration

**Debug Mode (Default):**
- Uses in-memory signaling data source
- Verbose logging enabled
- Hot reload support

**Production Mode:**
```bash
# Build with production Firebase config
flutter build web --dart-define=ENVIRONMENT=production
flutter build apk --dart-define=ENVIRONMENT=production
```

### Common Development Issues

**Port Already in Use:**
```bash
# Kill processes using port 8080
npx kill-port 8080

# Or use different port
flutter run -d chrome --web-port 3000
```

**Code Generation Issues:**
```bash
# Clean and regenerate
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Dependency Conflicts:**
```bash
# Update dependencies
flutter pub upgrade

# Clean install
flutter clean
rm pubspec.lock
flutter pub get
```

## Troubleshooting

### Common WebRTC Issues

#### 1. Room Not Found Error

**Symptoms:**
- Error message: "Room not found" or "Failed to join room"
- Unable to connect to peer

**Solutions:**
```bash
# Check Firestore configuration
1. Verify firebase_options.dart has correct project settings
2. Ensure Firestore security rules allow read/write access
3. Check room ID is exactly matching (case-sensitive)

# Debug steps
flutter run -d chrome --dart-define=DEBUG_LOGGING=true
# Check browser console for Firestore errors
```

**Firestore Rules for Development:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /rooms/{roomId}/{document=**} {
      allow read, write: if true; // Development only
    }
  }
}
```

#### 2. Stalled at "Connecting" State

**Symptoms:**
- Connection status shows "Connecting" indefinitely
- No transition to "Connected" state
- Messages not being sent/received

**Solutions:**
```bash
# Check ICE candidate exchange
1. Open chrome://webrtc-internals/ in Chrome
2. Look for failed ICE connections
3. Verify STUN server connectivity

# Network debugging
1. Check firewall settings
2. Try different network (mobile hotspot)
3. Verify internet connectivity for both peers
```

**Code Debugging:**
```dart
// Add to WebRTCServiceImpl for detailed ICE logging
_peerConnection!.onIceConnectionState = (state) {
  print('ICE Connection State: $state');
  // Add breakpoint here to debug state transitions
};
```

#### 3. No ICE Candidates Generated

**Symptoms:**
- WebRTC connection fails
- No ICE candidates appear in chrome://webrtc-internals/
- Timeout errors during connection setup

**Solutions:**
```bash
# STUN server issues
1. Check internet connectivity
2. Try alternative STUN servers:
   - stun:stun1.l.google.com:19302
   - stun:stun2.l.google.com:19302
3. Consider TURN server for restrictive networks
```

**Alternative STUN Configuration:**
```dart
final configuration = {
  'iceServers': [
    {'urls': 'stun:stun.l.google.com:19302'},
    {'urls': 'stun:stun1.l.google.com:19302'},
    {'urls': 'stun:stun2.l.google.com:19302'},
  ],
};
```

#### 4. Firebase Initialization Errors

**Symptoms:**
- "Unable to initialize Firebase" error
- App crashes on startup
- Firestore permission denied errors

**Solutions:**
```bash
# Reconfigure Firebase
flutterfire configure --force

# Check configuration
1. Verify lib/firebase_options.dart exists
2. Confirm project ID matches Firebase console
3. Ensure web app is registered in Firebase project

# Clear app data (development)
flutter clean
flutter pub get
```

#### 5. Permission Denied Errors

**Symptoms:**
- Firestore operations fail
- "Missing or insufficient permissions" error
- Unable to read/write signaling data

**Solutions:**
```bash
# Temporary fix for development
# Update Firestore rules to allow all access:
```

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

#### 6. Build/Compilation Issues

**Symptoms:**
- Flutter analyze errors
- Build failures
- Import resolution issues

**Solutions:**
```bash
# Clean rebuild
flutter clean
rm -rf .dart_tool/
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check Flutter version
flutter --version
flutter upgrade (if needed)

# Verify dependencies
flutter pub deps
```

#### 7. WebRTC Not Working on Mobile

**Symptoms:**
- Works on web but fails on Android/iOS
- Permission errors for camera/microphone
- Network connectivity issues

**Solutions:**
```bash
# Android permissions in android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />

# iOS permissions in ios/Runner/Info.plist
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for voice calls</string>
```

### Debugging Tools

#### 1. Chrome WebRTC Internals
```
URL: chrome://webrtc-internals/
Purpose: Real-time WebRTC connection analysis
Key Metrics: ICE states, candidate pairs, data channel stats
```

#### 2. Flutter Debug Console
```bash
# Enable verbose logging
flutter run -d chrome --dart-define=DEBUG_LOGGING=true

# Watch for specific log patterns
flutter logs | grep -E "(WebRTC|ICE|Firestore)"
```

#### 3. Firestore Console Debugging
```
1. Open Firebase Console > Firestore Database
2. Navigate to /rooms/{roomId} collection
3. Monitor real-time document changes
4. Verify offer/answer/candidates are being written
```

#### 4. Network Analysis
```bash
# Check WebRTC connectivity
1. Open browser dev tools > Network tab
2. Filter by WebSocket connections
3. Monitor Firestore real-time listeners
4. Check for failed requests
```

### Performance Optimization

#### 1. Connection Speed Issues
```dart
// Optimize ICE gathering
final configuration = {
  'iceServers': [
    {'urls': 'stun:stun.l.google.com:19302'},
  ],
  'iceCandidatePoolSize': 10,  // Pre-gather candidates
};
```

#### 2. Message Latency
```dart
// Monitor data channel performance
_dataChannel!.onMessage = (message) {
  final receivedTime = DateTime.now();
  print('Message latency: ${receivedTime.millisecondsSinceEpoch}');
};
```

### Support Resources

- **WebRTC Documentation**: https://webrtc.org/getting-started/
- **Flutter WebRTC Plugin**: https://pub.dev/packages/flutter_webrtc
- **Firebase Firestore**: https://firebase.google.com/docs/firestore
- **Chrome WebRTC Internals**: chrome://webrtc-internals/

For additional support, check the project's GitHub issues or create a new issue with:
1. Flutter version (`flutter --version`)
2. Platform (web/Android/iOS)
3. Error logs and steps to reproduce
4. Browser console output (for web issues)

## Usage

### Application Flow

1. **Home Screen**: Launch the application
2. **Room Selection**: Enter or create a room ID
3. **Chat Interface**: 
   - Real-time messaging with WebRTC
   - Connection status indicators:
     - ⏸ Grey: Disconnected
     - ⚡ Yellow: Connecting
     - ✅ Green: Connected & Ready
   - Message bubbles:
     - Self messages: Right-aligned, theme primary container
     - Peer messages: Left-aligned, theme secondary container
   - Input controls: Text field with send button
   - Long-press messages for timestamp tooltips

### Localization Support

The application supports multiple languages:
- **English**: Default language
- **Persian (Farsi)**: Complete translation available
- **Language Toggle**: Available in room selection for testing

### Features Overview

- ✅ **P2P WebRTC Connection**: Direct peer-to-peer communication
- ✅ **Real-time Chat Messaging**: Instant message delivery
- ✅ **Room-based Communication**: Isolated chat rooms
- ✅ **Modern Material 3 UI**: Latest Material Design components
- ✅ **State Management with BloC**: Reactive state management
- ✅ **Dependency Injection with GetIt**: Clean architecture
- ✅ **Local State Persistence with HydratedBloC**: Chat history preservation
- ✅ **Secure Signaling**: Automatic SDP cleanup after connection
- ✅ **Internationalization**: Multi-language support
- ✅ **Theme Integration**: Adaptive UI components
- 🚧 **Media Hooks**: Audio/video ready for future implementation

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

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or select an existing one
   - Enable Firestore Database in production mode

2. **Configure Firebase for Flutter**
   ```bash
   # Run this command in your project root
   flutterfire configure
   ```
   
   This command will:
   - Automatically detect your Flutter platforms
   - Create/update `lib/firebase_options.dart` with platform-specific configurations
   - Set up proper platform registrations

3. **Verify Configuration**
   
   Check `lib/firebase_options.dart` - it should contain valid configurations for:
   - ✅ Web: `apiKey`, `appId`, `projectId`, `authDomain`, `storageBucket`
   - ✅ Android: `apiKey`, `appId`, `projectId`, `storageBucket` 
   - ✅ iOS: `apiKey`, `appId`, `projectId`, `storageBucket`, `iosBundleId`

### Security Notes

⚠️ **Important**: The current `firebase_options.dart` contains dummy values for development.

**For Production:**
- Run `flutterfire configure` to generate real configuration
- Never commit real API keys to public repositories
- Consider using environment variables or CI/CD secrets for sensitive values
- Use Firebase App Check for additional security

**For Development:**
- Current dummy values are safe for local testing
- Firestore rules should be configured for development/production modes
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

## Migration

### Hydrated State Migration (v2.0)

This application uses HydratedBloc for persisting chat state between app sessions. When upgrading from older versions, the app automatically handles state migration:

#### Automatic Migration

- **Version Detection**: The app checks storage version on startup
- **Automatic Reset**: If an older version is detected, chat history is automatically cleared
- **Seamless Experience**: Users start with a clean slate after major updates

#### Manual Migration

If you need to manually clear persisted chat data during development:

```dart
// Clear all persisted chat state
await ChatBloc.clearHydratedState();
```

#### Migration Log

- **v2.0**: Implemented Freezed state classes, clearing old Equatable-based persisted states
- **v1.0**: Initial implementation with Equatable states

#### Storage Structure

Current storage version: **2**

The chat state is persisted with the following structure:
```json
{
  "storage_version": 2,
  "type": "connected|connecting|initial|error|disconnected",
  "roomId": "string",
  "isCaller": "boolean",
  "messages": [...],
  "message": "string (for error state)"
}
```

When the storage version is lower than the current version (2), all persisted data is cleared and the user starts fresh.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

## Development

### Upcoming Refactor

This project includes draft Freezed state implementations prepared for Phase 5 refactor:
- `lib/features/chat/presentation/draft_chat_state.dart` - Type-safe ChatState with Freezed
- `lib/features/room_selection/presentation/draft_room_selection_state.dart` - Type-safe RoomSelectionState with Freezed

These draft implementations will replace the current Equatable-based states to provide better type safety and immutability.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
