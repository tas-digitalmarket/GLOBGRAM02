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
│                          GlobGram P2P Architecture                           │
└─────────────────────────────────────────────────────────────────────────────┘

             User Interface Layer
      ┌─────────────────────────────────┐
      │         Flutter UI              │
      │  ┌───────────┐  ┌─────────────┐ │
      │  │ ChatPage  │  │ RoomSelect  │ │
      │  │ Widgets   │  │ Page        │ │
      │  └─────┬─────┘  └─────────────┘ │
      └────────┼─────────────────────────┘
               │ BlocBuilder / BlocListener
               ▼
      ┌─────────────────────────────────┐
      │      Presentation Layer         │
      │  ┌─────────────────────────────┐ │
      │  │        ChatBloc             │ │
      │  │   (State Management)        │ │
      │  │  ┌─────────┐ ┌────────────┐ │ │
      │  │  │ Events  │ │   States   │ │ │
      │  │  └─────────┘ └────────────┘ │ │
      │  └──────────┬──────────────────┘ │
      └─────────────┼─────────────────────┘
                    │ calls
                    ▼
      ┌─────────────────────────────────┐
      │       Domain Layer              │
      │  ┌─────────────────────────────┐ │
      │  │     WebRTCService           │ │
      │  │    (Abstract Interface)     │ │
      │  │  • createConnection()       │ │
      │  │  • sendText()               │ │
      │  │  • prepareMedia()           │ │
      │  │  • localStream$ / remote$   │ │
      │  └──────────┬──────────────────┘ │
      └─────────────┼─────────────────────┘
                    │ implements
                    ▼
      ┌─────────────────────────────────┐
      │        Data Layer               │
      │  ┌─────────────────────────────┐ │
      │  │   WebRTCServiceImpl         │ │
      │  │  ┌─────────────────────────┐ │ │
      │  │  │   RTCPeerConnection     │ │ │
      │  │  │   RTCDataChannel        │ │ │
      │  │  │   MediaStream handling  │ │ │
      │  │  └─────────────────────────┘ │ │
      │  └──────────┬──────────────────┘ │
      └─────────────┼─────────────────────┘
                    │ signals via
                    ▼
      ┌─────────────────────────────────┐
      │    Signaling Infrastructure     │
      │  ┌─────────────────────────────┐ │
      │  │    Firestore Database       │ │
      │  │  ┌─────────────────────────┐ │ │
      │  │  │ /rooms/{roomId}/        │ │ │
      │  │  │  ├─ offer              │ │ │
      │  │  │  ├─ answer             │ │ │
      │  │  │  ├─ iceCandidates/     │ │ │
      │  │  │  └─ metadata          │ │ │
      │  │  └─────────────────────────┘ │ │
      │  └─────────────────────────────┘ │
      └─────────────────────────────────┘
                    │
                    │ WebRTC P2P Connection
                    │ (Direct Encrypted Data Channel)
                    ▼
      ┌─────────────────────────────────┐
      │         Remote Peer             │
      │     (Another GlobGram App)      │
      └─────────────────────────────────┘

Data Flow:
1. UI → ChatBloc (Events)
2. ChatBloc → WebRTCService (Method calls)  
3. WebRTCService → Firestore (Signaling)
4. WebRTC establishes → Direct P2P Connection
5. Messages flow through → Encrypted DataChannel
6. State updates propagate ← BlocBuilder updates UI
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
- Firebase project with Firestore enabled

### Step-by-Step Setup

#### 1. Initial Setup
```bash
# Clone the repository
git clone <repository-url>
cd globgram_p2p

# Install dependencies
flutter pub get

# Generate code (for Freezed models)
dart run build_runner build --delete-conflicting-outputs
```

#### 2. Firebase Configuration
```bash
# Install FlutterFire CLI (if not already installed)
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure --project=your-firebase-project-id

# Follow prompts to select/create Firebase project
# This updates lib/firebase_options.dart automatically

# Enable Firestore in Firebase Console:
# 1. Go to Firebase Console → Your Project → Firestore Database
# 2. Click "Create database" → Start in test mode
# 3. Choose location closest to your users
```

#### 3. Launch for Web Development

**Quick Start (Recommended):**
```bash
# Launch with Chrome and automatic hot reload
flutter run -d chrome --web-port 8080

# Access your app at: http://localhost:8080
```

**Advanced Web Launch Options:**
```bash
# Debug mode with enhanced WebRTC debugging
flutter run -d chrome --web-port 8080 \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --dart-define=FLUTTER_WEB_DEBUG_SHOW_SEMANTICS=true

# Release mode for performance testing  
flutter run -d chrome --web-port 8080 --release

# Web-server mode (lightweight, no Chrome DevTools)
flutter run -d web-server --web-port 8080
```

**Testing P2P Connection on Web:**
1. Open first tab: `http://localhost:8080`
2. Create/join room (e.g., "test123")
3. Open second tab: `http://localhost:8080` 
4. Join same room ID
5. Start chatting between tabs

**Web Development Tips:**
- Use Chrome DevTools for WebRTC debugging
- Visit `chrome://webrtc-internals/` for detailed WebRTC stats
- Check Network tab for Firestore signaling traffic
- Enable Developer Tools → Application → Service Workers for debugging

#### 4. Launch for Android Development

**Device Setup:**
```bash
# List available devices
flutter devices

# Expected output:
# Chrome (web)           • chrome           • web-javascript • Google Chrome
# Android SDK built...   • emulator-5554    • android-x64    • Android 11 (API 30)
# SM G973F (mobile)      • RZ8M8XXXXXX      • android-arm64  • Android 12 (API 31)
```

**Launch Commands:**
```bash
# Launch on physical device (recommended for WebRTC)
flutter run -d RZ8M8XXXXXX  # Your device ID

# Launch on emulator
flutter run -d emulator-5554

# Debug mode with enhanced logging
flutter run -d RZ8M8XXXXXX --debug --verbose
```

**Android-Specific Setup:**
```bash
# Verify Android setup
flutter doctor -v

# Check for required permissions in android/app/src/main/AndroidManifest.xml:
# <uses-permission android:name="android.permission.INTERNET" />
# <uses-permission android:name="android.permission.RECORD_AUDIO" />
# <uses-permission android:name="android.permission.CAMERA" />
# <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

**Testing P2P Connection on Android:**
1. Install on two Android devices OR
2. Use one Android device + one web browser OR  
3. Use Android emulator + physical device
4. Both join same room ID
5. Test real-time messaging

**Android Development Tips:**
- Use Android Studio's logcat: `View → Tool Windows → Logcat`
- Filter logs: `flutter:` or `WebRTC:`
- WebRTC performs better on physical devices
- Use `flutter logs` in terminal for real-time debug output

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
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Troubleshooting FAQ

### Connection Issues

#### ❓ "Room not found" or "Failed to join room"

**Symptoms:** App shows error when trying to join a room, or room creation fails.

**Solutions:**
1. **Check Firebase Configuration:**
   ```bash
   # Verify Firebase is properly configured
   flutter clean && flutter pub get
   
   # Reconfigure if needed
   flutterfire configure --project=your-project-id
   ```

2. **Verify Firestore Rules:**
   - Go to Firebase Console → Firestore Database → Rules
   - Ensure rules allow read/write access:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /rooms/{roomId}/{document=**} {
         allow read, write: if true;  // For testing only
       }
     }
   }
   ```

3. **Check Network Connection:**
   ```bash
   # Test Firestore connectivity
   curl -X GET "https://firestore.googleapis.com/v1/projects/YOUR_PROJECT_ID/databases/(default)/documents/test/test"
   ```

#### ❓ "Stuck on Connecting..." state

**Symptoms:** App shows "Connecting..." indefinitely, WebRTC connection never establishes.

**Solutions:**
1. **ICE Candidate Issues - Add TURN Server:**
   ```dart
   // In WebRTCServiceImpl, update _iceServers:
   final List<Map<String, dynamic>> _iceServers = [
     {'urls': 'stun:stun.l.google.com:19302'},
     {'urls': 'stun:stun1.l.google.com:19302'},
     // Add TURN server for NAT traversal:
     {
       'urls': 'turn:your-turn-server.com:3478',
       'username': 'your-username',
       'credential': 'your-password'
     }
   ];
   ```

2. **Firewall/Network Issues:**
   - Try connecting both devices to same WiFi network
   - Disable VPN/proxy temporarily
   - Check if corporate firewall blocks WebRTC traffic

3. **Clear App State:**
   ```bash
   # Clear browser cache/storage (Web)
   # Or clear app data (Android)
   
   # Or programmatically:
   await ChatBloc.clearHydratedState();
   ```

4. **Check Browser Compatibility:**
   - Use Chrome or Firefox (recommended)
   - Ensure WebRTC is enabled in browser settings
   - Try incognito/private mode

#### ❓ "No ICE candidates" or "ICE connection failed"

**Symptoms:** WebRTC connection fails during ICE gathering phase.

**Solutions:**
1. **Verify STUN/TURN Servers:**
   ```bash
   # Test STUN server connectivity
   telnet stun.l.google.com 19302
   ```

2. **Debug ICE Candidates:**
   - Open Chrome DevTools → Console
   - Look for ICE candidate logs
   - Visit `chrome://webrtc-internals/` for detailed ICE stats

3. **Network Environment Issues:**
   ```markdown
   - Symmetric NAT: Requires TURN server
   - Restricted networks: May block UDP traffic
   - Mobile networks: Often have strict NAT policies
   ```

4. **Configuration Fix:**
   ```dart
   // Add more aggressive ICE gathering
   final configuration = {
     'iceServers': _iceServers,
     'iceCandidatePoolSize': 10,  // Increase pool size
     'bundlePolicy': 'max-bundle',
     'rtcpMuxPolicy': 'require',
   };
   ```

### Development Issues

#### ❓ "Hot reload not working" or "Code changes not reflecting"

**Solutions:**
```bash
# Force full restart
flutter clean && flutter pub get
flutter run -d chrome --web-port 8080

# Or use hot restart instead of hot reload
# Press 'R' in flutter run terminal (capital R)
```

#### ❓ "Build runner errors" or "Generated files missing"

**Solutions:**
```bash
# Clean and regenerate all files
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs

# If still failing, delete generated files manually:
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
dart run build_runner build
```

#### ❓ "Firebase initialization failed"

**Solutions:**
1. **Check firebase_options.dart:**
   ```bash
   # File should exist: lib/firebase_options.dart
   # If missing, regenerate:
   flutterfire configure
   ```

2. **Verify Project ID:**
   ```dart
   // In lib/firebase_options.dart, check:
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'your-api-key',
     appId: 'your-app-id', 
     projectId: 'your-project-id',  // ← Should match Firebase Console
   );
   ```

### Performance Issues

#### ❓ "App is slow" or "UI freezing"

**Solutions:**
1. **Enable Performance Mode:**
   ```bash
   flutter run --release -d chrome --web-port 8080
   ```

2. **Optimize for Web:**
   ```bash
   flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true --release
   ```

3. **Check Memory Usage:**
   - Use Chrome DevTools → Performance tab
   - Monitor WebRTC connection stats at `chrome://webrtc-internals/`

#### ❓ "Messages delayed" or "Connection drops frequently"

**Solutions:**
1. **Check Network Quality:**
   ```bash
   # Test ping to Firebase
   ping firestore.googleapis.com
   ```

2. **Implement Connection Monitoring:**
   ```dart
   // Monitor connection state changes
   _webrtcService.connectionState$.listen((state) {
     if (state == ConnectionState.failed) {
       // Implement reconnection logic
       _webrtcService.reconnect();
     }
   });
   ```

### Getting Help

If issues persist:
1. Check logs: `flutter logs` (Android) or Browser DevTools (Web)
2. Enable verbose logging: `flutter run --verbose`
3. Test with minimal reproduction case
4. Check Firebase Console for errors
5. Verify WebRTC compatibility: `chrome://webrtc-internals/`

For WebRTC-specific issues, the following resources are helpful:
- [WebRTC Troubleshooting Guide](https://webrtc.org/getting-started/testing)
- [Chrome WebRTC Internals](chrome://webrtc-internals/)
- [Firefox WebRTC Debug](about:webrtc)
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

### Hydrated State Migration (v3)

This application uses HydratedBloc for persisting chat state between app sessions. Starting with v3, the app uses a strict version checking system for enhanced data integrity:

#### Migration v3 (Current)

- **Strict Version Check**: The app now requires exact version match (`json['v'] == 3`)
- **Clean State Reset**: Any data from previous versions (v1, v2) is completely ignored
- **Fresh Start Approach**: Old persisted data is not migrated - users start with clean state
- **Enhanced Reliability**: Eliminates potential issues from legacy data formats

#### Implementation Details

```dart
// ChatBloc.fromJson() implementation
ChatState? fromJson(Map<String, dynamic> json) {
  final storedVersion = json['v'] as int?;
  if (storedVersion != 3) {
    // Returns null to ignore old data completely
    return null;
  }
  // Process only v3 format data...
}
```

#### Manual Migration

If you need to manually clear persisted chat data during development:

```dart
// Clear all persisted chat state
await ChatBloc.clearHydratedState();
```

#### Migration Log

- **v3.0**: Strict version checking - old data ignored, fresh start only
- **v2.0**: Implemented Freezed state classes, clearing old Equatable-based persisted states  
- **v1.0**: Initial implementation with Equatable states

#### Storage Structure

Current storage version: **3**

The chat state is persisted with the following structure:
```json
{
  "v": 3,
  "type": "connected|connecting|initial|error|disconnected",
  "roomId": "string",
  "isCaller": "boolean",
  "messages": [...],
  "message": "string (for error state)"
}
```

When the storage version is not exactly 3, all persisted data is ignored and the user starts with a fresh initial state.

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
