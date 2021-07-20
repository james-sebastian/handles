part of "../pages.dart";

class CollaboratorProfilePage extends StatefulWidget {

  final String userID;
  const CollaboratorProfilePage({ Key? key, required this.userID }) : super(key: key);

  @override
  _CollaboratorProfilePageState createState() => _CollaboratorProfilePageState();
}

class _CollaboratorProfilePageState extends State<CollaboratorProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch, _) {

        final _userProvider = watch(userProvider);

        return FutureBuilder<UserModel>(
          future: _userProvider.getUserByID(widget.userID),
          builder: (context, snapshot){
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
                ),
                body: SingleChildScrollView(
                  child: Container(
                    height: MQuery.height(0.875, context),
                    padding: EdgeInsets.symmetric(
                      vertical: MQuery.height(0.015, context)
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Palette.primary,
                          radius: MQuery.height(0.04, context),
                          backgroundImage: snapshot.data!.profilePicture != null
                          ? NetworkImage(snapshot.data!.profilePicture ?? "") as ImageProvider
                          : AssetImage("assets/sample_profile.png")
                        ),
                        SizedBox(height: MQuery.height(0.02, context)),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: 0,
                          leading: AdaptiveIcon(
                            android: Icons.person,
                            iOS: CupertinoIcons.person_fill,
                            color: Palette.primary
                          ),
                          title: Text(
                            snapshot.data!.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          )
                        ),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: 0,
                          leading: AdaptiveIcon(
                            android: Icons.phone,
                            iOS: CupertinoIcons.phone_fill,
                            color: Palette.primary
                          ),
                          title: Text(
                            snapshot.data!.phoneNumber,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: (){
                              Clipboard.setData(ClipboardData(text: snapshot.data!.phoneNumber));
                              Fluttertoast.showToast(
                                msg: "Phone number copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                            },
                            icon: AdaptiveIcon(
                              android: Icons.copy,
                              iOS: CupertinoIcons.doc_on_clipboard_fill,
                              color: Palette.primary,
                              size: 20
                            )
                          ),
                        ),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: 0,
                          leading: SvgPicture.asset("assets/medal.svg"),
                          title: Text(
                            snapshot.data!.role == null || snapshot.data!.role == ""
                            ? "No user's occupancy added yet"
                            : snapshot.data!.role!,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: snapshot.data!.role == null || snapshot.data!.role == ""
                              ? Colors.black.withOpacity(0.5)
                              : Colors.black
                            ),
                          )
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
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey
                            ),
                            shape: BoxShape.circle
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            radius: MQuery.height(0.0275, context),
                            backgroundImage: snapshot.data!.companyLogo != ""
                            ? NetworkImage(snapshot.data!.companyLogo ?? "") as ImageProvider
                            : AssetImage("assets/handles_logo.png")
                        ),
                        ),
                        SizedBox(height: MQuery.height(0.025, context)),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: 0,
                          leading: SvgPicture.asset("assets/company.svg"),
                          title: Text(
                            snapshot.data!.company == null || snapshot.data!.company == ""
                            ? "No company added yet"
                            : snapshot.data!.company!,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: snapshot.data!.company == null || snapshot.data!.company == ""
                              ? Colors.black.withOpacity(0.5)
                              : Colors.black
                            ),
                          )
                        ),
                        Divider(height: 0),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          horizontalTitleGap: 0,
                          leading: SvgPicture.asset("assets/company_address.svg"),
                          title: Padding(
                            padding: EdgeInsets.only(
                              top: 5.0
                            ),
                            child: Text(
                              snapshot.data!.companyAddress == null || snapshot.data!.companyAddress == ""
                              ? "No company address added yet"
                              : snapshot.data!.companyAddress!,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: snapshot.data!.companyAddress == null || snapshot.data!.companyAddress == ""
                                ? Colors.black.withOpacity(0.5)
                                : Colors.black
                              ),
                            )
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