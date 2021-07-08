part of "services.dart";

class UserServices with ChangeNotifier{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  bool isLoading = false;

  UserServices({required this.auth, required this.firestore, required this.storage});

  Stream<UserModel> getCurrentUser(){
    return firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .snapshots()
      .map((user){
        return UserModel(
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
  }

  Future<void> updateDisplayName(String name) async{
    await auth.currentUser!.updateDisplayName(name);
  }

  Future<void> updateRole(String role) async{
    await firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .update({
      "role": role
    });
  }

  Future<void> updateCompany(String companyName) async{
    await firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .update({
      "company": companyName
    });
  }

  Future<void> updateCompanyAddress(String companyAddress) async{
    await firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .update({
      "companyAddress": companyAddress
    });
  }

  Future<void> updateCreditCard(String creditCard) async{
    await firestore
    .collection('users')
    .doc(auth.currentUser!.uid)
    .update({
      "creditCard": creditCard
    });
  }

  Future<void> updateUserProfilePicture(String filePath) async {
    File file = File(filePath);
    try {
      await storage
      .ref('user_profile/${auth.currentUser!.uid}.png')
      .putFile(file);

      String downloadURL = await storage
        .ref('user_profile/${auth.currentUser!.uid}.png')
        .getDownloadURL();

      await auth.currentUser!.updatePhotoURL(downloadURL);

    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateCompanyLogo(String filePath) async {
    File file = File(filePath);
    try {
      await storage
      .ref('user_company_logo/${auth.currentUser!.uid}.png')
      .putFile(file);

      String _downloadURL = await storage
        .ref('user_company_logo/${auth.currentUser!.uid}.png')
        .getDownloadURL();

      await firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .update({
        "companyLogo": _downloadURL
      });

    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Future<void> setNotificationMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notificationMode", value);
  }

  Future<bool> getNotificationMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("notificationMode") ?? true;
  }

  Future<void> setFontSize(FontSize value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value == FontSize.small){
      prefs.setString("fontSizeMode", "small");
    } else if (value == FontSize.medium){
      prefs.setString("notificationMode", "medium");
    } else {
      prefs.setString("notificationMode", "big");
    }
  }

  Future<String> getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("fontSizeMode") ?? "";
  }
}