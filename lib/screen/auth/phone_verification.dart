part of "../pages.dart";

class PhoneVerificationPage extends StatefulWidget {

  final String phoneNumber;
  const PhoneVerificationPage({ Key? key, required this.phoneNumber }) : super(key: key);

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {

  String _verificationCode = "";
  final TextEditingController _pinPutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: widget.phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        if (value.user != null) {
          Get.offAll(() => AccountCreationPage(), transition: Transition.cupertino);
        }
      });
    },
    verificationFailed: (FirebaseAuthException e) {
      print(e.message);
    },
    codeSent: (String verficationID, int? resendToken) {
      setState(() {
        _verificationCode = verficationID;
      });
    },
    codeAutoRetrievalTimeout: (String verificationID) {
      setState(() {
        _verificationCode = verificationID;
      });
    },
    timeout: Duration(seconds: 120));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            left: MQuery.width(0.02, context),
            right: MQuery.width(0.02, context)
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Column(
                  children: [
                    Font.out(
                      "Phone Number Verification",
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Palette.secondaryText
                    ),
                    SizedBox(height: MQuery.height(0.01, context)),
                    Font.out(
                      "We have sent an OTP code to ${widget.phoneNumber}. Please check and input the OTP code in the form below.",
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Palette.primaryText,
                    ),
                  ],
                ),
                Spacer(flex: 1),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    MQuery.width(0.01, context),
                    0,
                    MQuery.width(0.01, context),
                    0
                  ),
                  child: PinPut(
                    controller: _pinPutController,
                    eachFieldWidth: MQuery.width(0.05, context),
                    eachFieldHeight: MQuery.height(0.06, context),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    selectedFieldDecoration: BoxDecoration(
                      border: Border.all(color: Palette.primary),
                      color: Palette.formColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    followingFieldDecoration: BoxDecoration(
                      color: Palette.formColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    submittedFieldDecoration: BoxDecoration(
                      border: Border.all(color: Palette.secondary),
                      color: Palette.formColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fieldsCount: 6,
                    onSubmit: (pin) async {
                      try {
                        await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                          if (value.user != null) {
                            Get.offAll(() => AccountCreationPage(), transition: Transition.cupertino);
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP')));
                      }
                    },
                  ),
                ),
                Spacer(flex: 2),
                Button(
                  title: "VERIFY",
                  color: Palette.primary,
                  method: () async {
                    if(_pinPutController.text != ""){
                      try {
                        await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: _pinPutController.text))
                          .then((value) async {
                          if (value.user != null) {
                            Get.offAll(() => AccountCreationPage(), transition: Transition.cupertino);
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP')));
                      }
                    }
                  },
                  textColor: Colors.white,
                ),
                Spacer()
              ],
            ),
          ),
        )
      ),
    );
  }
}