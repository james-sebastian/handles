part of "../pages.dart";

class PhoneVerificationPage extends StatefulWidget {

  final String phoneNumber;
  const PhoneVerificationPage({ Key? key, required this.phoneNumber }) : super(key: key);

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {


  final TextEditingController _pinPutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, __){

        final _authenticationProvider = watch(authenticationProvider);
        final _verificationCode = watch(authenticationProvider).verificationCode;

        _authenticationProvider.verifyPhone(
          phoneNumber: widget.phoneNumber,
        );

        if(watch(authenticationProvider).isError){
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP')));
        }

        print(watch(authenticationProvider).isLoading);

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
                          _authenticationProvider.signInWithVerificationCode(_verificationCode, pin);
                        },
                      ),
                    ),
                    Spacer(flex: 2),
                    Button(
                      title: "VERIFY",
                      color: Palette.primary,
                      method: () async {
                        if(_pinPutController.text != ""){
                          _authenticationProvider.signInWithVerificationCode(_verificationCode, _pinPutController.text);
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
    );
  }
}