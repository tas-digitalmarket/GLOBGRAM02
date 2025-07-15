import 'package:get_it/get_it.dart';
import '../features/room_selection/data/room_remote_data_source.dart';
// import '../features/chat/data/webrtc_service.dart';
import '../features/chat/data/webrtc_service_mock.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register data sources
  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(),
  );

  // Register chat services - using mock for web compatibility
  getIt.registerLazySingleton<WebRTCService>(
    () => WebRTCService(), // Mock service for web testing
  );
}
