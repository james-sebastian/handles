part of "services.dart";

class HandlesServices with ChangeNotifier{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  bool isLoading = false;
  HandlesServices({required this.auth, required this.firestore, required this.storage});

  Future<UserModel?> addMember(String phoneNumber) async {
    UserModel? userModelOutput;
    try{
      await firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get()
        .then((value){
          var user = value.docs.first;
          userModelOutput = UserModel(
            id: user.id,
            countryCode: user["countryCode"],
            name: user["name"],
            profilePicture: user["profilePicture"],
            phoneNumber: user["phoneNumber"],
            role: user["role"],
            company: user["company"],
            companyAddress: user["companyAddress"],
            companyLogo: user["companyLogo"],
            creditCard: user["creditCard"],
            handlesList: (user["handlesList"] as List<dynamic>).cast<String>(),
            archivedHandlesList:(user["archivedHandlesList"] as List<dynamic>).cast<String>()
          );
        }
      );
    } catch (e){
      print(e);
      notifyListeners();
    }

    return userModelOutput;
  }

  Future<void> createHandles(HandlesModel handlesModel) async {
    await firestore
      .collection('handles')
      .doc(handlesModel.id)
      .set({
        "name": handlesModel.name,
        "description": handlesModel.description,
        "cover": handlesModel.cover,
        "members": handlesModel.members,
        "pinnedBy": handlesModel.pinnedBy
      }
    ).then((value){
      handlesModel.members.forEach((element) {
        firestore
          .collection('users')
          .doc(element)
          .get().then((value){

            List<dynamic> oldHandlesList = (value["handlesList"] as List<dynamic>);
            oldHandlesList.add(handlesModel.id);

            firestore.collection('users')
            .doc(element)
            .update({
              "handlesList": oldHandlesList
            });
        });
      });
    });
  }

  Future<String?> uploadHandlesCover(String filePath, String handlesName) async {

    String? outputURL;
    File file = File(filePath);
    try {
      await storage
      .ref('handles_cover/$handlesName.png')
      .putFile(file);

      String downloadURL = await FirebaseStorage.instance
        .ref('handles_cover/$handlesName.png')
        .getDownloadURL();

      outputURL = downloadURL;
    } on FirebaseException catch (e) {
      print(e.toString());
    }

    return outputURL;
  }

  Future<void> pinHandles(String handlesID, List<String> newPinnedList){
    return firestore
      .collection("handles")
      .doc(handlesID)
      .update({
        "pinnedBy": newPinnedList
      });
  }

  Stream<HandlesModel> handlesModelGetter(String handlesID){
    return firestore
      .collection("handles")
      .doc(handlesID)
      .snapshots()
      .map(_eventModelListMapper);
  }

 HandlesModel _eventModelListMapper(DocumentSnapshot snapshot){
    HandlesModel out = HandlesModel(
      id: snapshot.id,
      description: snapshot['description'],
      members: (snapshot['members'] as List<dynamic>).cast<String>(),
      name: snapshot['name'],
      cover: snapshot['cover'],
      pinnedBy: (snapshot['pinnedBy'] as List<dynamic>).cast<String>()
    );
    return out;
  }
}