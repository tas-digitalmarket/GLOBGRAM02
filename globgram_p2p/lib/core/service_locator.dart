import 'package:get_it/get_it.dart';
import '../features/room_selection/data/room_remote_data_source.dart';
import '../features/chat/data/webrtc_service_mock.dart'; // یا webrtc_service.dart
import '../features/chat/presentation/chat_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Room datasource
  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(),
  );

  // WebRTC service (singleton)
  getIt.registerLazySingleton<WebRTCService>(() => WebRTCService());

  // ChatBloc (depends on WebRTCService)
  getIt.registerFactory<ChatBloc>(() => ChatBloc(getIt<WebRTCService>()));
}
