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

  Stream<List<CallModel>> getFilteredCallChannel(){
    return firestore
    .collection('call_logs')
    .where('intendedParticipants', arrayContains: auth.currentUser!.uid)
    .snapshots()
    .map((event){
      List<CallModel> out = [];
      event.docs.forEach((doc) {
        out.add(
          CallModel(
            intendedParticipants: (doc['intendedParticipants'] as List<dynamic>).cast<String>(),
            participants: (doc['participants'] as List<dynamic>).cast<String>(),
            startTime: DateTime.parse(doc['startTime']),
            endTime: DateTime.parse(doc['endTime']),
            handlesUID: doc['handlesUID']
          )
        );
      });
      return out;
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
      firestore
      .collection('call_logs')
      .doc()
      .set({
        'intendedParticipants': value["intendedParticipants"],
        'participants': value["participants"],
        'startTime': value["startTime"],
        'endTime': endTime.toString(),
        'handlesUID': handlesUID
      }).then((value){
        firestore
        .collection('call_channels')
        .doc(handlesUID)
        .delete();
      });
    });
  }
}