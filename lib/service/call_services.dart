part of 'services.dart';

class CallServices{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  CallServices({required this.auth, required this.firestore, required this.storage});

  Future<void> createCallChannel(String handlesUID, DateTime startTime) async {
    firestore
    .collection('call_channels')
    .doc(handlesUID)
    .set({
      'participants': [auth.currentUser!.uid],
      'startTime': startTime.toString()
    });
  }

  Future<void> updateCallChannel(String handlesUID, List<String> addParticipants, DateTime endTime) async {
    firestore
    .collection('call_channels')
    .doc(handlesUID)
    .update({
      'participants': addParticipants,
      'endTime': endTime.toString()
    });
  }
}