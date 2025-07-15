import 'package:get_it/get_it.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source.dart';
import 'package:globgram_p2p/features/chat/data/webrtc_service_mock.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Room datasource
  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(),
  );

  // WebRTC service (singleton)
  getIt.registerLazySingleton<WebRTCService>(() => WebRTCService());

  // ChatBloc (factory - new instance each time)
  getIt.registerFactory<ChatBloc>(() {
    final webRTCService = getIt<WebRTCService>();
    return ChatBloc(webRTCService);
  });
}
