part of "../pages.dart";

class HandlesMediasPage extends StatefulWidget {

  final String handlesID;
  final String currentUserID;
  const HandlesMediasPage({ Key? key, required this.handlesID, required this.currentUserID }) : super(key: key);

  @override
  _HandlesMediasPageState createState() => _HandlesMediasPageState();
}

class _HandlesMediasPageState extends State<HandlesMediasPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState(){ 
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  //VIDEO
  Future<String?> getThumbnail(String videoURL) async {
    final String? fileName = await VideoThumbnail.thumbnailFile(
      video: videoURL,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 180,
      quality: 50,
    );

    return fileName;
  }

  bool isExist = false;

  Future<bool> saveFile(String url, String fileName) async {
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
          newPath = newPath + "/Handles/Docs";
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

      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await Dio().download(
          url,
          saveFile.path,
          onReceiveProgress: (value1, value2) {
            //notification
            print("$value1 - $value2");
          });
        if (Platform.isIOS) {
          
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
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

  Future<String> getFileSize(String filepath, int decimals) async {
    http.Response r = await http.get(Uri.parse(filepath));
    final bytes = int.parse(r.headers["content-length"] ?? "0");
    if (bytes <= 0) {
      return "0 B";
    }
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  Future<String> getFileExtension(String filePath) async {
    String? ext = extension(filePath);
    return ext.substring(0, ext.indexOf("?")).replaceAll(".", "");
  }

  Future<String?> getFileName(String filePath) async {
    String name = Uri.decodeFull(basenameWithoutExtension(filePath));
    int location = name.lastIndexOf("/");
    return name.substring(location + 1, name.length - 1);
  }

  Future<bool?> checkFileExistence(String documentURL) async{
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

      getFileName(documentURL).then((name){
        getFileExtension(documentURL).then((ext){
          newPath = newPath + "/Handles/Docs/$name.$ext";
          try{
            File(newPath).open().then((value){
              setState(() {
                isExist = true;
              });
            });
          } catch (e){
            setState(() {
              isExist = false;
            });
            return false;
          }
        });
      });
    } else {
      return false;
    }
  }

  Future<void> openFile(String documentURL) async{
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

      getFileName(documentURL).then((name){
        getFileExtension(documentURL).then((ext){
          newPath = newPath + "/Handles/Docs/$name.$ext";
          try{
            OpenFile.open(newPath);
          } catch (e) {
            print(e);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Consumer(
          builder: (ctx, watch,child) {

            final _singleHandlesProvider = watch(singleHandlesProvider(widget.handlesID));
            final _chatProvider = watch(chatProvider);
            final _userProvider = watch(userProvider);

            return _singleHandlesProvider.when(
              data: (handles){
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Palette.primary,
                    leading: IconButton(
                      icon: AdaptiveIcon(
                        android: Icons.arrow_back,
                        iOS: CupertinoIcons.back,
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                    ),
                    bottom: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(text: "Images".toUpperCase()),
                        Tab(text: "Videos".toUpperCase()),
                        Tab(text: "Docs".toUpperCase()),
                        Tab(text: "Projects".toUpperCase()),
                        Tab(text: "Meets".toUpperCase()),
                      ],
                    ),
                    title: Text("${handles.name}'s Medias"),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      StreamBuilder<List<ChatModel>>(
                        stream: _chatProvider.handlesChats(widget.handlesID),
                        builder: (context, snapshot) {

                          List<List<ChatModel>> chatsByDate = [];
                          Set<String> mediaChatTimestamps = Set();
                          bool isEmpty = true;

                          if(snapshot.hasData){
                            snapshot.data!.forEach((element) {
                              if(element.mediaURL != "" && element.deletedBy.indexOf(widget.currentUserID) < 0){
                                mediaChatTimestamps.add(element.timestamp.toString().substring(0, 10));
                              }
                            });
                          }

                          if(snapshot.hasData){
                            if(mediaChatTimestamps.isNotEmpty){
                              mediaChatTimestamps.forEach((date) {
                                List<ChatModel> dayChats = [];
                                snapshot.data!.forEach((chat){
                                  if(chat.timestamp.toString().substring(0, 10) == date && chat.mediaURL != "" && chat.deletedBy.indexOf(widget.currentUserID) < 0 && chat.type == ChatType.image){
                                    dayChats.add(chat);
                                  }
                                });
                                if(dayChats.isNotEmpty){
                                  chatsByDate.add(dayChats);
                                  isEmpty = false;
                                }
                              });
                            }
                          }

                          return snapshot.hasData && isEmpty == false
                          ? ListView.builder(
                              shrinkWrap: false,
                              itemCount: chatsByDate.reversed.length, //day separator
                              itemBuilder: (context, index){
                                return Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                        top: index > 1 ? MQuery.height(0, context) : MQuery.height(0.025, context),
                                        bottom: MQuery.height(0.015, context),
                                        left: MQuery.height(0.015, context)
                                      ),
                                      child: Text(
                                        DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index]).day == DateTime.now().day
                                        ? "TODAY"
                                        : DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index]).day == DateTime.now().subtract(1.days).day
                                          ? "YESTERDAY"
                                          : DateFormat.yMd().format(DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index])),
                                        style: TextStyle(
                                          color: Palette.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 150,
                                      child: GridView.builder(
                                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 1 / 1,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0
                                        ),
                                        itemCount: chatsByDate.reversed.toList()[index].length,
                                        itemBuilder: (BuildContext ctx, index2) {
                                          return GestureDetector(
                                            onTap: (){
                                              _userProvider.getUserByID(chatsByDate.reversed.toList()[index][index2].sender).then((value){
                                                 Get.to(() => ImagePreviewer(
                                                  imageURL: chatsByDate.reversed.toList()[index][index2].mediaURL ?? "",
                                                  timeStamp: chatsByDate.reversed.toList()[index][index2].timestamp,
                                                  sender: value.name,
                                                  heroTag: "img:$index2",
                                                  content: chatsByDate.reversed.toList()[index][index2].content ?? ""
                                                ));
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Hero(
                                                tag: "img:$index2",
                                                child: Image(
                                                  image: NetworkImage(chatsByDate.reversed.toList()[index][index2].mediaURL ?? ""),
                                                  fit: BoxFit.fitWidth
                                                ),
                                              ),
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : SizedBox();
                        }
                      ),
                      StreamBuilder<List<ChatModel>>(
                        stream: _chatProvider.handlesChats(widget.handlesID),
                        builder: (context, snapshot) {

                          List<List<ChatModel>> chatsByDate = [];
                          Set<String> mediaChatTimestamps = Set();
                          bool isEmpty = true;

                          if(snapshot.hasData){
                            snapshot.data!.forEach((element) {
                              if(element.mediaURL != "" && element.deletedBy.indexOf(widget.currentUserID) < 0){
                                mediaChatTimestamps.add(element.timestamp.toString().substring(0, 10));
                              }
                            });
                          }

                          if(snapshot.hasData){
                            if(mediaChatTimestamps.isNotEmpty){
                              mediaChatTimestamps.forEach((date) {
                                List<ChatModel> dayChats = [];
                                snapshot.data!.forEach((chat){
                                  if(chat.timestamp.toString().substring(0, 10) == date && chat.mediaURL != "" && chat.deletedBy.indexOf(widget.currentUserID) < 0 && chat.type == ChatType.video){
                                    dayChats.add(chat);
                                  }
                                });
                                if(dayChats.isNotEmpty){
                                  chatsByDate.add(dayChats);
                                  isEmpty = false;
                                }
                              });
                            }
                          }

                          return snapshot.hasData && isEmpty == false
                          ? ListView.builder(
                              shrinkWrap: false,
                              itemCount: chatsByDate.reversed.length, //day separator
                              itemBuilder: (context, index){
                                return Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                        top: index > 1 ? MQuery.height(0, context) : MQuery.height(0.025, context),
                                        bottom: MQuery.height(0.015, context),
                                        left: MQuery.height(0.015, context)
                                      ),
                                      child: Text(
                                        DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index]).day == DateTime.now().day
                                        ? "TODAY"
                                        : DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index]).day == DateTime.now().subtract(1.days).day
                                          ? "YESTERDAY"
                                          : DateFormat.yMd().format(DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index])),
                                        style: TextStyle(
                                          color: Palette.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 150,
                                      child: GridView.builder(
                                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 1 / 1,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0
                                        ),
                                        itemCount: chatsByDate.reversed.toList()[index].length,
                                        itemBuilder: (BuildContext ctx, index2) {
                                          return GestureDetector(
                                            onTap: (){
                                              _userProvider.getUserByID(chatsByDate.reversed.toList()[index][index2].sender).then((value){
                                                 Get.to(() => VideoPreviewer(
                                                  videoURL: chatsByDate.reversed.toList()[index][index2].mediaURL ?? "",
                                                  timeStamp: chatsByDate.reversed.toList()[index][index2].timestamp,
                                                  sender: value.name,
                                                  heroTag: "img:$index2",
                                                  content: chatsByDate.reversed.toList()[index][index2].content ?? ""
                                                ));
                                              });
                                            },
                                            child: Container(
                                              child: AspectRatio(
                                                aspectRatio: 1/1,
                                                child: FutureBuilder<String?>(
                                                  future: getThumbnail(chatsByDate.reversed.toList()[index][index2].mediaURL ?? ""),
                                                  builder: (context, snapshot){
                                                    return snapshot.hasData
                                                    ? Container(
                                                        width: MQuery.width(0.35, context),
                                                        child: Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            Positioned.fill(
                                                              child: Image.file(
                                                                File(snapshot.data ?? ""),
                                                                fit: BoxFit.fill
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MQuery.width(0.35, context),
                                                              clipBehavior: Clip.antiAlias,
                                                              decoration: BoxDecoration(
                                                                color: Colors.black.withOpacity(0.25),
                                                              )
                                                            ),
                                                            AdaptiveIcon(
                                                              android: Icons.play_arrow_rounded,
                                                              iOS: CupertinoIcons.play_arrow_solid,
                                                              size: 32,
                                                              color: Colors.white
                                                            )
                                                          ],
                                                        )
                                                      )
                                                    : Container(
                                                        width: MQuery.width(0.35, context),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.5),
                                                        ),
                                                        child: Center(
                                                          child: CircularProgressIndicator(
                                                            color: Palette.primary,
                                                          ),
                                                        )
                                                    );
                                                  },
                                                )
                                              )
                                            )
                                          );
                                        }
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : SizedBox();
                        }
                      ),
                      StreamBuilder<List<ChatModel>>(
                        stream: _chatProvider.handlesChats(widget.handlesID),
                        builder: (context, snapshot) {

                          List<List<ChatModel>> chatsByDate = [];
                          Set<String> mediaChatTimestamps = Set();
                          bool isEmpty = true;

                          if(snapshot.hasData){
                            snapshot.data!.forEach((element) {
                              if(element.mediaURL != "" && element.deletedBy.indexOf(widget.currentUserID) < 0){
                                mediaChatTimestamps.add(element.timestamp.toString().substring(0, 10));
                              }
                            });
                          }

                          if(snapshot.hasData){
                            if(mediaChatTimestamps.isNotEmpty){
                              mediaChatTimestamps.forEach((date) {
                                List<ChatModel> dayChats = [];
                                snapshot.data!.forEach((chat){
                                  if(
                                    chat.timestamp.toString().substring(0, 10) == date && chat.mediaURL != "" &&
                                    chat.deletedBy.indexOf(widget.currentUserID) < 0 &&
                                    chat.type == ChatType.docs
                                  ){
                                    dayChats.add(chat);
                                  }
                                });
                                if(dayChats.isNotEmpty){
                                  chatsByDate.add(dayChats);
                                  isEmpty = false;
                                }
                              });
                            }
                          }

                          return snapshot.hasData && isEmpty == false
                          ? ListView.builder(
                              shrinkWrap: false,
                              itemCount: chatsByDate.reversed.length, //day separator
                              itemBuilder: (context, index){
                                return Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                        top: index > 1 ? MQuery.height(0, context) : MQuery.height(0.025, context),
                                        bottom: MQuery.height(0.015, context),
                                        left: MQuery.height(0.015, context)
                                      ),
                                      child: Text(
                                        DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index]).day == DateTime.now().day
                                        ? "TODAY"
                                        : DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index]).day == DateTime.now().subtract(1.days).day
                                          ? "YESTERDAY"
                                          : DateFormat.yMd().format(DateTime.parse(mediaChatTimestamps.toList().reversed.toList()[index])),
                                        style: TextStyle(
                                          color: Palette.primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 150,
                                      child: ListView.builder(
                                        itemCount: chatsByDate.reversed.toList()[index].length,
                                        itemBuilder: (BuildContext ctx, index2) {

                                          ChatModel currentChat = chatsByDate.reversed.toList()[index][index2];
                                          if(isExist == false){
                                            WidgetsBinding.instance!.addPostFrameCallback((_){
                                              if(currentChat.mediaURL != null){
                                                checkFileExistence(currentChat.mediaURL!);
                                              }
                                            });
                                          }

                                          return Container(
                                            width: MQuery.width(1, context),
                                            margin: EdgeInsets.only(bottom: MQuery.width(0.01, context)),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: MQuery.width(0.01, context)
                                            ),
                                            color: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: MQuery.width(
                                                      currentChat.mediaURL!.length >= 30
                                                      ? 0.35
                                                      : currentChat.mediaURL!.length <= 12
                                                        ? 0.15
                                                        : currentChat.mediaURL!.length * 0.009, context),
                                                    minWidth: MQuery.width(0.1, context),
                                                    minHeight: MQuery.height(0.045, context)),
                                                  child: Container(
                                                    padding: EdgeInsets.all(MQuery.height(0.01, context)),
                                                    decoration: BoxDecoration(
                                                      color: Palette.primary,
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(7),
                                                        topLeft: Radius.circular(7),
                                                        bottomRight: Radius.circular(7),
                                                        bottomLeft: Radius.circular(7)
                                                      )
                                                    ),
                                                    child: Stack(
                                                      alignment: Alignment.bottomRight,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                FutureBuilder<String>(
                                                                  future: getFileSize(currentChat.mediaURL!, 2),
                                                                  builder: (context, snapshot) {
                                                                    return snapshot.hasData
                                                                    ? Text(
                                                                        snapshot.data ?? "",
                                                                        textAlign: TextAlign.start,
                                                                        style: TextStyle(
                                                                            color: Colors.white
                                                                                .withOpacity(0.5),
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12),
                                                                      )
                                                                    : SizedBox();
                                                                  }),
                                                                SizedBox(width: 5),
                                                                Container(
                                                                    height: 3,
                                                                    width: 3,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.white
                                                                            .withOpacity(0.5))),
                                                                SizedBox(width: 5),
                                                                FutureBuilder<String>(
                                                                  future: getFileExtension(currentChat.mediaURL!),
                                                                  builder: (context, snapshot) {
                                                                    return snapshot.hasData
                                                                    ? Text(
                                                                        snapshot.data!
                                                                            .toUpperCase(),
                                                                        textAlign: TextAlign.start,
                                                                        style: TextStyle(
                                                                            color: Colors.white
                                                                                .withOpacity(0.5),
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12),
                                                                      )
                                                                    : SizedBox();
                                                                  }
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              DateFormat.jm().format(currentChat.timestamp),
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                color: Colors.white.withOpacity(0.5),
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 12
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            SizedBox(height: MQuery.height(0.005, context)),
                                                            Row(
                                                              children: [
                                                                SizedBox(width: MQuery.width(0.003, context)),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(5)),
                                                                    color: Palette.handlesBackground,
                                                                  ),
                                                                  height: MQuery.height(0.05, context),
                                                                  width: MQuery.width(0.325, context),
                                                                  padding: EdgeInsets.only(
                                                                      left: MQuery.width(0.01, context)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                              "assets/mdi_file-document.svg",
                                                                              height: 18,
                                                                              width: 18,
                                                                              color: Palette.primary),
                                                                          SizedBox(
                                                                              width: MQuery.width(
                                                                                  0.01, context)),
                                                                          FutureBuilder<String?>(
                                                                            future: getFileName(currentChat.mediaURL!),
                                                                            builder: (context, snapshot) {
                                                                              return snapshot.hasData
                                                                              ? Text(
                                                                                  snapshot.data!.length >= 23
                                                                                  ? snapshot.data!.substring(0, 20) + "..."
                                                                                  : snapshot.data!,
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    fontSize: 14
                                                                                  )
                                                                                )
                                                                              : SizedBox();
                                                                            }
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      IconButton(
                                                                        onPressed: () {
                                                                          if(isExist){
                                                                            openFile(currentChat.mediaURL!);
                                                                          } else {
                                                                            getFileName(currentChat.mediaURL!).then((name){
                                                                              getFileExtension(currentChat.mediaURL!).then((ext){
                                                                                if(name != null){
                                                                                  saveFile(currentChat.mediaURL!, "$name.$ext");
                                                                                }
                                                                              });
                                                                            });
                                                                          }
                                                                        },
                                                                        icon: isExist
                                                                        ? AdaptiveIcon(
                                                                            android: Icons.folder_open,
                                                                            iOS: CupertinoIcons.folder_fill,
                                                                            size: 18,
                                                                            color: Palette.primary
                                                                          )
                                                                        : AdaptiveIcon(
                                                                            android: Icons.download,
                                                                            iOS: CupertinoIcons.cloud_download_fill,
                                                                            size: 18,
                                                                            color: Palette.primary
                                                                          ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(height: MQuery.height(0.0275, context))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          );
                                        }
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : SizedBox();
                        }
                      ),
                      StreamBuilder<List<ChatModel>>(
                        stream: _chatProvider.handlesChats(widget.handlesID),
                        builder: (context, snapshot) {

                          List<List<ChatModel>> chatsByDate = [];
                          Set<String> mediaChatTimestamps = Set();

                          if(snapshot.hasData){
                            snapshot.data!.forEach((element) {
                              if(element.mediaURL != "" && element.deletedBy.indexOf(widget.currentUserID) < 0){
                                mediaChatTimestamps.add(element.timestamp.toString().substring(0, 10));
                              }
                            });
                          }

                          if(snapshot.hasData){
                            if(mediaChatTimestamps.isNotEmpty){
                              mediaChatTimestamps.forEach((date) {
                                List<ChatModel> dayChats = [];
                                snapshot.data!.forEach((chat){
                                  if(chat.timestamp.toString().substring(0, 10) == date && chat.mediaURL != "" && chat.deletedBy.indexOf(widget.currentUserID) < 0){
                                    dayChats.add(chat);
                                  }
                                });
                                chatsByDate.add(dayChats);
                              });
                            }
                          }

                          print(chatsByDate);

                          return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: chatsByDate.length, //day separator
                              itemBuilder: (context, index){
                                List<ChatModel> imageChatInADay = [];
                                List<ChatModel> videoChatInADay = [];
                                List<ChatModel> docsChatInADay = [];
                                List<ChatModel> meetsChatInADay = [];
                                List<ChatModel> projectChatInADay = [];
                                Set<ChatType> chatTypeInADay = Set();

                                chatsByDate.forEach((chatsInADay) {
                                  chatsInADay.forEach((chat) {
                                    chatTypeInADay.add(chat.type);

                                    chatTypeInADay.forEach((chatType) {
                                      if(chat.type == chatType){
                                        if(chatType == ChatType.image){
                                          imageChatInADay.add(chat);
                                        } else if(chatType == ChatType.video){
                                          videoChatInADay.add(chat);
                                        } else if(chatType == ChatType.docs){
                                          docsChatInADay.add(chat);
                                        } else if(chatType == ChatType.meets){
                                          meetsChatInADay.add(chat);
                                        } else if(chatType == ChatType.project){
                                          projectChatInADay.add(chat);
                                        }
                                      }
                                    });
                                  });
                                });

                                return Text("a");
                              },
                            )
                          : SizedBox();
                        }
                      ),
                      StreamBuilder<List<ChatModel>>(
                        stream: _chatProvider.handlesChats(widget.handlesID),
                        builder: (context, snapshot) {

                          List<List<ChatModel>> chatsByDate = [];
                          Set<String> mediaChatTimestamps = Set();

                          if(snapshot.hasData){
                            snapshot.data!.forEach((element) {
                              if(element.mediaURL != "" && element.deletedBy.indexOf(widget.currentUserID) < 0){
                                mediaChatTimestamps.add(element.timestamp.toString().substring(0, 10));
                              }
                            });
                          }

                          if(snapshot.hasData){
                            if(mediaChatTimestamps.isNotEmpty){
                              mediaChatTimestamps.forEach((date) {
                                List<ChatModel> dayChats = [];
                                snapshot.data!.forEach((chat){
                                  if(chat.timestamp.toString().substring(0, 10) == date && chat.mediaURL != "" && chat.deletedBy.indexOf(widget.currentUserID) < 0){
                                    dayChats.add(chat);
                                  }
                                });
                                chatsByDate.add(dayChats);
                              });
                            }
                          }

                          print(chatsByDate);

                          return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: chatsByDate.length, //day separator
                              itemBuilder: (context, index){
                                List<ChatModel> imageChatInADay = [];
                                List<ChatModel> videoChatInADay = [];
                                List<ChatModel> docsChatInADay = [];
                                List<ChatModel> meetsChatInADay = [];
                                List<ChatModel> projectChatInADay = [];
                                Set<ChatType> chatTypeInADay = Set();

                                chatsByDate.forEach((chatsInADay) {
                                  chatsInADay.forEach((chat) {
                                    chatTypeInADay.add(chat.type);

                                    chatTypeInADay.forEach((chatType) {
                                      if(chat.type == chatType){
                                        if(chatType == ChatType.image){
                                          imageChatInADay.add(chat);
                                        } else if(chatType == ChatType.video){
                                          videoChatInADay.add(chat);
                                        } else if(chatType == ChatType.docs){
                                          docsChatInADay.add(chat);
                                        } else if(chatType == ChatType.meets){
                                          meetsChatInADay.add(chat);
                                        } else if(chatType == ChatType.project){
                                          projectChatInADay.add(chat);
                                        }
                                      }
                                    });
                                  });
                                });

                                return Text("a");
                              },
                            )
                          : SizedBox();
                        }
                      ),
                    ],
                  ),
                );
              },
              loading: () => AppBar(),
              error: (_,__) => AppBar(),
            );
          }
        ),
      )
    );
  }
}