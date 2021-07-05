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

    print(user.name);

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
              "name": user.name,
              "phoneNumber": user.phoneNumber,
              "countryCode": user.countryCode
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
}