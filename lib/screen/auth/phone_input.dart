part of '../pages.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({ Key? key }) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {

  String countryCode = '+61';
  bool isError = false;
  TextEditingController phoneInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            left: MQuery.width(0.015, context),
            right: MQuery.width(0.015, context)
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
                      "Handles will send a SMS message to verify\nyour phone number. Please enter your country\ncode and your phone number as well.",
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Palette.primaryText,
                    ),
                  ],
                ),
                Spacer(flex: 1),
                Container(
                  padding: EdgeInsets.only(
                    left: MQuery.width(0.03, context),
                    right: MQuery.width(0.03, context)
                  ),
                  child: Column(
                    children: [
                      CountryListPick(
                        appBar: AppBar(
                          backgroundColor: Colors.blue,
                          title: Text('Choose your country code'),
                        ),
                        
                        pickerBuilder: (context, CountryCode? code){
                          return Container(
                            height: MQuery.height(0.075, context),
                            width: MQuery.width(0.9, context),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Palette.formColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: MQuery.height(0.02, context),
                                      width: MQuery.width(0.0325, context),
                                      child: Image.asset(
                                        code!.flagUri ?? "",
                                        fit: BoxFit.fitHeight,
                                        package: 'country_list_pick',
                                      ),
                                    ),
                                    SizedBox(width: MQuery.width(0.02, context)),
                                    Font.out(
                                      code.name ?? ""
                                    ),
                                  ],
                                ),
                                Icon(CupertinoIcons.chevron_down, color: Palette.primaryText)
                              ],
                            )
                          );
                        },

                        theme: CountryTheme(
                          isShowFlag: true,
                          isShowTitle: true,
                          isShowCode: true,
                          isDownIcon: true,
                          showEnglishName: true,
                        ),
                        // Set default value
                        initialSelection: '+61',
                        // or
                        // initialSelection: 'US'
                        onChanged: (CountryCode? code) {
                          setState(() {
                            countryCode = code!.dialCode ?? "";
                          });
                        },
                        useUiOverlay: true,
                        useSafeArea: false
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: MQuery.height(0.075, context),
                              width: MQuery.width(0.9, context),
                              margin: const EdgeInsets.only(left: 8.0, right: 0.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Palette.formColor,
                              ),
                              child: Center(
                                child: Font.out(
                                  countryCode
                                ),
                              ),
                            )
                          ),
                          SizedBox(width: MQuery.width(0.0125, context)),
                          Expanded(
                            flex: 8,
                            child: Container(
                              height: MQuery.height(0.075, context),
                              width: MQuery.width(0.9, context),
                              margin: const EdgeInsets.only(left: 0.0, right: 7.5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isError ? Palette.warning : Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Palette.formColor,
                              ),
                              child: Center(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp("^0+"), replacementString: "")
                                  ],
                                  keyboardType: TextInputType.phone,
                                  controller: phoneInputController,
                                  cursorColor: Palette.primary,
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: isError ? Palette.warning : Colors.black.withOpacity(0.4)
                                    ),
                                    hintText: "Ex: 2 3456 7890",
                                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    border: InputBorder.none
                                  ),
                                  onEditingComplete: (){
                                    phoneInputController.text.replaceAll("0", "");
                                  },
                                  onFieldSubmitted: (value){
                                    value.replaceAll("0", "");
                                  },
                                ),
                              )
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                if (isError)
                Column(
                  children: [
                    SizedBox(height: MQuery.height(0.02, context)),
                    Font.out(
                      "Please provide your phone number firstly.",
                      fontSize: 14,
                      color: Palette.warning
                    ),
                  ],
                ) else
                SizedBox(),
                Spacer(flex: 2),
                Button(
                  title: "NEXT",
                  color: Palette.primary,
                  method: () async {
                    if(phoneInputController.text != ""){
                      Get.to(() => PhoneVerificationPage(
                        phoneNumber: countryCode + " " + phoneInputController.text.trim(),
                      ), transition: Transition.cupertino);
                    } else {
                      setState(() {
                        isError = true;
                      });
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