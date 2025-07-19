import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source_firestore.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source_local.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/in_memory_signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_local_bloc.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';
import 'package:globgram_p2p/features/chat/data/webrtc_service_impl.dart';
import 'package:globgram_p2p/features/chat/data/webrtc_service_local.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Room datasource (original implementation)
  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(),
  );

  // Local datasource for WebRTC signaling (for testing without Firebase)
  getIt.registerLazySingleton<RoomRemoteDataSourceLocal>(
    () => RoomRemoteDataSourceLocal(),
  );

  // Firestore datasource for WebRTC signaling
  getIt.registerLazySingleton<RoomRemoteDataSourceFirestore>(
    () => RoomRemoteDataSourceFirestore(),
  );

  // Signaling data sources for Phase 2
  getIt.registerLazySingleton<SignalingDataSource>(() {
    // Use in-memory for all environments (for now)
    return InMemorySignalingDataSource();
  });

  // Room Selection Bloc
  getIt.registerFactory<RoomSelectionLocalBloc>(
    () => RoomSelectionLocalBloc(localDataSource: getIt<RoomRemoteDataSourceLocal>()),
  );

  // WebRTC service with conditional logic
  getIt.registerLazySingleton<WebRTCService>(() {
    // Use local storage for testing (no Firebase needed)
    if (kIsWeb && kDebugMode) {
      return WebRTCServiceLocal(getIt<RoomRemoteDataSourceLocal>());
    }
    // Use Firestore for production
    return WebRTCServiceImpl(getIt<RoomRemoteDataSourceFirestore>());
  });

  // ChatBloc (depends on WebRTC service)
  getIt.registerFactory<ChatBloc>(() => ChatBloc(getIt<WebRTCService>()));
}
