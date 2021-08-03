part of "services.dart";

class AuthenticationService with ChangeNotifier{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  String verificationCode;
  String profilePictureDownloadURL;
  bool isError;
  bool isLoading;

  AuthenticationService({
    required this.auth,
    required this.firestore,
    required this.storage,
    this.verificationCode = "",
    this.isError = false,
    this.isLoading = false,
    this.profilePictureDownloadURL = ""
  });

  Future<void > verifyPhone({ required String phoneNumber }) async {

    isLoading = true;
    notifyListeners();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
            if (value.user != null) {
              Get.offAll(() => AccountCreationPage(), transition: Transition.cupertino);
            }
          }
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationID, int? resendToken) {
        verificationCode = verificationID;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        verificationCode = verificationID;
        notifyListeners();
      },
      timeout: Duration(seconds: 120)
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithVerificationCode(String code, String pin) async {

    isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(verificationId: code, smsCode: pin))
        .then((value) async {
        if (value.user != null) {
          Get.offAll(() => AccountCreationPage(), transition: Transition.cupertino);
        }
      });
    } catch (e) {
      isError = true;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> createUserRecord(UserModel user) async{

    await auth.currentUser!.updateDisplayName(user.name);
    await auth.currentUser!.updatePhotoURL(user.profilePicture);

    try{
      await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get().then((value) async {
          if(!(value.exists)){
            await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .set({
              "id": user.id,
              "name": user.name,
              "countryCode": user.countryCode,
              "phoneNumber": user.phoneNumber,
              "profilePicture": user.profilePicture,
              "role": user.role,
              "company": user.company,
              "companyAddress": user.companyAddress,
              "companyLogo": user.companyLogo,
              "creditCard": user.creditCard,
              "handlesList": user.handlesList,
            });
          } else {
            await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .update({
              "name": user.name,
              "profilePicture": user.profilePicture,
            });
          }
        }
      );
    } catch (e){
      isError = true;
      notifyListeners();
      print(e);
    }

    if(!isError){
      Get.offAll(() => Homepage(), transition: Transition.cupertino);
    }
  }

  Future<void> uploadUserProfilePicture(String filePath) async {
    File file = File(filePath);
    try {
      await storage
      .ref('user_profile/${auth.currentUser!.uid}.png')
      .putFile(file);

      String downloadURL = await FirebaseStorage.instance
        .ref('user_profile/${FirebaseAuth.instance.currentUser!.uid}.png')
        .getDownloadURL()
        .whenComplete((){
          Get.offAll(() => Homepage(), transition: Transition.cupertino);
        });

      profilePictureDownloadURL = downloadURL;
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUserPhoneVerification(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (credential) async {
        await auth.currentUser!.updatePhoneNumber(credential);
        await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({
          "phoneNumber": phoneNumber,
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (verificationId, [forceResendingToken]) async {
        verificationCode = verificationId;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        verificationCode = verificationID;
        notifyListeners();
      },
    );
  }

  Future<void> updateUserPhoneCredential(String code, String pin, String phoneNumber) async {
    final AuthCredential credential = PhoneAuthProvider.credential(verificationId: code, smsCode: pin);
    await auth.currentUser!.updatePhoneNumber(credential as PhoneAuthCredential);
  }

  Future<void> deleteUserVerification(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (credential) async {

        firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get().then((value){
          List<String> handlesList = (value['handlesList'] as List<dynamic>).cast<String>();

          handlesList.forEach((handlesID) async {

            await firestore
            .collection('handles')
            .doc(handlesID)
            .get().then((handle){
              List<String> handleMemberList = (handle['members'] as List<dynamic>).cast<String>();
              handleMemberList.remove(auth.currentUser!.uid);
              firestore
              .collection('handles')
              .doc(handlesID)
              .update({
                "members": handleMemberList
              });
            });

            await firestore
            .collection('meet_chat')
            .where('attendees', arrayContains: auth.currentUser!.uid)
            .get().then((meetChats){
                meetChats.docs.forEach((meet) {
                  List<String> attendeesList = (meet['attendees'] as List<dynamic>).cast<String>();
                  attendeesList.remove(auth.currentUser!.uid);
                  firestore
                  .collection('meet_chat')
                  .doc(meet.id)
                  .update({
                    "attendees": attendeesList
                  });
                });
            });

            await firestore
            .collection('call_logs')
            .where('intendedParticipants', arrayContains: auth.currentUser!.uid)
            .get().then((callLogs){
                callLogs.docs.forEach((log) {
                  List<String> logIntParticipants = (log['intendedParticipants'] as List<dynamic>).cast<String>();
                  logIntParticipants.remove(auth.currentUser!.uid);
                  firestore
                  .collection('call_logs')
                  .doc(log.id)
                  .update({
                    "intendedParticipants": logIntParticipants
                  });
                });
            });

            await firestore
            .collection('call_logs')
            .where('participants', arrayContains: auth.currentUser!.uid)
            .get().then((callLogs){
                callLogs.docs.forEach((log) {
                  List<String> callLogsParticipants = (log['participants'] as List<dynamic>).cast<String>();
                  callLogsParticipants.remove(auth.currentUser!.uid);
                  firestore
                  .collection('call_logs')
                  .doc(log.id)
                  .update({
                    "participants": callLogsParticipants
                  });
                });
            });
          });
        });

        await auth.currentUser!.reauthenticateWithCredential(credential);
        await auth.currentUser!.delete();
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (verificationId, [forceResendingToken]) async {
        verificationCode = verificationId;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        verificationCode = verificationID;
        notifyListeners();
      },
    );
  }

  Future<void> deleteUserPhoneCredential(String code, String pin) async {
    firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .get().then((value){
      List<String> handlesList = (value['handlesList'] as List<dynamic>).cast<String>();

      handlesList.forEach((handlesID) async {

        await firestore
        .collection('handles')
        .doc(handlesID)
        .get().then((handle){
          List<String> handleMemberList = (handle['members'] as List<dynamic>).cast<String>();
          handleMemberList.remove(auth.currentUser!.uid);
          firestore
          .collection('handles')
          .doc(handlesID)
          .update({
            "members": handleMemberList
          });
        });

        await firestore
        .collection('meet_chat')
        .where('attendees', arrayContains: auth.currentUser!.uid)
        .get().then((meetChats){
            meetChats.docs.forEach((meet) {
              List<String> attendeesList = (meet['attendees'] as List<dynamic>).cast<String>();
              attendeesList.remove(auth.currentUser!.uid);
              firestore
              .collection('meet_chat')
              .doc(meet.id)
              .update({
                "attendees": attendeesList
              });
            });
        });

        await firestore
        .collection('call_logs')
        .where('intendedParticipants', arrayContains: auth.currentUser!.uid)
        .get().then((callLogs){
            callLogs.docs.forEach((log) {
              List<String> logIntParticipants = (log['intendedParticipants'] as List<dynamic>).cast<String>();
              logIntParticipants.remove(auth.currentUser!.uid);
              firestore
              .collection('call_logs')
              .doc(log.id)
              .update({
                "intendedParticipants": logIntParticipants
              });
            });
        });

        await firestore
        .collection('call_logs')
        .where('participants', arrayContains: auth.currentUser!.uid)
        .get().then((callLogs){
            callLogs.docs.forEach((log) {
              List<String> callLogsParticipants = (log['participants'] as List<dynamic>).cast<String>();
              callLogsParticipants.remove(auth.currentUser!.uid);
              firestore
              .collection('call_logs')
              .doc(log.id)
              .update({
                "participants": callLogsParticipants
              });
            });
        });
      });
    });

    final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: code, smsCode: pin);
    await auth.currentUser!.reauthenticateWithCredential(credential);
    await auth.currentUser!.delete();
  }
}