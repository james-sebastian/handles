part of 'widgets.dart';

class ImageChat extends StatefulWidget {

  final int scrollLocation;
  final int index;
  final String userID;
  final String handlesID;
  final String chatID;
  final String sender;
  final String senderRole;
  final String imageURL;
  final String content;
  final bool isRecurring;
  final bool isPinned;
  final DateTime timestamp;
  final Set<int> selectedChats;
  final void Function(int) chatOnTap;
  final void Function(int) selectChatMethod;
  final void Function(int) scrollToTarget;
  final ChatModel? replyTo;
  final List<String> deletedBy;
  final List<String> readBy;
  
  const ImageChat(
    {Key? key,
    required this.handlesID,
    required this.chatID,
    required this.userID,
    required this.deletedBy,
    required this.readBy,
    required this.index,
    required this.timestamp,
    required this.sender,
    required this.senderRole,
    required this.imageURL,
    required this.isRecurring,
    required this.isPinned,
    required this.content,
    required this.selectChatMethod,
    required this.chatOnTap,
    required this.scrollToTarget,
    required this.scrollLocation,
    required this.selectedChats,
    this.replyTo,
  }) : super(key: key);

  @override
  _ImageChatState createState() => _ImageChatState();
}

class _ImageChatState extends State<ImageChat> {

  bool isExist = false;

  Future<String> getFileExtension(String filePath) async {
    String? ext = extension(filePath);
    return ext.substring(0, ext.indexOf("?")).replaceAll(".", "");
  }

  Future<String?> getFileName(String filePath) async {
    String name = Uri.decodeFull(basenameWithoutExtension(filePath));
    int location = name.lastIndexOf("/");
    return name.substring(location + 1, name.length - 1);
  }

  Future<bool?> checkFileExistence() async{
    Directory? directory;

    if (await _requestPermission(Permission.manageExternalStorage)) {
      directory = await getExternalStorageDirectory();
      String newPath = "";
      List<String> paths = directory!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }

      getFileName(widget.imageURL).then((name){
        getFileExtension(widget.imageURL).then((ext){
          newPath = newPath + "/Handles/Images/$name.$ext";
          try{
            File(newPath).open().then((value){
              setState(() {
                isExist = true;
              });
            });
          } catch (e){
            setState(() {
              isExist = true;
            });
            return false;
          }
        });
      });
    } else {
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> saveFile(String url) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.manageExternalStorage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Handles/Images";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.manageExternalStorage)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      getFileName(widget.imageURL).then((name){
        getFileExtension(widget.imageURL).then((ext) async {
          File saveFile = File(directory!.path + "/$name.$ext");
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          if (await directory.exists()) {
            await Dio().download(
              url,
              saveFile.path,
              onReceiveProgress: (value1, value2) {
                print("$value1 - $value2");
              });
            if (Platform.isIOS) {
              
            }
            return true;
          }
        });
      });

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<File?> getLocalFile() async {
    Directory? directory;
    if (await _requestPermission(Permission.manageExternalStorage)) {
      directory = await getExternalStorageDirectory();
      String newPath = "";
      List<String> paths = directory!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }

      getFileName(widget.imageURL).then((name){
        getFileExtension(widget.imageURL).then((ext){
          newPath = newPath + "/Handles/Images/$name.$ext";
          try{
            return File(newPath + "/Handles/Images/$name.$ext");
          } catch (e) {
            print(e);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch,child) {
        final _userProvider = watch(userProvider);
        final _chatProvider = watch(chatProvider);

        return widget.deletedBy.indexOf(widget.userID) >= 0
        ? SizedBox()
        : widget.sender == widget.userID
            ? VisibilityDetector(
              key: Key("$widget.index"),
              onVisibilityChanged: (VisibilityInfo info) {

                if(!(widget.deletedBy.indexOf(widget.userID) >= 0)){
                  getFileName(widget.imageURL).then((value){
                    saveFile(widget.imageURL);
                  });
                }

                if(widget.readBy.indexOf(widget.sender) >= 0){
                  print("already read");
                } else {
                  List<String> newReadBy = widget.readBy;
                  newReadBy.add(widget.userID);

                  _chatProvider.readChat(
                    widget.handlesID,
                    widget.chatID,
                    newReadBy
                  );
                }
              },
              child: FutureBuilder<UserModel>(
                  future: _userProvider.getUserByID(widget.sender),
                  builder: (context, snapshot) {
                    return Container(
                        width: MQuery.width(1, context),
                        margin: EdgeInsets.only(bottom: MQuery.width(0.01, context)),
                        padding: EdgeInsets.symmetric(
                            horizontal: MQuery.width(0.01, context)),
                        color: widget.selectedChats.toList().indexOf(widget.index) >= 0
                            ? Palette.primary.withOpacity(0.25)
                            : Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.chatOnTap(widget.index);
                          },
                          onLongPress: () {
                            widget.selectChatMethod(widget.index);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: MQuery.width(
                                        widget.imageURL.length >= 30
                                            ? 0.35
                                            : widget.imageURL.length <= 12
                                                ? 0.15
                                                : widget.imageURL.length * 0.009,
                                        context),
                                    minWidth: MQuery.width(0.1, context),
                                    minHeight: MQuery.height(0.045, context)),
                                child: Container(
                                    padding:
                                        EdgeInsets.all(MQuery.height(0.01, context)),
                                    decoration: BoxDecoration(
                                        color: Palette.primary,
                                        borderRadius: BorderRadius.only(
                                            topRight: widget.isRecurring
                                                ? Radius.circular(7)
                                                : Radius.circular(0),
                                            topLeft: Radius.circular(7),
                                            bottomRight: Radius.circular(7),
                                            bottomLeft: Radius.circular(7))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        widget.replyTo != null
                                        ? GestureDetector(
                                          onTap: (){
                                            widget.scrollToTarget(widget.scrollLocation);
                                          },
                                          child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxHeight:
                                                      MQuery.height(0.15, context),
                                                  minWidth:
                                                      MQuery.width(0.35, context)),
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical:
                                                          MQuery.height(0.005, context),
                                                      horizontal: MQuery.height(
                                                          0.001, context)),
                                                  padding: EdgeInsets.all(
                                                      MQuery.height(0.01, context)),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(7)),
                                                      color: Colors.grey[200]!
                                                          .withOpacity(0.35)),
                                                  child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        FutureBuilder<UserModel>(
                                                          future: _userProvider.getUserByID(widget.replyTo!.sender),
                                                          builder: (context, snapshot) {
                                                            return snapshot.hasData
                                                            ? Text(
                                                                snapshot.data!.name, 
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 13,
                                                                )
                                                              )
                                                            : SizedBox();
                                                          }
                                                        ),
                                                        SizedBox(height: MQuery.height(0.005, context)),
                                                        Text(
                                                          widget.replyTo!.type == ChatType.image
                                                          ? "[Image] ${
                                                                widget.replyTo!.content!.length >= 35
                                                                ? widget.replyTo!.content!.substring(0, 32) + "..."
                                                                : widget.replyTo!.content!
                                                              }"
                                                          : widget.replyTo!.type == ChatType.video
                                                          ? "[Video] ${
                                                                widget.replyTo!.content!.length >= 35
                                                                ? widget.replyTo!.content!.substring(0, 32) + "..."
                                                                : widget.replyTo!.content!
                                                              }"
                                                          : widget.replyTo!.type == ChatType.docs
                                                          ? "[Docs] ${
                                                                widget.replyTo!.content!.length >= 35
                                                                ? widget.replyTo!.content!.substring(0, 32) + "..."
                                                                : widget.replyTo!.content!
                                                              }"
                                                          : widget.replyTo!.content!.length >= 35
                                                            ? widget.replyTo!.content!.substring(0, 32) + "..."
                                                            : widget.replyTo!.content!, 
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            height: 1.25
                                                          )
                                                        )
                                                      ]))),
                                        )
                                        : SizedBox(
                                            height: MQuery.height(0, context)),
                                        SizedBox(
                                            height: MQuery.height(0.005, context)),
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(() => ImagePreviewer(
                                                    imageURL: widget.imageURL,
                                                    timeStamp: widget.timestamp,
                                                    sender: snapshot.data!.name,
                                                    heroTag: "image-$widget.index",
                                                    content: widget.content));
                                              },
                                              child: Hero(
                                                tag: "image-$widget.index",
                                                child: Stack(
                                                  alignment: Alignment.bottomRight,
                                                  children: [
                                                    Container(
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                                      child: isExist
                                                      ? FutureBuilder<File?>(
                                                          future: getLocalFile(),
                                                          builder: (context, snapshot){
                                                            return snapshot.hasData
                                                            ? Image.file(snapshot.data!)
                                                            : SizedBox();
                                                          }
                                                        )
                                                      : Image.network(widget.imageURL)
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          widget.isPinned
                                                              ? AdaptiveIcon(
                                                                  android:
                                                                      Icons.push_pin,
                                                                  iOS: CupertinoIcons
                                                                      .pin_fill,
                                                                  size: 12,
                                                                  color: Palette
                                                                      .handlesBackground,
                                                                )
                                                              : SizedBox(),
                                                          Text(
                                                            DateFormat.jm()
                                                                .format(widget.timestamp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Colors.white
                                                                    .withOpacity(0.5),
                                                                fontWeight:
                                                                    FontWeight.w400,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        widget.content == ""
                                            ? SizedBox()
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                      height: MQuery.height(
                                                          0.0075, context)),
                                                  SelectableLinkify(
                                                    onOpen: (link) async {
                                                      print(link.url);
                                                      await launch(link.url);
                                                    },
                                                    text: widget.content,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        height: 1.25,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    )),
                              ),
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: SvgPicture.asset("assets/tool_tip.svg",
                                    height: MQuery.height(0.02, context),
                                    width: MQuery.height(0.02, context),
                                    color: widget.isRecurring
                                        ? Colors.transparent
                                        : Palette.primary),
                              ),
                            ],
                          ),
                        ));
                  }),
            )
            : VisibilityDetector(
              key: Key("$widget.index"),
              onVisibilityChanged: (VisibilityInfo info) {

                if(!(widget.deletedBy.indexOf(widget.userID) >= 0)){
                  getFileName(widget.imageURL).then((value){
                    saveFile(widget.imageURL);
                  });
                }

                if(widget.readBy.indexOf(widget.sender) >= 0){
                  print("already read");
                } else {
                  List<String> newReadBy = widget.readBy;
                  newReadBy.add(widget.userID);

                  _chatProvider.readChat(
                    widget.handlesID,
                    widget.chatID,
                    newReadBy
                  );
                }
              },
              child: FutureBuilder<UserModel>(
                  future: _userProvider.getUserByID(widget.sender),
                  builder: (context, snapshot) {
                    return Container(
                        width: MQuery.width(1, context),
                        margin: EdgeInsets.only(bottom: MQuery.width(0.01, context)),
                        padding: EdgeInsets.symmetric(
                            horizontal: MQuery.width(0.01, context)),
                        color: widget.selectedChats.toList().indexOf(widget.index) >= 0
                            ? Palette.primary.withOpacity(0.25)
                            : Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.chatOnTap(widget.index);
                          },
                          onLongPress: () {
                            widget.selectChatMethod(widget.index);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset("assets/tool_tip.svg",
                                  height: MQuery.height(0.02, context),
                                  width: MQuery.height(0.02, context),
                                  color: widget.isRecurring
                                      ? Colors.transparent
                                      : Colors.white),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: MQuery.width(
                                        widget.imageURL.length >= 30
                                            ? 0.35
                                            : widget.imageURL.length <= 12
                                                ? 0.15
                                                : widget.imageURL.length * 0.009,
                                        context),
                                    minWidth: MQuery.width(0.14, context),
                                    minHeight: MQuery.height(0.045, context)),
                                child: Container(
                                  padding:
                                      EdgeInsets.all(MQuery.height(0.01, context)),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: widget.isRecurring
                                              ? Radius.circular(7)
                                              : Radius.circular(0),
                                          topRight: Radius.circular(7),
                                          bottomRight: Radius.circular(7),
                                          bottomLeft: Radius.circular(7))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          widget.isRecurring
                                              ? SizedBox()
                                              : RichText(
                                                  text: TextSpan(
                                                    text: "${snapshot.data!.name} ",
                                                    style: TextStyle(
                                                        color: Palette.primary,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15),
                                                    children: [ 
                                                      TextSpan(
                                                          text:
                                                              "(${widget.senderRole})",
                                                          style: TextStyle(
                                                              color: Palette.primary,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              fontSize: 15)),
                                                    ],
                                                  ),
                                                ),
                                          widget.isPinned
                                              ? AdaptiveIcon(
                                                  android: Icons.push_pin,
                                                  iOS: CupertinoIcons.pin_fill,
                                                  size: 12)
                                              : SizedBox()
                                        ],
                                      ),
                                      SizedBox(height: MQuery.height(0.005, context)),
                                      widget.replyTo != null
                                      ? GestureDetector(
                                        onTap: (){
                                          widget.scrollToTarget(widget.scrollLocation);
                                        },
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: MQuery.height(0.15, context),
                                              minWidth: double.infinity,
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                vertical: MQuery.height(0.005, context),
                                                horizontal: MQuery.height(0.001, context)
                                              ),
                                              padding: EdgeInsets.all(MQuery.height(0.01, context)),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                                color: Colors.grey[200]
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  FutureBuilder<UserModel>(
                                                    future: _userProvider.getUserByID(widget.replyTo!.sender),
                                                    builder: (context, snapshot) {
                                                      return snapshot.hasData
                                                      ? Text(
                                                          snapshot.data!.name, 
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 13,
                                                          )
                                                        )
                                                      : SizedBox();
                                                    }
                                                  ),
                                                  SizedBox(height: MQuery.height(0.005, context)),
                                                  Text(
                                                    widget.replyTo!.type == ChatType.image
                                                    ? "[Image] ${
                                                          widget.replyTo!.content!.length >= 35
                                                          ? widget.replyTo!.content!.substring(0, 32) + "..."
                                                          : widget.replyTo!.content!
                                                        }"
                                                    : widget.replyTo!.type == ChatType.video
                                                    ? "[Video] ${
                                                          widget.replyTo!.content!.length >= 35
                                                          ? widget.replyTo!.content!.substring(0, 32) + "..."
                                                          : widget.replyTo!.content!
                                                        }"
                                                    : widget.replyTo!.type == ChatType.docs
                                                    ? "[Docs] ${
                                                          widget.replyTo!.content!.length >= 35
                                                          ? widget.replyTo!.content!.substring(0, 32) + "..."
                                                          : widget.replyTo!.content!
                                                        }"
                                                    : widget.replyTo!.content!.length >= 35
                                                      ? widget.replyTo!.content!.substring(0, 32) + "..."
                                                      : widget.replyTo!.content!, 
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      height: 1.25
                                                    )
                                                  )
                                                ]
                                              )
                                            )
                                          ),
                                      )
                                      : SizedBox(),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => ImagePreviewer(
                                              imageURL: widget.imageURL,
                                              timeStamp: widget.timestamp,
                                              sender: snapshot.data!.name,
                                              heroTag: "image-$widget.index",
                                              content: widget.content));
                                        },
                                        child: Hero(
                                          tag: "image-$widget.index",
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: isExist
                                                ? FutureBuilder<File?>(
                                                    future: getLocalFile(),
                                                    builder: (context, snapshot){
                                                      return snapshot.hasData
                                                      ? Image.file(snapshot.data!)
                                                      : SizedBox();
                                                    }
                                                  )
                                                : Image.network(widget.imageURL)
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  DateFormat.jm().format(widget.timestamp),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      widget.content == ""
                                          ? SizedBox()
                                          : Column(
                                              children: [
                                                SizedBox(
                                                    height: MQuery.height(
                                                        0.0075, context)),
                                                SelectableLinkify(
                                                  onOpen: (link) async {
                                                    print(link.url);
                                                    await launch(link.url);
                                                  },
                                                  text: widget.content,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      height: 1.25,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  }),
            );
      },
    );
  }
}