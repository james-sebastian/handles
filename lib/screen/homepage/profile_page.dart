part of "../pages.dart";

enum ImageTarget{profile, company}

class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isReadOnly = true;
  XFile? _profileImage;
  XFile? _companyLogo;
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() { 
    super.initState();

    nameController.text = "";
    jobController.text = "";
    companyController.text = "";
    addressController.text = "";
  }

  @override
  Widget build(BuildContext context,) {
    return Consumer(
      builder: (ctx, watch, _) {

        final _userProvider = watch(userProvider);

        _imgFromCamera(ImageTarget target) async {
          XFile? image = await ImagePicker().pickImage(
            source: ImageSource.camera, imageQuality: 50
          );
          setState(() {
            if(target == ImageTarget.profile){
              _profileImage = image;
              _userProvider.updateUserProfilePicture(image!.path);
            } else {
              _companyLogo = image;
              _userProvider.updateCompanyLogo(image!.path);
            }
          });
        }

        _imgFromGallery(ImageTarget target) async {
          XFile? image = await ImagePicker().pickImage(
              source: ImageSource.gallery, imageQuality: 50
          );
          setState(() {
            if(target == ImageTarget.profile){
              _profileImage = image;
              _userProvider.updateUserProfilePicture(image!.path);
            } else {
              _companyLogo = image;
              _userProvider.updateCompanyLogo(image!.path);
            }
          });
        }

        void _showPicker(context, ImageTarget target) {
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
                            _imgFromGallery(target);
                            Navigator.of(context).pop();
                          }),
                        new ListTile(
                          leading: new Icon(Icons.photo_camera),
                          title: new Text('Camera'),
                          onTap: () {
                            _imgFromCamera(target);
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
                      _imgFromGallery(target);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Pick from Gallery'),
                    onPressed: () {
                      _imgFromCamera(target);
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          }

        return StreamBuilder<UserModel>(
          stream: _userProvider.getCurrentUser,
          builder: (context, snapshot){

            if(snapshot.hasData){
              nameController.text = snapshot.data!.name;
              jobController.text = snapshot.data!.role ?? "";
              companyController.text = snapshot.data!.company ?? "";
              addressController.text = snapshot.data!.companyAddress ?? "";
            }

            return snapshot.hasData
            ? Scaffold(
                appBar: AppBar(
                  toolbarHeight: MQuery.height(0.07, context),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: AdaptiveIcon(
                      android: Icons.arrow_back,
                      iOS: CupertinoIcons.back,
                      color: Colors.black
                    ),
                    onPressed: (){
                      Get.back();
                    },
                  ),
                  actions: [
                    isReadOnly == false
                    ? FadeInRight(
                        child: Center(
                          child: Text(
                            "Editing Profile",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Palette.primary
                            )
                          ),
                        ),
                      )
                    : SizedBox(),
                    IconButton(
                      icon: AdaptiveIcon(
                        android: Icons.edit,
                        iOS: CupertinoIcons.pencil,
                        color: Palette.primary
                      ),
                      onPressed: (){
                        setState(() {
                          isReadOnly = !isReadOnly;
                        });
                      },
                    ),
                  ]
                ),
                body: SingleChildScrollView(
                  child: Container(
                    height: MQuery.height(0.875, context),
                    padding: EdgeInsets.symmetric(
                      vertical: MQuery.height(0.015, context)
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            _showPicker(context, ImageTarget.profile);
                          },
                          child: CircleAvatar(
                            backgroundColor: Palette.primary,
                            radius: MQuery.height(0.04, context),
                            backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path)) 
                            : snapshot.data!.profilePicture != null
                              ? NetworkImage(snapshot.data!.profilePicture ?? "") as ImageProvider
                              : AssetImage("assets/sample_profile.png")
                          ),
                        ),
                        SizedBox(height: MQuery.height(0.015, context)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                            SizedBox(width: MQuery.width(0.01, context)),
                            Font.out(
                              "valid until July 31st, 2021",
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              textAlign: TextAlign.start
                            ),
                          ]
                        ),
                        SizedBox(height: MQuery.height(0.02, context)),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: -10,
                          leading: AdaptiveIcon(
                            android: Icons.person,
                            iOS: CupertinoIcons.person_fill,
                            color: Palette.primary
                          ),
                          title: TextFormField(
                            autofocus: true,
                            readOnly: isReadOnly,
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            cursorColor: Palette.primary,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.4)
                              ),
                              hintText: "Enter your username here...",
                              contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              border: InputBorder.none
                            ),
                            onEditingComplete: (){
                              _userProvider.updateDisplayName(nameController.text);
                            },
                          ),
                        ),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: -10,
                          leading: SvgPicture.asset("assets/medal.svg"),
                          title: TextFormField(
                            readOnly: isReadOnly,
                            keyboardType: TextInputType.name,
                            controller: jobController,
                            cursorColor: Palette.primary,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.4)
                              ),
                              hintText: "Enter your job description here...",
                              contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              border: InputBorder.none
                            ),
                            onEditingComplete: (){
                              _userProvider.updateRole(jobController.text);
                            }
                          ),
                        ),
                        Divider(height: 0),
                        SizedBox(height: MQuery.height(0.02, context)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MQuery.width(0.02, context)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Font.out(
                                "Company Information",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MQuery.height(0.025, context)),
                        GestureDetector(
                          onTap: (){
                            _showPicker(context, ImageTarget.company);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey
                              ),
                              shape: BoxShape.circle
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              radius: MQuery.height(0.0275, context),
                              backgroundImage: _companyLogo != null
                              ? FileImage(File(_companyLogo!.path))
                              : snapshot.data!.companyLogo != ""
                                ? NetworkImage(snapshot.data!.companyLogo ?? "") as ImageProvider
                                : AssetImage("assets/handles_logo.png")
                            ),
                          ),
                        ),
                        SizedBox(height: MQuery.height(0.025, context)),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: -10,
                          leading: SvgPicture.asset("assets/company.svg"),
                          title: TextFormField(
                            readOnly: isReadOnly,
                            keyboardType: TextInputType.name,
                            controller: companyController,
                            cursorColor: Palette.primary,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.4)
                              ),
                              hintText: "Enter your company name here...",
                              contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              border: InputBorder.none
                            ),
                            onEditingComplete: (){
                              _userProvider.updateCompany(companyController.text);
                            }
                          ),
                        ),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: -10,
                          leading: SvgPicture.asset("assets/company_address.svg"),
                          title: Padding(
                            padding: EdgeInsets.only(
                              top: 5.0
                            ),
                            child: TextFormField(
                              maxLines: 6,
                              readOnly: isReadOnly,
                              keyboardType: TextInputType.name,
                              controller: addressController,
                              cursorColor: Palette.primary,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.4)
                                ),
                                hintText: "Enter your company address here...",
                                contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                border: InputBorder.none
                              ),
                              onEditingComplete: (){
                                _userProvider.updateCompanyAddress(addressController.text);
                              }
                            ),
                          ),
                        ),
                      ],
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