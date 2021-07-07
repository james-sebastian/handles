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
              "role": user.role,
              "company": user.company,
              "companyAddress": user.companyAddress,
              "companyLogo": user.companyLogo,
              "creditCard": user.creditCard,
              "handlesList": user.handlesList,
              "archivedHandlesList": user.archivedHandlesList
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
        // either this occurs or the user needs to manually enter the SMS code
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

  Future<void> updateUserPhoneCredential(String code, String pin) async {
    final AuthCredential credential = PhoneAuthProvider.credential(verificationId: code, smsCode: pin);
    await auth.currentUser!.updatePhoneNumber(credential as PhoneAuthCredential);
  }

  Future<void> deleteUserVerification(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (credential) async {

         //TODO: DELETE FIRESTORE RECORD && REMOVE UID FROM HANDLES

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

    //TODO: DELETE FIRESTORE RECORD && REMOVE UID FROM HANDLES

    final PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: code, smsCode: pin);
    await auth.currentUser!.reauthenticateWithCredential(credential);
    await auth.currentUser!.delete();
  }
}