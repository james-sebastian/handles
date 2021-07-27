part of "../pages.dart";

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  
  String searchKey = "";
  bool isHandlesSelected = false;
  bool isSearchActive = false;
  int isFilterChipSelected = -1;
  int activePage = 0;
  Set<String> selectedHandles = Set();
  Set<String> selectedPinnedHandles = Set();
  late TabController _tabController;

  @override
  void initState() { 
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(selectedHandles.length == 0 && selectedPinnedHandles.length == 0){
      setState(() {
        isHandlesSelected = false;
      });
    }

    print(searchKey);

    // Future<bool?> askNotificationPermission() async {
    //   final bool? result = await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    //     alert: true,
    //     badge: true,
    //     sound: true,
    //   );
      
    //   return result;
    // }

    return Consumer(
      builder: (context, watch, _){

        final _currentUserProvider = watch(currentUserProvider);
        final _handlesProvider = watch(handlesProvider);
        final _chatProvider = watch(chatProvider);
        final _userProvider = watch(userProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              backgroundColor: Palette.secondary,
              child: AdaptiveIcon(
                android: Icons.add,
                iOS: CupertinoIcons.add,
                color: Colors.white, size: 28,
              ),
              onPressed: (){
                Get.to(() => HandlesCreatorPage(), transition: Transition.cupertino);
              },
            ),
            appBar: AppBar(
              elevation: isSearchActive ? 0 : 2.5,
              backgroundColor: Palette.primary,
              toolbarHeight: isSearchActive ? MQuery.height(0.07, context) : MQuery.height(0.125, context),
              leadingWidth: isHandlesSelected || isSearchActive
                ? MQuery.width(0.065, context)
                : MQuery.width(0, context),
              leading: isHandlesSelected || isSearchActive
                ? IconButton(
                    onPressed: (){
                      if(isSearchActive){
                        setState(() {
                          isSearchActive = false;
                          searchKey = "";
                        });
                      } else {
                        setState(() {
                          isHandlesSelected = false;
                          if(selectedPinnedHandles.isNotEmpty){
                            selectedPinnedHandles = Set();
                          } else {
                            selectedHandles = Set();
                          }
                        });
                      }
                    },
                    icon: AdaptiveIcon(
                      android: Icons.arrow_back,
                      iOS: CupertinoIcons.back,
                    ),
                  )
                : SizedBox(width: 0),
              title: isHandlesSelected
                ? FadeIn(
                    child: Font.out(
                      selectedPinnedHandles.isNotEmpty
                      ? "${selectedPinnedHandles.length}"
                      : "${selectedHandles.length}",
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  )
                : isSearchActive
                  ? FadeIn(
                      child: Container(
                        width: MQuery.width(0.35, context),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search anything...",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 20,
                            )
                          ),
                          onChanged: (value){
                            setState(() {
                              searchKey = value;
                            });
                          }
                        )
                      )
                    )
                  : FadeIn(
                      child: Font.out(
                        "Handles",
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
              actions: [
                isHandlesSelected
                ? _tabController.index == 0
                  ? FadeIn(
                      child: Row(
                        children: [
                          IconButton(
                            icon: AdaptiveIcon(
                              android: Icons.delete,
                              iOS: CupertinoIcons.trash,
                            ),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context){
                                  return Platform.isAndroid
                                  ? AlertDialog(
                                      title: Text(
                                        "Are you sure you want to delete these Handles?",
                                      ),
                                      content: Text(
                                        "This action is irreversible and will make you leave this Handles without deleting the actual one"
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
                                            if(selectedPinnedHandles.isNotEmpty){
                                              _handlesProvider.deleteHandles(selectedPinnedHandles.toList());
                                            } else {
                                              _handlesProvider.deleteHandles(selectedHandles.toList());
                                            }
                                            setState(() {
                                              if(selectedPinnedHandles.isNotEmpty){
                                                selectedPinnedHandles = Set();
                                              } else {
                                                selectedHandles = Set();
                                              }
                                            });
                                            Get.back();
                                          },
                                        )
                                      ],
                                    )
                                  : CupertinoAlertDialog(
                                      title: Text(
                                        "Are you sure you want to delete this Handles?",
                                      ),
                                      content: Text(
                                        "This action is irreversible and will make you leave this Handles without deleting the actual one"
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
                                            Get.back();
                                          },
                                        )
                                      ],
                                    );
                                }
                              );
                            },
                          ),
                          IconButton(
                            tooltip: "Pin Handles",
                            icon: AdaptiveIcon(
                              android: Icons.push_pin,
                              iOS: CupertinoIcons.pin_fill,
                            ),
                            onPressed: (){
                              if(selectedPinnedHandles.isNotEmpty){
                                _handlesProvider.unpinHandles(selectedPinnedHandles.toList());
                                setState(() {
                                  selectedPinnedHandles = Set();
                                });
                              } else {
                                _handlesProvider.pinHandles(selectedHandles.toList());
                                setState(() {
                                  selectedHandles = Set();
                                });
                              }
                            }
                          ),
                          IconButton(
                            tooltip: "Archive",
                            icon: AdaptiveIcon(
                              android: Icons.archive,
                              iOS: CupertinoIcons.archivebox_fill,
                            ),
                            onPressed: (){
                              _handlesProvider.archiveHandles(selectedHandles.toList());
                              setState(() {
                                selectedHandles = Set();
                              });
                              Fluttertoast.showToast(
                                msg: "${selectedHandles.length} archived",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                            }
                          ),
                        ],
                      ),
                    )
                  : FadeIn(
                      child: Row(
                        children: [
                          IconButton(
                            icon: AdaptiveIcon(
                              android: Icons.delete,
                              iOS: CupertinoIcons.trash,
                            ),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context){
                                  return Platform.isAndroid
                                  ? AlertDialog(
                                      title: Text(
                                        "Are you want to delete your call logs?",
                                      ),
                                      content: Text(
                                        "This action is irreversible"
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
                                            //TODO: DELETION LOGIC...
                                            Get.back();
                                          },
                                        )
                                      ],
                                    )
                                  : CupertinoAlertDialog(
                                      title: Text(
                                        "Are you want to delete your call logs?",
                                      ),
                                      content: Text(
                                        "This action is irreversible"
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
                                            Get.back();
                                          },
                                        )
                                      ],
                                    );
                                }
                              );
                            },
                          ),
                        ],
                      ),
                    )
                : isSearchActive
                  ? FadeIn(
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: "Search",
                            icon: AdaptiveIcon(
                              android: Icons.search,
                              iOS: CupertinoIcons.search,
                            ),
                            onPressed: (){}
                          ),
                        ]
                      ),
                    )
                  : FadeIn(
                      child: Row(
                        children: [
                        IconButton(
                            tooltip: "Search",
                            icon: AdaptiveIcon(
                              android: Icons.search,
                              iOS: CupertinoIcons.search,
                            ),
                            onPressed: (){
                              setState(() {
                                isSearchActive = true;
                              });
                            }
                          ),
                          IconButton(
                            tooltip: "Settings",
                            icon: AdaptiveIcon(
                              android: Icons.more_vert_rounded,
                              iOS: CupertinoIcons.ellipsis,
                            ),
                            onPressed: (){
                              Get.to(() => SettingsPage(), transition: Transition.cupertino);
                            }
                          ),
                        ],
                      ),
                    )
              ],
              bottom: isSearchActive
              ? PreferredSize(child: SizedBox(), preferredSize: Size.fromHeight(0))
              : TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: "CHATS"),
                    Tab(text: "CALLS"),
                  ],
                )
            ),
            body: _currentUserProvider.when(
              data: (user){
                return TabBarView(
                  controller: _tabController,
                  children: [
                    !(user.handlesList!.first == "" && user.handlesList!.length > 1)
                    ? EmptyHandles(
                        isHandlesPage: true
                      )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isSearchActive
                        ? SingleChildScrollView(
                            child: Container(
                              height: MQuery.height(0.8, context),
                              child: Column(
                                children: [
                                  StreamBuilder<List<HandlesModel>>(
                                    stream: _handlesProvider.handlesModelSearcher(searchKey),
                                    builder: (context, snapshot) {
                                      return snapshot.hasData
                                      ? Flexible(
                                        child: Container(
                                          child: ListView.builder(
                                            itemCount: ((snapshot.data!.length / 100) + 1).round(),
                                            itemBuilder: (context, index){
                                              return StreamBuilder<List<ChatModel>>(
                                                  stream: _chatProvider.handlesChats(snapshot.data![index].id),
                                                  builder: (context, chatList) {
                                                    int newMessages = 0;

                                                    if(chatList.hasData){
                                                      chatList.data!.forEach((element) {
                                                        if(element.readBy.indexOf(user.id) <= 0 && element.deletedBy.indexOf(user.id) <= 0){
                                                          newMessages++;
                                                        }
                                                      });
                                                    }
                                                    
                                                    return chatList.hasData && chatList.data!.isNotEmpty
                                                    ? ListTile(
                                                        onLongPress: (){
                                                          setState(() {
                                                            isHandlesSelected = true;
                                                            if(snapshot.data![index].pinnedBy!.indexOf(user.id) >= 0){
                                                              selectedPinnedHandles.add(user.handlesList![index + 1]);
                                                            } else {
                                                              selectedHandles.add(user.handlesList![index + 1]);
                                                            }
                                                          });
                                                        },
                                                        onTap: (){
                                                          if(isHandlesSelected){
                                                            if(snapshot.data![index].pinnedBy!.indexOf(user.id) >= 0){
                                                              if(selectedPinnedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                                                setState(() {
                                                                  selectedPinnedHandles.add(user.handlesList![index + 1]);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  selectedPinnedHandles.remove(user.handlesList![index + 1]);
                                                                });
                                                              }
                                                            } else {
                                                              if(selectedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                                                setState(() {
                                                                  selectedHandles.add(user.handlesList![index + 1]);
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  selectedHandles.remove(user.handlesList![index + 1]);
                                                                });
                                                              }
                                                            }
                                                          } else {
                                                            Get.to(() => HandlesPage(
                                                              handlesID: user.handlesList![index + 1]
                                                            ), transition: Transition.cupertino);
                                                          }
                                                        },
                                                        contentPadding: EdgeInsets.fromLTRB(
                                                          MQuery.width(0.02, context),
                                                          index >= 1 ? MQuery.height(0.005, context) : MQuery.height(0.01, context),
                                                          MQuery.width(0.02, context),
                                                          MQuery.height(0.005, context),
                                                        ),
                                                        leading: Stack(
                                                          alignment: Alignment.bottomRight,
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor: Palette.primary,
                                                              radius: MQuery.height(0.025, context),
                                                              backgroundImage: NetworkImage(snapshot.data![index].cover)
                                                            ),
                                                            selectedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0 || selectedPinnedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0
                                                            ? ZoomIn(
                                                                duration: Duration(milliseconds: 100),
                                                                child: Positioned(
                                                                  child: CircleAvatar(
                                                                    radius: 10,
                                                                    child: Icon(Icons.check, size: 12, color: Colors.white),
                                                                    backgroundColor: Palette.secondary
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox()
                                                          ],
                                                        ),
                                                        title: Font.out(
                                                          snapshot.data![index].name,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          textAlign: TextAlign.start
                                                        ),
                                                        subtitle: FutureBuilder<UserModel>(
                                                          future: _userProvider.getUserByID(chatList.data!.last.sender),
                                                          builder: (context, snapshot) {
                                                            return snapshot.hasData
                                                            ? Font.out(
                                                                "${snapshot.data!.id == chatList.data!.last.sender
                                                                    ? "You:"
                                                                    : snapshot.data!.name.split(" ").first + ":"
                                                                } ${
                                                                  chatList.data!.last.type == ChatType.plain
                                                                  ? chatList.data!.last.content!.length >= 24
                                                                    ? chatList.data!.last.content!.substring(0, 24) + "..."
                                                                    : chatList.data!.last.content
                                                                  : chatList.data!.last.type == ChatType.image
                                                                  ? "[Image]"
                                                                  : chatList.data!.last.type == ChatType.video
                                                                  ? "[Video]"
                                                                  : chatList.data!.last.type == ChatType.docs
                                                                  ? "[Docs]"
                                                                  : chatList.data!.last.type == ChatType.meets
                                                                  ? "[Meets]"
                                                                  : chatList.data!.last.type == ChatType.project
                                                                  ? "[Project]"
                                                                  : chatList.data!.last.content!.length >= 24
                                                                    ? chatList.data!.last.content!.substring(0, 24) + "..."
                                                                    : chatList.data!.last.content
                                                                }",
                                                                fontSize: 14,
                                                                fontWeight: chatList.data!.last.readBy.indexOf(user.id) >= 0
                                                                ? FontWeight.w400
                                                                : FontWeight.w600,
                                                                textAlign: TextAlign.start,
                                                                color: chatList.data!.last.readBy.indexOf(user.id) >= 0
                                                                ? Colors.black.withOpacity(0.75)
                                                                : Colors.black
                                                              )
                                                            : SizedBox();
                                                          }
                                                        ),
                                                        trailing: Container(
                                                          width: MQuery.width(0.08, context),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Font.out(
                                                                DateFormat.jm().format(chatList.data!.last.timestamp),
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400,
                                                                textAlign: TextAlign.start,
                                                                color: Colors.black.withOpacity(0.75)
                                                              ),
                                                              if (index >= 1)
                                                                SizedBox()
                                                              else Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  snapshot.data![index].pinnedBy!.indexOf(user.id) >= 0
                                                                  ? Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        newMessages == 0
                                                                        ? Container(
                                                                            decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Palette.secondary
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "$newMessages",
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Colors.white
                                                                                ) 
                                                                              ),
                                                                            ),
                                                                            height: 22.5,
                                                                            width: 22.5
                                                                          )
                                                                        : SizedBox(),
                                                                        SizedBox(width: MQuery.width(0.01, context)),
                                                                        AdaptiveIcon(
                                                                          android: Icons.push_pin,
                                                                          iOS: CupertinoIcons.pin_fill,
                                                                          size: 20
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : newMessages == 0
                                                                    ? Container(
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: Palette.secondary
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "$newMessages",
                                                                            textAlign: TextAlign.start,
                                                                            style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.white
                                                                            ) 
                                                                          ),
                                                                        ),
                                                                        height: 22.5,
                                                                        width: 22.5
                                                                      )
                                                                    : SizedBox(),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      )
                                                    : SizedBox();
                                                  }
                                                );
                                            },
                                          )
                                        ),
                                      )
                                      : SizedBox();
                                    }
                                  ),
                                ],
                              ),
                            ),
                        )
                        : SizedBox(),
                        isSearchActive
                        ? SizedBox()
                        : Expanded(
                          child: Column(
                            children: [
                              SubscriptionBanner(),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  child: ListView.builder(
                                    itemCount: user.handlesList!.length - 1,
                                    itemBuilder: (context, index){

                                      final _singleHandlesProvider = watch(singleHandlesProvider(user.handlesList![index + 1]));

                                      return _singleHandlesProvider.when(
                                        data: (handles){

                                          print(handles);

                                          return handles.archivedBy!.indexOf(user.id) >= 0
                                          ? SizedBox()
                                          : StreamBuilder<List<ChatModel>>(
                                              stream: _chatProvider.handlesChats(handles.id),
                                              builder: (context, chatList) {
                                                int newMessages = 0;

                                                if(chatList.hasData){
                                                  chatList.data!.forEach((element) {
                                                    if(element.readBy.indexOf(user.id) <= 0 && element.deletedBy.indexOf(user.id) <= 0){
                                                      newMessages++;
                                                    }
                                                  });
                                                }
                                                
                                                return chatList.hasData && chatList.data!.isNotEmpty
                                                ? ListTile(
                                                    onLongPress: (){
                                                      setState(() {
                                                        isHandlesSelected = true;
                                                        if(handles.pinnedBy!.indexOf(user.id) >= 0){
                                                          selectedPinnedHandles.add(user.handlesList![index + 1]);
                                                        } else {
                                                          selectedHandles.add(user.handlesList![index + 1]);
                                                        }
                                                      });
                                                    },
                                                    onTap: (){
                                                      if(isHandlesSelected){
                                                        if(handles.pinnedBy!.indexOf(user.id) >= 0){
                                                          if(selectedPinnedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                                            setState(() {
                                                              selectedPinnedHandles.add(user.handlesList![index + 1]);
                                                            });
                                                          } else {
                                                            setState(() {
                                                              selectedPinnedHandles.remove(user.handlesList![index + 1]);
                                                            });
                                                          }
                                                        } else {
                                                          if(selectedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                                            setState(() {
                                                              selectedHandles.add(user.handlesList![index + 1]);
                                                            });
                                                          } else {
                                                            setState(() {
                                                              selectedHandles.remove(user.handlesList![index + 1]);
                                                            });
                                                          }
                                                        }
                                                      } else {
                                                        Get.to(() => HandlesPage(
                                                          handlesID: user.handlesList![index + 1]
                                                        ), transition: Transition.cupertino);
                                                      }
                                                    },
                                                    contentPadding: EdgeInsets.fromLTRB(
                                                      MQuery.width(0.02, context),
                                                      index >= 1 ? MQuery.height(0.005, context) : MQuery.height(0.01, context),
                                                      MQuery.width(0.02, context),
                                                      MQuery.height(0.005, context),
                                                    ),
                                                    leading: Stack(
                                                      alignment: Alignment.bottomRight,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor: Palette.primary,
                                                          radius: MQuery.height(0.025, context),
                                                          backgroundImage: NetworkImage(handles.cover)
                                                        ),
                                                        selectedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0 || selectedPinnedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0
                                                        ? ZoomIn(
                                                            duration: Duration(milliseconds: 100),
                                                            child: Positioned(
                                                              child: CircleAvatar(
                                                                radius: 10,
                                                                child: Icon(Icons.check, size: 12, color: Colors.white),
                                                                backgroundColor: Palette.secondary
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                                      ],
                                                    ),
                                                    title: Font.out(
                                                      handles.name,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      textAlign: TextAlign.start
                                                    ),
                                                    subtitle: FutureBuilder<UserModel>(
                                                      future: _userProvider.getUserByID(chatList.data!.last.sender),
                                                      builder: (context, snapshot) {
                                                        return snapshot.hasData
                                                        ? Font.out(
                                                            "${snapshot.data!.id == chatList.data!.last.sender
                                                                ? "You:"
                                                                : snapshot.data!.name.split(" ").first + ":"
                                                            } ${
                                                              chatList.data!.last.type == ChatType.plain
                                                              ? chatList.data!.last.content!.length >= 24
                                                                ? chatList.data!.last.content!.substring(0, 24) + "..."
                                                                : chatList.data!.last.content
                                                              : chatList.data!.last.type == ChatType.image
                                                              ? "[Image]"
                                                              : chatList.data!.last.type == ChatType.video
                                                              ? "[Video]"
                                                              : chatList.data!.last.type == ChatType.docs
                                                              ? "[Docs]"
                                                              : chatList.data!.last.type == ChatType.meets
                                                              ? "[Meets]"
                                                              : chatList.data!.last.type == ChatType.project
                                                              ? "[Project]"
                                                              : chatList.data!.last.content!.length >= 24
                                                                ? chatList.data!.last.content!.substring(0, 24) + "..."
                                                                : chatList.data!.last.content
                                                            }",
                                                            fontSize: 14,
                                                            fontWeight: chatList.data!.last.readBy.indexOf(user.id) >= 0
                                                            ? FontWeight.w400
                                                            : FontWeight.w600,
                                                            textAlign: TextAlign.start,
                                                            color: chatList.data!.last.readBy.indexOf(user.id) >= 0
                                                            ? Colors.black.withOpacity(0.75)
                                                            : Colors.black
                                                          )
                                                        : SizedBox();
                                                      }
                                                    ),
                                                    trailing: Container(
                                                      width: MQuery.width(0.08, context),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Font.out(
                                                            DateFormat.jm().format(chatList.data!.last.timestamp),
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w400,
                                                            textAlign: TextAlign.start,
                                                            color: Colors.black.withOpacity(0.75)
                                                          ),
                                                          if (index >= 1)
                                                            SizedBox()
                                                          else Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              handles.pinnedBy!.indexOf(user.id) >= 0
                                                              ? Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    newMessages == 0
                                                                    ? Container(
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: Palette.secondary
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "$newMessages",
                                                                            textAlign: TextAlign.start,
                                                                            style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.white
                                                                            ) 
                                                                          ),
                                                                        ),
                                                                        height: 22.5,
                                                                        width: 22.5
                                                                      )
                                                                    : SizedBox(),
                                                                    SizedBox(width: MQuery.width(0.01, context)),
                                                                    AdaptiveIcon(
                                                                      android: Icons.push_pin,
                                                                      iOS: CupertinoIcons.pin_fill,
                                                                      size: 20
                                                                    ),
                                                                  ],
                                                                )
                                                              : newMessages == 0
                                                                ? Container(
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: Palette.secondary
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        "$newMessages",
                                                                        textAlign: TextAlign.start,
                                                                        style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w400,
                                                                          color: Colors.white
                                                                        ) 
                                                                      ),
                                                                    ),
                                                                    height: 22.5,
                                                                    width: 22.5
                                                                  )
                                                                : SizedBox(),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  )
                                                : SizedBox();
                                              }
                                            );
                                        },
                                        loading: () => SizedBox(),
                                        error: (object, error){
                                          print(error);
                                          return SizedBox();
                                        }
                                      );
                                    }
                                  )
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.to(() => ArchivedHandles(), transition: Transition.cupertino);
                                    },
                                    child: Text(
                                      "Archived Handles",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        color: Palette.primary
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    

                    //
                    ///-CALL PAGE-//
                    //


                    user.handlesList!.isEmpty
                    ? EmptyHandles(isHandlesPage: false)
                    : ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index){
                        return Column(
                          children: [
                            ListTile(
                              onLongPress: (){
                                setState(() {
                                  isHandlesSelected = true;
                                  selectedHandles.add(user.handlesList![index + 1]);
                                });
                              },
                              onTap: (){
                                if(isHandlesSelected){
                                  if(selectedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                    setState(() {
                                      selectedHandles.add(user.handlesList![index + 1]);
                                    });
                                  } else {
                                    setState(() {
                                      selectedHandles.remove(user.handlesList![index + 1]);
                                    });
                                  }
                                } else {
                                  Get.to(() => DetailedCallPage(), transition: Transition.cupertino);
                                }
                              },
                              contentPadding: EdgeInsets.fromLTRB(
                                MQuery.width(0.02, context),
                                index >= 1 ? 0 : MQuery.height(0.01, context),
                                MQuery.width(0.01, context),
                                0,
                              ),
                              leading: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Palette.primary,
                                    radius: MQuery.height(0.025, context),
                                  ),
                                  selectedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0
                                  ? ZoomIn(
                                      duration: Duration(milliseconds: 100),
                                      child: Positioned(
                                        child: CircleAvatar(
                                          backgroundColor: Palette.secondary,
                                          radius: 10,
                                          child: Icon(Icons.check, size: 12, color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                                ],
                              ),
                              title: Font.out(
                                "Handles DevTeam",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start
                              ),
                              subtitle: Row(
                                children: [
                                  //TODO: PHONE STATUS LOGIC
                                  AdaptiveIcon(
                                    android: Icons.call_made,
                                    iOS: CupertinoIcons.phone_fill_arrow_down_left,
                                    size: 14,
                                    color: Palette.secondary,
                                  ),
                                  SizedBox(width: MQuery.width(0.0075, context)),
                                  Font.out(
                                    "June 16, 7:43 AM",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.start,
                                    color: Colors.black.withOpacity(0.75)
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: (){},
                                icon: AdaptiveIcon(
                                  android: Icons.call,
                                  iOS: CupertinoIcons.phone_fill,
                                  color: Palette.primary,
                                ),
                              )
                            ),
                            Divider(),
                          ],
                        );
                      }
                    ),
                  ],
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
            ),
          ),
        );
      }
    );
  }
}