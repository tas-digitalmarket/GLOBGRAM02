/// Application configuration and feature flags
class AppConfig {
  /// Feature flag: Use Firestore for signaling instead of in-memory
  /// Set to false to fallback to in-memory signaling for development/testing
  /// TODO: Set to true once freezed models are generated
  static const bool useFirestoreSignaling = false;

  /// Feature flag: Enable debug logging
  static const bool enableDebugLogging = true;

  /// Feature flag: Use production Firebase configuration
  static const bool useProductionFirebase = true;

  /// Feature flag: Enable room cleanup background task
  static const bool enableRoomCleanup = true;

  /// Room cleanup interval in hours
  static const int roomCleanupIntervalHours = 24;

  /// Maximum room age before cleanup (in hours)
  static const int maxRoomAgeHours = 48;

  /// ICE candidate timeout in seconds
  static const int iceCandidateTimeoutSeconds = 30;

  /// Answer polling timeout in seconds (for caller waiting for answer)
  static const int answerPollingTimeoutSeconds = 60;
}
