import 'package:get_it/get_it.dart';
import 'package:globgram_p2p/core/app_config.dart';
import 'package:globgram_p2p/core/signaling_service.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source_firestore_legacy.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/in_memory_signaling_data_source.dart';
// import 'package:globgram_p2p/features/room_selection/data/datasources/firestore_signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_local_bloc.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';
import 'package:globgram_p2p/features/chat/data/webrtc_service_impl.dart';
import 'package:globgram_p2p/features/chat/data/webrtc_service_mock.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core SignalingDataSource - registration based on feature flag
  if (AppConfig.useFirestoreSignaling) {
    // TODO: Fix Firestore implementation
    // getIt.registerLazySingleton<SignalingDataSource>(() => FirestoreSignalingDataSource());
    getIt.registerLazySingleton<SignalingDataSource>(() => InMemorySignalingDataSource());
  } else {
    getIt.registerLazySingleton<SignalingDataSource>(() => InMemorySignalingDataSource());
  }

  // Legacy Firestore datasource (kept for compatibility)
  getIt.registerLazySingleton<RoomRemoteDataSourceFirestore>(
    () => RoomRemoteDataSourceFirestore(),
  );

  // Room Selection Bloc - depends on SignalingDataSource interface
  getIt.registerFactory<RoomSelectionLocalBloc>(
    () => RoomSelectionLocalBloc(
      signalingDataSource: getIt<SignalingDataSource>(),
    ),
  );

  // WebRTC service registration - real implementation when using Firestore, mock otherwise
  getIt.registerLazySingleton<WebRTCService>(() {
    if (AppConfig.useFirestoreSignaling) {
      return WebRTCServiceImpl(getIt<SignalingDataSource>());
    } else {
      return WebRTCServiceMock();
    }
  });

  // Signaling abstraction service
  getIt.registerLazySingleton<SignalingService>(() => SignalingService());

  // ChatBloc - depends on both WebRTC service and SignalingDataSource
  getIt.registerFactory<ChatBloc>(() => ChatBloc(
    getIt<WebRTCService>(),
    getIt<SignalingDataSource>(),
  ));
}
