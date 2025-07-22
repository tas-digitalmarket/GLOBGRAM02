import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globgram_p2p/core/signaling_service.dart';
import 'package:globgram_p2p/features/room_selection/data/room_remote_data_source_firestore_legacy.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/signaling_data_source.dart';
import 'package:globgram_p2p/data/datasources/firestore_signaling_data_source.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_local_bloc.dart';
import 'package:globgram_p2p/features/chat/domain/webrtc_service.dart';
import 'package:globgram_p2p/core/webrtc/webrtc_service_impl.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  final sl = GetIt.I;

  // Register Firebase Firestore instance
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Register only FirestoreSignalingDataSource
  sl.registerFactory<SignalingDataSource>(() {
    return FirestoreSignalingDataSource(firestore: sl<FirebaseFirestore>());
  });

  // Legacy Firestore datasource (kept for compatibility)
  sl.registerLazySingleton<RoomRemoteDataSourceFirestore>(
    () => RoomRemoteDataSourceFirestore(),
  );

  // Room Selection Bloc - depends on SignalingDataSource interface
  sl.registerFactory<RoomSelectionLocalBloc>(
    () => RoomSelectionLocalBloc(
      signalingDataSource: sl<SignalingDataSource>(),
    ),
  );

  // WebRTC service registration - Always use real implementation for production
  sl.registerLazySingleton<WebRTCService>(() => WebRTCServiceImpl(sl<SignalingDataSource>()));

  // Signaling abstraction service
  sl.registerLazySingleton<SignalingService>(() => SignalingService());

  // ChatBloc - depends only on WebRTC service
  sl.registerFactory<ChatBloc>(() => ChatBloc(
    sl<WebRTCService>(),
  ));
}
