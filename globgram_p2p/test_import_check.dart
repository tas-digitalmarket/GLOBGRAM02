import 'package:globgram_p2p/features/room_selection/data/datasources/firestore_signaling_data_source.dart';

void main() {
  final firestore = FirestoreSignalingDataSource();
  print('Import works: $firestore');
}
