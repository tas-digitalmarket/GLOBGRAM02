import 'package:flutter_test/flutter_test.dart';
import 'package:globgram_p2p/features/room_selection/data/datasources/firestore_signaling_data_source.dart';

void main() {
  test('FirestoreSignalingDataSource import test', () {
    // Just checking if we can import and reference the class
    expect(FirestoreSignalingDataSource, isNotNull);
  });
}
