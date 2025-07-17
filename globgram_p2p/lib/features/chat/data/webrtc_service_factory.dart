import 'package:flutter/foundation.dart';
import 'webrtc_service_mock.dart' as mock_service;
import 'webrtc_service_impl.dart';
import '../../room_selection/data/room_remote_data_source_firestore.dart';

/// Factory for creating WebRTC service instances
/// Uses real implementation on native platforms and mock on web for quick testing
class WebRTCServiceFactory {
  static dynamic create(RoomRemoteDataSourceFirestore firestoreDataSource) {
    if (kIsWeb) {
      // Use mock for web-only quick testing
      return mock_service.WebRTCService();
    } else {
      // Use real implementation for native platforms
      return WebRTCServiceImpl(firestoreDataSource);
    }
  }
}
