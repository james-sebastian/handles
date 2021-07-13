part of "../pages.dart";

enum FontSize { small, medium, big }

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool isNotificationActive = true;
  FontSize fontSize = FontSize.medium;
  TextEditingController paymentAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch, _) {

        final _userProvider = watch(userProvider);

        Future<void> getFontSize() async {
          await _userProvider.getFontSize().then((value){
            if(value == "small"){
              setState((){
                fontSize = FontSize.small;
              });
            } else if (value == "medium"){
              setState((){
                fontSize = FontSize.medium;
              });
            } else {
              setState((){
                fontSize = FontSize.big;
              });
            }
          });
        }

        Future<void> setNotification(bool value) async{
          setState((){
            isNotificationActive = value;
          });

          await _userProvider.setNotificationMode(value);
        }

        Future<void> getNotification() async {
          _userProvider.getNotificationMode().then((value){
            setState((){
              isNotificationActive = value;
            });
          });
        }
        
        return StreamBuilder<UserModel>(
          stream: _userProvider.getCurrentUser,
          builder: (context, snapshot){

            // print(snapshot);
            if(snapshot.hasData){
              paymentAddressController.text = snapshot.data!.creditCard ?? "";
            }

            getFontSize();
            getNotification();

            return snapshot.hasData
            ? Scaffold(
                appBar: AppBar(
                  toolbarHeight: MQuery.height(0.07, context),
                  leading: IconButton(
                    icon: AdaptiveIcon(
                      android: Icons.arrow_back,
                      iOS: CupertinoIcons.back,
                    ),
                    onPressed: (){
                      Get.back();
                    },
                  ),
                  title: Text(
                    "Settings",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    height: MQuery.height(0.875, context),
                    padding: EdgeInsets.symmetric(
                      vertical: MQuery.height(0.015, context)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            ListTile(   
                              leading: CircleAvatar(
                                backgroundColor: Palette.primary,
                                radius: MQuery.height(0.03, context),
                                backgroundImage: NetworkImage(snapshot.data!.profilePicture!),
                              ),
                              title: Font.out(
                                snapshot.data!.name,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start
                              ),
                              subtitle: Font.out(
                                snapshot.data!.role ?? "",
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                textAlign: TextAlign.start
                              ),
                              trailing: Container(
                                height: 27.5,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Palette.tertiary,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 2.5
                                  ),
                                  child: Font.out(
                                    "PRO",
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700
                                  ),
                                )
                              ),
                              onTap: (){
                                Get.to(() => ProfilePage(), transition: Transition.cupertino);
                              }
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(
                                top: MQuery.height(0.01, context),
                                bottom: MQuery.height(0.025, context)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey
                                        ),
                                        shape: BoxShape.circle
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey.withOpacity(0.1),
                                        radius: MQuery.height(0.025, context),
                                        backgroundImage: snapshot.data!.companyLogo != ""
                                          ? NetworkImage(snapshot.data!.companyLogo ?? "") as ImageProvider
                                          : AssetImage("assets/handles_logo.png")
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Font.out(
                                          "company:",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          textAlign: TextAlign.start
                                        ),
                                        Font.out(
                                          snapshot.data!.company ?? "Google Flutter Team",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.start
                                        ),
                                        Font.out(
                                          snapshot.data!.companyAddress ?? "1600 Amphitheatre Parkway Mountain View, CA 94043",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          textAlign: TextAlign.start
                                        ),
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ),
                            Divider(height: 0),
                            ListTile(
                              shape: Border.symmetric(
                                vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              leading: AdaptiveIcon(
                                android: Icons.smartphone,
                                iOS: CupertinoIcons.device_phone_portrait,
                                color: Palette.primary
                              ),
                              title: Text(
                                "Change phone number",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                              onTap: (){
                                Get.dialog(
                                  PhoneNumberUpdateDialog(
                                    isDeleting: false,
                                  ));
                              }
                            ),
                            Divider(height: 1,),
                            ListTile(
                              shape: Border.symmetric(
                                vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              leading: AdaptiveIcon(
                                android: Icons.credit_card,
                                iOS: CupertinoIcons.creditcard,
                                color: Palette.primary
                              ),
                              title: Text(
                                "Subscription",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                              onTap: (){Get.to(() => SubscriptionPage(), transition: Transition.cupertino);}
                            ),
                            Divider(height: 1,),
                            ListTile(
                              shape: Border.symmetric(
                                vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              leading: AdaptiveIcon(
                                android: Icons.notifications,
                                iOS: CupertinoIcons.bell,
                                color: Palette.primary
                              ),
                              title: Text(
                                "Notifications",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                              trailing: Switch(
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.grey.withOpacity(0.5),
                                value: isNotificationActive,
                                onChanged: (bool value){
                                  setNotification(value);
                                },
                              )
                            ),
                            Divider(height: 1,),
                            ListTile(
                              onTap: (){
                                Get.dialog(
                                  Dialog(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: MQuery.height(0.75, context)
                                      ),
                                      child: Container(
                                        width: MQuery.width(0.9, context),
                                        padding: EdgeInsets.all(MQuery.height(0.02, context)),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Your Payment Address",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Palette.primaryText,
                                                  fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              SizedBox(height: MQuery.height(0.02, context)),
                                              Container(
                                                padding: EdgeInsets.only(
                                                  bottom: MQuery.height(0.02, context)
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Palette.formColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                                ),
                                                child: TextFormField(
                                                  maxLength: 12,
                                                  readOnly: false,
                                                  keyboardType: TextInputType.number,
                                                  controller: paymentAddressController,
                                                  cursorColor: Palette.primary,
                                                  style: TextStyle(
                                                    fontSize: 16
                                                  ),
                                                  onEditingComplete: (){
                                                    _userProvider.updateCreditCard(paymentAddressController.text);
                                                    Get.back();
                                                  },
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    suffixIconConstraints: BoxConstraints(
                                                      minWidth: 2,
                                                      minHeight: 2,
                                                    ),
                                                    suffixIcon: IconButton(
                                                      onPressed: (){
                                                        // Clipboard.setData(ClipboardData(text: widget.meetingModel.meetingURL));
                                                      },
                                                      icon: AdaptiveIcon(
                                                        android: Icons.copy,
                                                        iOS: CupertinoIcons.doc_on_clipboard_fill,
                                                        color: Palette.primary,
                                                        size: 20
                                                      )
                                                    ),
                                                    fillColor: Palette.primary,
                                                    hintStyle: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black.withOpacity(0.4)
                                                    ),
                                                    hintText: "Credit card hasn't provided yet",
                                                    contentPadding: EdgeInsets.all(15),
                                                    border: InputBorder.none
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: MQuery.height(0.02, context)),
                                              Text(
                                                "Your payment address (Credit Card) is official and will be used for any form of transaction related to a Handles Group that you've created or currently admining",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Palette.primaryText,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ]
                                          )
                                        )
                                      )
                                    )
                                  )
                                );
                              },
                              shape: Border.symmetric(
                                vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              title: Text(
                                "Project payment address",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                            ),
                            Divider(height: 1,),
                            ListTile(
                              shape: Border.symmetric(
                                vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              leading: AdaptiveIcon(
                                android: Icons.delete,
                                iOS: CupertinoIcons.trash,
                                color: Palette.warning
                              ),
                              title: Text(
                                "Delete my account",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              "assets/handles_logo.png",
                              height: MQuery.height(0.05, context),
                              width: MQuery.height(0.05, context),
                            ),
                            SizedBox(height: 10),
                            Text("v.1.0")
                          ]
                        )
                      ]
                    )
                  )
                )
              )
            : Scaffold(
                body: Center(child: CircularProgressIndicator(color: Palette.primary))
              );
          }
        );
      },
    );
  }
}

class PhoneNumberUpdateDialog extends StatefulWidget {

  final bool isDeleting;
  const PhoneNumberUpdateDialog({ Key? key, required this.isDeleting}) : super(key: key);

  @override
  _PhoneNumberUpdateDialogState createState() => _PhoneNumberUpdateDialogState();
}

class _PhoneNumberUpdateDialogState extends State<PhoneNumberUpdateDialog> {

  String countryCode = '+61';
  bool isError = false;
  TextEditingController phoneInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: new Text(
        widget.isDeleting
        ? "Change your phone number"
        : "Delete your account?"
      ),
      children: <Widget>[
        new Container(
          height: MQuery.height(0.425, context),
          padding: EdgeInsets.all(
            MQuery.height(0.02, context)
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Font.out(
                  widget.isDeleting
                  ? "Deleting your account is an irreversible action that will erase all of your data and automatically leave all of your Handles. Please input your account number to proceed."
                  : "Handles will send a SMS message to verify\nyour phone number. Please enter your country code and your phone number as well.",
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Palette.primaryText,
                ),
                Container(
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
                Button(
                  title: "CONFIRM",
                  color: Palette.primary,
                  method: () async {
                    if(phoneInputController.text != ""){
                      if(widget.isDeleting){
                        Get.to(() => PhoneVerificationPage(
                          verificationStatus: PhoneVerificationType.deletion,
                          phoneNumber: countryCode + " " + phoneInputController.text.trim(),
                        ), transition: Transition.cupertino);
                      } else {
                        Get.to(() => PhoneVerificationPage(
                          verificationStatus: PhoneVerificationType.update,
                          phoneNumber: countryCode + " " + phoneInputController.text.trim(),
                        ), transition: Transition.cupertino);
                      }
                    } else {
                      setState(() {
                        isError = true;
                      });
                    }
                  },
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}