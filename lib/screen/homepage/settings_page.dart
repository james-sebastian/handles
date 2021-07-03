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

    void fontModifier (FontSize? value){
      setState((){
        fontSize = value!;
      });
    }

    return Scaffold(
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
                    ),
                    title: Font.out(
                      "Clark Kent",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.start
                    ),
                    subtitle: Font.out(
                      "UI/UX Designer and Flutter Developer",
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
                                "Google Flutter Team",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start
                              ),
                              Font.out(
                                "1600 Amphitheatre Parkway Mountain View, CA 94043",
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
                    onTap: (){
                      Get.dialog(
                        FontDialog(
                          fontSize: fontSize,
                          fontModifier: fontModifier
                        )
                      );
                    },
                    shape: Border.symmetric(
                      vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                    ),
                    leading: AdaptiveIcon(
                      android: Icons.text_fields,
                      iOS: CupertinoIcons.textformat_size,
                      color: Palette.primary
                    ),
                    title: Text(
                      "Font size " + "${
                        fontSize == FontSize.small
                        ? "(Small)"
                        : fontSize == FontSize.medium
                          ? "(Medium)"
                          : "(Big)"
                      }",
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
                      onChanged: (bool val){

                        //TODO: NOTIFICATION TOGGLE

                        setState(() {
                          isNotificationActive = !isNotificationActive;
                        });
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
    );
  }
}

class FontDialog extends StatefulWidget {

  final FontSize fontSize;
  final void Function(FontSize) fontModifier;

  const FontDialog({ Key? key, required this.fontSize, required this.fontModifier }) : super(key: key);

  @override
  _FontDialogState createState() => _FontDialogState();
}

class _FontDialogState extends State<FontDialog> {

  late FontSize _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.fontSize;
  }


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: new Text("New Dialog"),
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              RadioListTile<FontSize>(
                title: const Text('Small'),
                value: FontSize.small,
                groupValue: widget.fontSize,
                onChanged: (FontSize? value) {
                  setState(() {
                    _fontSize = value!;
                  });
                  widget.fontModifier(value!);
                  Get.back();
                },
              ),
              RadioListTile<FontSize>(
                title: const Text('Medium'),
                value: FontSize.medium,
                groupValue: widget.fontSize,
                onChanged: (FontSize? value) {
                  setState(() {
                    _fontSize = value!;
                  });
                  widget.fontModifier(value!);
                  Get.back();
                },
              ),
              RadioListTile<FontSize>(
                title: const Text('Big'),
                value: FontSize.big,
                groupValue: widget.fontSize,
                onChanged: (FontSize? value) {
                  setState(() {
                    _fontSize = value!;
                  });
                  widget.fontModifier(value!);
                  Get.back();
                },
              ),
            ],
          )
        ),
      ],
    );
  }
}