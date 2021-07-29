part of 'services.dart';

class CallServices{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  CallServices({required this.auth, required this.firestore, required this.storage});

  Stream<CallModel> getCallChannel(String handlesUID){
    return firestore
    .collection('call_channels')
    .doc(handlesUID)
    .snapshots()
    .map((event){
      return event.exists
      ? CallModel(
          participants: (event['participants'] as List<dynamic>).cast<String>(),
          intendedParticipants: (event['intendedParticipants'] as List<dynamic>).cast<String>()
        )
      : CallModel(
          participants: [],
          intendedParticipants: []
        );
    });
  }

  Future<void> createCallChannel(String handlesUID, DateTime startTime, List<String> intendedParticipant) async {
    firestore
    .collection('call_channels')
    .doc(handlesUID)
    .set({
      'intendedParticipants': intendedParticipant,
      'participants': [auth.currentUser!.uid],
      'startTime': startTime.toString()
    });
  }

  Future<void> joinCallChannel(String handlesUID) async {
    firestore
    .collection('call_channels')
    .doc(handlesUID)
    .get()
    .then((value){

      List<dynamic> newParticipantsList = value["participants"];
      newParticipantsList.add(auth.currentUser!.uid);

      firestore
      .collection('call_channels')
      .doc(handlesUID)
      .update({
        'participants': newParticipantsList,
      });
    });
  }
  
  Future<void> terminateCallChannel(String handlesUID, DateTime endTime) async {
    firestore
    .collection('call_channels')
    .doc(handlesUID)
    .get()
    .then((value){

      print(value);

      firestore
      .collection('call_logs')
      .doc()
      .set({
        //if intendedParticipant != participants => declined
        'intendedParticipant': value["intendedParticipants"],
        'participants': value["participants"],
        'startTime': value["startTime"],
        'endTime': endTime.toString()
      }).then((value){
        firestore
        .collection('call_channels')
        .doc(handlesUID)
        .delete();
      });
    });
  }
}