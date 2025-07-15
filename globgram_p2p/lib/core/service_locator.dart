import 'package:get_it/get_it.dart';
import '../features/room_selection/data/room_remote_data_source.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register data sources
  getIt.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(),
  );
}
