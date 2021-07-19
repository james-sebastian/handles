part of "../pages.dart";

class HandlesDetailedPage extends StatefulWidget {

  final String handlesID;
  final String currentUserID;
  const HandlesDetailedPage({ Key? key, required this.handlesID, required this.currentUserID }) : super(key: key);

  @override
  _HandlesDetailedPageState createState() => _HandlesDetailedPageState();
}

class _HandlesDetailedPageState extends State<HandlesDetailedPage> {

  bool isReadOnly = true;
  bool isNotificationActive = true;
  TextEditingController paymentAddressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    paymentAddressController.text = "123456789123";
    descriptionController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch,child) {
        
        final _singleHandlesProvider = watch(singleHandlesProvider(widget.handlesID));
        final _handlesProvider = watch(handlesProvider);
        final _chatProvider = watch(chatProvider);
        final _userProvider = watch(userProvider);
        
        return _singleHandlesProvider.when(
          data: (handles){

            descriptionController.text = handles.description;

            return Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 250.0,
                    leadingWidth: MQuery.width(0.05, context),
                    leading: IconButton(
                      icon: AdaptiveIcon(
                        android: Icons.arrow_back,
                        iOS: CupertinoIcons.back,
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
                              "Editing Handle",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white
                              )
                            ),
                          ),
                        )
                      : SizedBox(),
                      SizedBox(width: MQuery.width(0.01, context)),
                      handles.members.keys.toList().indexOf(widget.currentUserID) >= 0
                      ? handles.members[widget.currentUserID] == "Admin"
                        ? Row(
                            children: [
                              IconButton(
                                icon: AdaptiveIcon(
                                  android: Icons.edit,
                                  iOS: CupertinoIcons.pencil,
                                ),
                                onPressed: (){
                                  setState(() {
                                    isReadOnly = !isReadOnly;
                                  });
                                }
                              ),
                              IconButton(
                                icon: AdaptiveIcon(
                                  android: Icons.delete,
                                  iOS: CupertinoIcons.trash,
                                ),
                                onPressed: (){
                                  Get.dialog(
                                    Platform.isAndroid
                                    ? AlertDialog(
                                        title: Text(
                                          "Are you sure you want to delete ${handles.name}?",
                                        ),
                                        content: Text(
                                          "This irreversible action will affect whole collaborators and will delete all sent messages and medias."
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("CANCEL"),
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(
                                                color: Palette.warning,
                                                fontWeight: FontWeight.w500
                                              )
                                            ),
                                            onPressed: (){
                                              Get.back();
                                            },
                                          ),
                                          TextButton(
                                            child: Text("DELETE"),
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(
                                                color: Palette.primary,
                                                fontWeight: FontWeight.w500
                                              )
                                            ),
                                            onPressed: (){
                                              _userProvider.getUserByID(widget.currentUserID).then((value){
                                                // ignore: unnecessary_null_comparison
                                                print(value);
                                                if(value != null){
                                                  _handlesProvider.hardDeleteHandle(value, handles);
                                                }
                                              });
                                              Get.offAll(() => Homepage());
                                            },
                                          )
                                        ],
                                      )
                                    : CupertinoAlertDialog(
                                        title: Text(
                                          "Are you sure you want to delete ${handles.name}?",
                                        ),
                                        content: Text(
                                          "This irreversible action will affect whole collaborators and will delete all sent messages and medias."
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("Cancel"),
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(
                                                color: Palette.warning,
                                                fontWeight: FontWeight.w500
                                              )
                                            ),
                                            onPressed: (){
                                              Get.back();
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Delete"),
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(
                                                color: Palette.primary,
                                                fontWeight: FontWeight.w500
                                              )
                                            ),
                                            onPressed: (){
                                              _userProvider.getUserByID(widget.currentUserID).then((value){
                                                // ignore: unnecessary_null_comparison
                                                if(value != null){
                                                  _handlesProvider.hardDeleteHandle(value, handles);
                                                }
                                              });
                                              Get.offAll(() => Homepage());
                                            },
                                          )
                                        ],
                                      )
                                  );
                                }
                              ),
                            ],
                          )
                        : SizedBox()
                      : SizedBox()
                    ],
                    floating: false,
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        var top = constraints.biggest.height;
                        return GestureDetector(
                          onTap: (){
                            Get.to(() => HandlesCoverPage(
                              handlesCoverURL: handles.cover != ""
                              ? handles.cover
                              : "assets/handles_logo.png",
                              handlesName: handles.name,
                              handlesID: handles.id
                            ));
                          },
                          child: FlexibleSpaceBar(
                            titlePadding: EdgeInsets.only(
                              left: top < 140 ? MQuery.width(0.06, context) : MQuery.width(0.02, context),
                              bottom: top < 140 ? MQuery.width(0.0185, context) : MQuery.width(0.02, context),
                              right: MQuery.width(0.02, context),
                            ),
                            title: Text(
                              handles.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )
                            ),
                            background: Hero(
                              tag: "handles_picture",
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image(
                                      image: handles.cover != ""
                                      ? NetworkImage(handles.cover) as ImageProvider
                                      : AssetImage("assets/handles_logo.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withOpacity(0.5)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          readOnly: isReadOnly,
                          keyboardType: TextInputType.text,
                          controller: descriptionController,
                          cursorColor: Palette.primary,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.4)
                            ),
                            hintText: "Enter your Handle's description here...",
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 15
                            ),
                            border: InputBorder.none
                          ),
                          onEditingComplete: (){
                            _handlesProvider.updateHandleDescription(widget.handlesID, descriptionController.text, handles.name);
                          }
                        ),
                        Divider(height: 1,),
                        ListTile(
                          title: Text(
                            "Medias, docs, meets, projects",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            )
                          ),
                          trailing: StreamBuilder<List<ChatModel>>(
                            stream: _chatProvider.handlesChats(widget.handlesID),
                            builder: (context, snapshot) {

                              int mediaCount = 0;
                              if(snapshot.hasData){
                                snapshot.data!.forEach((element) {
                                  if(element.mediaURL != "" || element.mediaURL != null){
                                    mediaCount++;
                                  }
                                });
                              }

                              return snapshot.hasData
                              ? Container(
                                  width: MQuery.width(0.07, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "$mediaCount",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        )
                                      ),
                                      SizedBox(width: MQuery.width(0.01, context)),
                                      Icon(
                                        CupertinoIcons.chevron_right,
                                        size: 16,
                                      ),
                                    ],
                                  )
                                )
                              : SizedBox();
                            }
                          ),
                          onTap: (){Get.to(() => HandlesMediasPage(), transition: Transition.cupertino);}
                        ),
                        Divider(height: 1,),
                        ListTile(
                          shape: Border.symmetric(
                            vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                          ),
                          title: Text(
                            "Mute notifications",
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
                                            "Handles DevTeam Payment Address",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Palette.primaryText,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          SizedBox(height: MQuery.height(0.02, context)),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Palette.formColor,
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                            ),
                                            child: TextFormField(
                                              readOnly: true,
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
                                            "This payment address (Credit Card) is officially afforded by this project's admin(s). Any form of transaction related to this project should be transferred to this address.",
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
                        SizedBox(height: MQuery.height(0.015, context)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MQuery.height(0.02, context)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Font.out(
                                "Collaborators (${handles.members.length})",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.start,
                                color: Colors.black.withOpacity(0.75)
                              ),
                              isReadOnly == false
                              ? FadeIn(
                                  child: Row(
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
                                          Get.dialog(AddMemberViaNumberDialog(
                                            handlesID: handles.id,
                                            handlesMembers: handles.members
                                          ));
                                        },
                                        icon: AdaptiveIcon(
                                          android: Icons.add,
                                          iOS: CupertinoIcons.add,
                                          color: Palette.primaryText,
                                          size: 24
                                        ),
                                      )
                                    ]
                                  ),
                                )
                              : SizedBox()
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.zero,
                          height: MQuery.height((handles.members.length + 1) * 0.1, context),
                          child: ListView.builder(
                            itemCount: handles.members.length,
                            itemBuilder: (context, index){
                              return FutureBuilder<UserModel>(
                                future: _userProvider.getUserByID(handles.members.keys.toList()[index]),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                  ? ListTile(
                                      onLongPress: (){
                                        isReadOnly == false && handles.members.entries.toList()[index].value != "Admin"
                                        ? Get.dialog(AddMemberViaNumberDialog(
                                            userModel: snapshot.data,
                                            handlesID: handles.id,
                                            handlesMembers: handles.members
                                          ))
                                        : print("");
                                      },
                                      contentPadding: EdgeInsets.fromLTRB(
                                        MQuery.width(0.02, context),
                                        0,
                                        MQuery.width(0.02, context),
                                        MQuery.height(0.015, context),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Palette.primary,
                                        radius: MQuery.height(0.025, context),
                                        backgroundImage: snapshot.data!.profilePicture != ""
                                        ? NetworkImage(snapshot.data!.profilePicture!) as ImageProvider
                                        : AssetImage("assets/sample_profile.png"),
                                      ),
                                      title: Font.out(
                                        snapshot.data!.name,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.start
                                      ),
                                      trailing: Container(
                                        width: MQuery.width(0.14, context),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Font.out(
                                              handles.members.entries.toList()[index].value,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              textAlign: TextAlign.start,
                                              color: Palette.primary
                                            ),
                                            isReadOnly == false && handles.members.entries.toList()[index].value != "Admin"
                                            ? FadeIn(
                                                child: IconButton(
                                                  onPressed: (){
                                                    Get.dialog(
                                                      Platform.isAndroid
                                                      ? AlertDialog(
                                                          title: Text(
                                                            "Are you sure you want to kick ${snapshot.data!.name}?",
                                                          ),
                                                          content: Text(
                                                            "This action will kick ${snapshot.data!.name} out of ${handles.name}"
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: Text("CANCEL"),
                                                              style: TextButton.styleFrom(
                                                                textStyle: TextStyle(
                                                                  color: Palette.warning,
                                                                  fontWeight: FontWeight.w500
                                                                )
                                                              ),
                                                              onPressed: (){
                                                                Get.back();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text("REMOVE"),
                                                              style: TextButton.styleFrom(
                                                                textStyle: TextStyle(
                                                                  color: Palette.primary,
                                                                  fontWeight: FontWeight.w500
                                                                )
                                                              ),
                                                              onPressed: (){
                                                                handles.members.remove(snapshot.data!.id);
                                                                Map<String, String> newHandlesMembers = handles.members;

                                                                print(newHandlesMembers);

                                                                _handlesProvider.deleteHandleCollaborator(
                                                                  snapshot.data!,
                                                                  newHandlesMembers,
                                                                  handles.id
                                                                );
                                                                Get.back();
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      : CupertinoAlertDialog(
                                                          title: Text(
                                                            "Are you sure you want to kick ${snapshot.data!.name}",
                                                          ),
                                                          content: Text(
                                                            "This action will kick ${snapshot.data!.name} out of ${handles.name}"
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: Text("Cancel"),
                                                              style: TextButton.styleFrom(
                                                                textStyle: TextStyle(
                                                                  color: Palette.warning,
                                                                  fontWeight: FontWeight.w500
                                                                )
                                                              ),
                                                              onPressed: (){
                                                                Get.back();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text("Remove"),
                                                              style: TextButton.styleFrom(
                                                                textStyle: TextStyle(
                                                                  color: Palette.primary,
                                                                  fontWeight: FontWeight.w500
                                                                )
                                                              ),
                                                              onPressed: (){
                                                                handles.members.remove(snapshot.data!.id);
                                                                Map<String, String> newHandlesMembers = handles.members;

                                                                print(newHandlesMembers);

                                                                _handlesProvider.deleteHandleCollaborator(
                                                                  snapshot.data!,
                                                                  newHandlesMembers,
                                                                  handles.id
                                                                );

                                                                Get.back();
                                                              },
                                                            )
                                                          ],
                                                        )
                                                    );
                                                  },
                                                  icon: AdaptiveIcon(
                                                    android: Icons.close,
                                                    iOS: CupertinoIcons.xmark,
                                                    color: Palette.primaryText,
                                                    size: 20
                                                  ),
                                                ),
                                              )
                                            : SizedBox()
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox();
                                }
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(MQuery.width(0.025, context)),
                          child: Button(
                            width: double.infinity,
                            title: "Left ${handles.name}",
                            textColor: Palette.warning,
                            color: Colors.white,
                            borderColor: Palette.warning,
                            method: (){

                              int adminCount = 0;
                              handles.members.entries.forEach((element) {
                                if(element.value == "Admin"){
                                  adminCount++;
                                }
                              });

                              if(handles.members[widget.currentUserID] == "Admin" && adminCount <= 1){
                                Get.dialog(
                                  Platform.isAndroid
                                  ? AlertDialog(
                                      title: Text(
                                        "Action permitted",
                                      ),
                                      content: Text(
                                        "You cannot leave this handle when you are an Admin and there are no other Admin collaborators. Please assign an Admin role to other collaborator before you leave."
                                      )
                                    )
                                  : CupertinoAlertDialog(
                                      title: Text(
                                        "Action permitted",
                                      ),
                                      content: Text(
                                        "You cannot leave this handle when you are an Admin and there are no other Admin collaborators. Please assign an Admin role to other collaborator before you leave."
                                      )
                                    )
                                );
                              } else {
                                Get.dialog(
                                  Platform.isAndroid
                                  ? AlertDialog(
                                      title: Text(
                                        "Are you sure you want to left ${handles.name}?",
                                      ),
                                      content: Text(
                                        "This action will make you leave ${handles.name} and you need an invitation to rejoin this handle."
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("CANCEL"),
                                          style: TextButton.styleFrom(
                                            textStyle: TextStyle(
                                              color: Palette.warning,
                                              fontWeight: FontWeight.w500
                                            )
                                          ),
                                          onPressed: (){
                                            Get.back();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("LEAVE"),
                                          style: TextButton.styleFrom(
                                            textStyle: TextStyle(
                                              color: Palette.primary,
                                              fontWeight: FontWeight.w500
                                            )
                                          ),
                                          onPressed: (){
                                            handles.members.remove(widget.currentUserID);
                                            Map<String, String> newHandlesMembers = handles.members;

                                            print(newHandlesMembers);

                                            _userProvider.getUserByID(widget.currentUserID).then((value){
                                              // ignore: unnecessary_null_comparison
                                              if(value != null){
                                                _handlesProvider.deleteHandleCollaborator(
                                                  value,
                                                  newHandlesMembers,
                                                  handles.id
                                                );
                                              }
                                            });
                                            Get.back();
                                          },
                                        )
                                      ],
                                    )
                                  : CupertinoAlertDialog(
                                      title: Text(
                                        "Are you sure you want to left ${handles.name}?",
                                      ),
                                      content: Text(
                                        "This action will make you leave ${handles.name} and you need an invitation to rejoin this handle."
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("Cancel"),
                                          style: TextButton.styleFrom(
                                            textStyle: TextStyle(
                                              color: Palette.warning,
                                              fontWeight: FontWeight.w500
                                            )
                                          ),
                                          onPressed: (){
                                            Get.back();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Leave"),
                                          style: TextButton.styleFrom(
                                            textStyle: TextStyle(
                                              color: Palette.primary,
                                              fontWeight: FontWeight.w500
                                            )
                                          ),
                                          onPressed: (){
                                            handles.members.remove(widget.currentUserID);
                                            Map<String, String> newHandlesMembers = handles.members;

                                            print(newHandlesMembers);

                                            _userProvider.getUserByID(widget.currentUserID).then((value){
                                              // ignore: unnecessary_null_comparison
                                              if(value != null){
                                                _handlesProvider.deleteHandleCollaborator(
                                                  value,
                                                  newHandlesMembers,
                                                  handles.id
                                                );
                                              }
                                            });
                                            Get.back();
                                          },
                                        )
                                      ],
                                    )
                                );
                              }
                            }
                          ),
                        ),
                      ]
                    )
                  )
                ],
              ),
            );
          },
          loading: (){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Palette.primary)
              )
            );
          },
          error: (object , error){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Palette.warning)
              )
            );
          }
        );
      },
    );
  }
}