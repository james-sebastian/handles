part of "../pages.dart";

class HandlesCreatorPage extends StatefulWidget {
  const HandlesCreatorPage({ Key? key }) : super(key: key);

  @override
  _HandlesCreatorPageState createState() => _HandlesCreatorPageState();
}

class _HandlesCreatorPageState extends State<HandlesCreatorPage> {

  FormError errorLocation = FormError.none;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Set<String> membersList = Set();
  PickedFile? _image;

  @override
  Widget build(BuildContext context) {

    void addMember(String phoneNumber){
      setState(() {
        membersList.add(phoneNumber);
      });
    }

    print(membersList);

    _imgFromCamera() async {
      PickedFile? image = await ImagePicker().getImage(
        source: ImageSource.camera, imageQuality: 50
      );
      setState(() {
        _image = image;
      });
    }

    _imgFromGallery() async {
      PickedFile? image = await ImagePicker().getImage(
          source: ImageSource.gallery, imageQuality: 50
      );
      setState(() {
        _image = image;
      });
    }

    void _showPicker(context) {
      Platform.isAndroid
      ? showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        )
      : showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('Pick from Camera'),
                onPressed: () {
                  _imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Pick from Gallery'),
                onPressed: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.primary,
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
          "Create a Handles",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                _showPicker(context);
              },
              child: Container(
                height: MQuery.height(0.2, context),
                width: MQuery.width(1, context),
                color: Colors.grey,
                child: _image == null
                ? Center(
                    child: AdaptiveIcon(
                      android: Icons.camera_alt,
                      iOS: CupertinoIcons.camera_fill,
                      color: Colors.white, size: 36
                    ),
                  )
                : Image(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover
                )
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: MQuery.height(0.03, context),
                horizontal: MQuery.width(0.025, context)
              ),
              height: MQuery.height(0.9, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0
                    ),
                    child: Font.out(
                      "Handles's title",
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: MQuery.height(0.01, context)),
                  Container(
                    height: MQuery.height(0.06, context),
                    width: MQuery.width(0.9, context),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: errorLocation == FormError.title ? Palette.warning : Colors.transparent
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Palette.formColor,
                    ),
                    child: Center(
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: titleController,
                        cursorColor: Palette.primary,
                        style: TextStyle(
                          fontSize: 16
                        ),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: errorLocation == FormError.title ? Palette.warning : Colors.black.withOpacity(0.4)
                          ),
                          hintText: "Enter the project's title...",
                          contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          border: InputBorder.none
                        ),
                      ),
                    )
                  ),
                  SizedBox(height: MQuery.height(0.02, context)),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0
                    ),
                    child: Font.out(
                      "Handles' description (optional)",
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: MQuery.height(0.01, context)),
                  Container(
                    height: MQuery.height(0.15, context),
                    width: MQuery.width(0.9, context),
                    padding: EdgeInsets.only(
                      top: MQuery.height(0.005, context)
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: errorLocation == FormError.description ? Palette.warning : Colors.transparent
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Palette.formColor,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: descriptionController,
                      cursorColor: Palette.primary,
                      minLines: 3,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 16
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: errorLocation == FormError.description ? Palette.warning : Colors.black.withOpacity(0.4)
                        ),
                        hintText: "Enter project's description (optional)",
                        contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        border: InputBorder.none
                      ),
                    )
                  ),
                  SizedBox(height: MQuery.height(0.02, context)),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Font.out(
                        "Invite members:",
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              Get.to(() => ContactPicker(), transition: Transition.cupertino);
                            },
                            icon: AdaptiveIcon(
                              android: Icons.contact_page,
                              iOS: CupertinoIcons.person_2_square_stack_fill,
                              color: Palette.primaryText,
                              size: 24
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              Get.dialog(AddMemberViaNumberDialog(addMember: addMember));
                            },
                            icon: AdaptiveIcon(
                              android: Icons.add,
                              iOS: CupertinoIcons.add,
                              color: Palette.primaryText,
                              size: 24
                            ),
                          )
                        ]
                      )
                    ],
                  ),
                  SizedBox(height: MQuery.height(0.02, context)),
                  Container(
                    height: MQuery.height(0.3, context),
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Palette.primary,
                              radius: MQuery.height(0.025, context),
                            ),
                            title: Font.out(
                              "Person " + index.toString(),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.start
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: MQuery.height(0.05, context)),
                  Button(
                    width: double.infinity,
                    title: "Send Meeting Message",
                    textColor: Colors.white,
                    color: Palette.primary,
                    method: (){
                      if(titleController.text == ""){
                        setState(() {
                          errorLocation = FormError.title;
                        });
                      }
                    }
                  )
                ]
              )
            ),
          ],
        )
      )
    );
  }
}

class AddMemberViaNumberDialog extends StatefulWidget {
  
  final void Function(String) addMember;
  const AddMemberViaNumberDialog({ Key? key, required this.addMember }) : super(key: key);

  @override
  _AddMemberViaNumberDialogState createState() => _AddMemberViaNumberDialogState();
}

class _AddMemberViaNumberDialogState extends State<AddMemberViaNumberDialog> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  "Add Member",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Palette.primaryText,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: MQuery.height(0.02, context)),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: MQuery.height(0.065, context),
                          margin: const EdgeInsets.only(left: 8.0, right: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Palette.formColor,
                          ),
                          child: Center(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: countryCodeController,
                              cursorColor: Palette.primary,
                              style: TextStyle(
                                fontSize: 18
                              ),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: isError ? Palette.warning : Colors.black.withOpacity(0.4)
                                ),
                                hintText: "+61",
                                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                border: InputBorder.none
                              ),
                              onEditingComplete: (){
                                phoneNumberController.text = "+" + phoneNumberController.text;
                              },
                            ),
                          ),
                        )
                      ),
                      SizedBox(width: MQuery.width(0.02, context)),
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: MQuery.height(0.065, context),
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
                              controller: phoneNumberController,
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
                                phoneNumberController.text.replaceAll("0", "");
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
                ),
                SizedBox(height: MQuery.height(0.02, context)),
                Button(
                  title: "Add Member",
                  textColor: Colors.white,
                  method: (){
                    if(phoneNumberController.text != "" && countryCodeController.text != ""){
                      widget.addMember(countryCodeController.text + " " + phoneNumberController.text);
                      Get.back();
                    } else {
                      setState(() {
                        isError = true;
                      });
                    }
                  },
                  color: Palette.primary
                )
              ]
            )
          )
        )
      )
    );
  }
}