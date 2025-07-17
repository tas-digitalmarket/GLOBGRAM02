import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source_firestore.dart';
import 'package:globgram_p2p/features/chat/data/webrtc_service_impl.dart';
import 'package:globgram_p2p/features/chat/data/webrtc_service_mock.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Room datasource (original implementation)
  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(),
  );

  // Firestore datasource for WebRTC signaling
  getIt.registerLazySingleton<RoomRemoteDataSourceFirestore>(
    () => RoomRemoteDataSourceFirestore(),
  );

  // WebRTC service with conditional logic
  getIt.registerLazySingleton<Object>(() {
    // Use mock only for WEB + DEBUG hot‑reload
    if (kIsWeb && kDebugMode) return WebRTCService();
    return WebRTCServiceImpl(getIt<RoomRemoteDataSourceFirestore>());
  });

  // ChatBloc (depends on WebRTC service)
  getIt.registerFactory<ChatBloc>(() => ChatBloc(getIt<Object>() as WebRTCService));
}
