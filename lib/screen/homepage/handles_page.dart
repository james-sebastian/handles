part of "../pages.dart";

class HandlesPage extends StatefulWidget {

  final String handlesID;
  const HandlesPage({ Key? key, required this.handlesID }) : super(key: key);

  @override
  _HandlesPageState createState() => _HandlesPageState();
}

class _HandlesPageState extends State<HandlesPage> {

  late ItemScrollController _scrollController;
  TextEditingController chatController = TextEditingController();
  bool isSearchActive = false;
  bool isChatSelected = false;
  bool isChatting = false;
  bool isScrolled = false;
  ChatModel? isReplying;
  int isFilterChipSelected = -1;
  int lineCount = 4;
  int pinnedMinus = 1;
  Set<int> selectedChatIndex = Set();

  void scrollToBottom(int bottomIndex) {
    _scrollController.jumpTo(
      index: bottomIndex
    );
  }

  void scrollToTargetFromChild(int targetIndex){
    _scrollController.scrollTo(
      index: targetIndex,
      duration: Duration(milliseconds: 250)
    );
  }

  @override
  void initState() {
    _scrollController = ItemScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    List<String> keys = [
      "Photos",
      "Videos",
      "Docs",
      "Meetings",
      "Services",
    ];

    void selectChat(int index){
      setState(() {
        isChatSelected = true;
        selectedChatIndex.add(index);
      });
    }

    void chatOnTap(int index){
      if(isChatSelected){
        if(selectedChatIndex.toList().indexOf(index) >= 0){
          setState(() {
            selectedChatIndex.remove(index);
          });
        } else {
          setState(() {
            selectedChatIndex.add(index);
          });
        }
      }
    }

    if(selectedChatIndex.isEmpty){
      setState(() {
        isChatSelected = false;
      });
    }

    if(isKeyboardOpen){
      setState((){
        isChatting = true;
      });
    } else {
      setState((){
        isChatting = false;
      });
    }

    return Consumer(
      builder: (ctx, watch,child) {

        final _chatProvider = watch(chatProvider);
        final _currentUserProvider = watch(currentUserProvider);
        final _chatListProvider = watch(chatListProvider(widget.handlesID));
        final _userProvider = watch(userProvider);
        final _singleHandlesProvider = watch(singleHandlesProvider(widget.handlesID));

        Future<List<UserModel>> getUserModelFromList(List<String> usersID) async{
          List<UserModel> userModel = [];
          usersID.forEach((id) {
            watch(userProvider).getUserByID(id).then((value){
              userModel.add(value);
            });
          });
          return userModel;
        }

        return _singleHandlesProvider.when(
          data: (handles){
            return _currentUserProvider.when(
              data: (currentUser){
                return Scaffold(
                  backgroundColor: Palette.handlesBackground,
                  appBar: AppBar(
                    elevation: isSearchActive ? 0 : 1,
                    toolbarHeight: MQuery.height(0.075, context),
                    leadingWidth: !isChatSelected 
                    ? MQuery.width(0.085, context)
                    : 0,
                    leading: !isChatSelected
                    ? Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            AdaptiveIcon(
                              android: Icons.arrow_back,
                              iOS: CupertinoIcons.back,
                            ),
                            SizedBox(width: MQuery.width(0.005, context)),
                            Hero(
                              tag: "handles_picture",
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: handles.cover != ""
                                ? NetworkImage(handles.cover) as ImageProvider
                                : AssetImage("assets/handles_logo.png"),
                                radius: MQuery.height(0.0215, context),
                              ),
                            )
                          ],
                        ),
                        onTap: (){
                          if(isSearchActive){
                            setState(() {
                              isSearchActive = false;
                            }); 
                          } else {
                            Get.back();
                          }
                        },
                      ),
                    )
                    : SizedBox(),
                    title: isSearchActive
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
                                fontSize: 18,
                              )
                            ),
                          )
                        )
                      )
                    : isChatSelected
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Font.out(
                          "${selectedChatIndex.length} selected",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                          color: Colors.white
                        )
                      )
                    : FutureBuilder<List<UserModel>>(
                        future: getUserModelFromList(handles.members.keys.toList()),
                        builder: (context, snapshot){
                          return snapshot.hasData
                          ? ListTile(
                              onTap: (){
                                Get.to(() => HandlesDetailedPage());
                              },
                              contentPadding: EdgeInsets.fromLTRB(
                                MQuery.width(0, context),
                                MQuery.height(0.01, context),
                                MQuery.width(0, context),
                                MQuery.height(0.0075, context),
                              ),
                              title: Font.out(
                                handles.name,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start,
                                color: Colors.white
                              ),
                              subtitle: Row(
                                children: List.generate(snapshot.data!.length > 4 ? 4 : snapshot.data!.length, (index){
                                  return index < 4
                                  ? Font.out(
                                      snapshot.data![index].name.split(" ")[0] == currentUser.name.split(" ")[0]
                                      ? "You, "
                                      : snapshot.data![index].name.split(" ")[0] + ", ",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.start,
                                      color: Colors.white.withOpacity(0.75)
                                    )
                                  : Font.out(
                                    "...",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.start,
                                    color: Colors.white.withOpacity(0.75)
                                  );
                                })
                              )
                            )
                          : SizedBox();
                        }
                    ),
                    actions: [
                      if (isSearchActive)
                        IconButton(
                          tooltip: "Search",
                          icon: AdaptiveIcon(
                            android: Icons.search,
                            iOS: CupertinoIcons.search
                          ),
                          onPressed: (){
                            if(!isSearchActive){
                              setState(() {
                                isSearchActive = true;
                              });
                            } else {
                              //TODO: SEARCH MECHANISM HERE
                            }
                          }
                        )
                      else
                        if(isChatSelected)
                          _chatListProvider.when(
                            data: (chats){
                              return Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    tooltip: "Forward Message",
                                    icon: AdaptiveIcon(
                                      android: Icons.arrow_right_alt,
                                      iOS: CupertinoIcons.arrow_turn_up_right,
                                    ),
                                    onPressed: (){
                                      List<ChatModel> selectedChat = [];
                                      selectedChatIndex.forEach((element) {
                                        selectedChat.add(chats[element]);
                                      });
                                      Get.to(() => ForwardMessagePage(
                                        originHandlesID: handles.id,
                                        selectedMessages: selectedChat,
                                      ), transition: Transition.cupertino);
                                    }
                                  ),
                                  IconButton(
                                    tooltip: "Delete Message",
                                    icon: AdaptiveIcon(
                                      android: Icons.delete,
                                      iOS: CupertinoIcons.trash,
                                    ),
                                    onPressed: (){
                                      selectedChatIndex.forEach((element) {
                                        List<String> newDeletedBy = chats[element].deletedBy;
                                        newDeletedBy.add(currentUser.id);
                                        _chatProvider.deleteChat(handles.id, chats[element].id, newDeletedBy).then((value){
                                          setState(() {
                                            isChatSelected = false;
                                            selectedChatIndex = Set();
                                          });
                                        });
                                      });
                                    }
                                  ),
                                  handles.members[currentUser.id] == "Admin"
                                  ? IconButton(
                                      icon: AdaptiveIcon(
                                        android: Icons.push_pin,
                                        iOS: CupertinoIcons.pin_fill,
                                        size: 20
                                      ),
                                      onPressed: (){
                                        selectedChatIndex.forEach((element) {
                                          bool newIsPinned = !(chats[element].isPinned);
                                          _chatProvider.pinChat(handles.id, chats[element].id, newIsPinned).then((value){
                                            setState(() {
                                              isChatSelected = false;
                                              selectedChatIndex = Set();
                                            });
                                          });
                                        });
                                      }
                                    )
                                  : SizedBox(),
                                  selectedChatIndex.length == 1
                                  ? IconButton(
                                      padding: EdgeInsets.zero,
                                      tooltip: "Reply Message",
                                      icon: AdaptiveIcon(
                                        android: Icons.reply,
                                        iOS: CupertinoIcons.reply_thick_solid,
                                      ),
                                      onPressed: (){
                                        // print(chats[selectedChatIndex.first].content);
                                        setState(() {
                                          isReplying = chats[selectedChatIndex.first];
                                          isChatSelected = false;
                                          selectedChatIndex = Set();
                                        });
                                      }
                                    )
                                  : SizedBox(),
                                  selectedChatIndex.length == 1 && chats[selectedChatIndex.first].sender == currentUser.id
                                  ? IconButton(
                                      tooltip: "Message Info",
                                      icon: AdaptiveIcon(
                                        android: Icons.info_outline_rounded,
                                        iOS: CupertinoIcons.info_circle
                                      ),
                                      onPressed: (){
                                        Get.bottomSheet(
                                          MessageInfoBottomSheet(
                                            index: selectedChatIndex.first,
                                            chatModel: chats[selectedChatIndex.first]
                                          )
                                        );
                                      }
                                    )
                                  : SizedBox()
                                ]
                              );
                            },
                            loading: (){
                              return SizedBox();
                            },
                            error: (object , error){
                              return SizedBox();
                            }
                          )
                        else
                          Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                tooltip: "Make a Group Call",
                                icon: AdaptiveIcon(
                                  android: Icons.add_call,
                                  iOS: CupertinoIcons.phone_solid,
                                ),
                                onPressed: (){}
                              ),
                              IconButton(
                                tooltip: "Search",
                                icon: AdaptiveIcon(
                                  android: Icons.search,
                                  iOS: CupertinoIcons.search
                                ),
                                onPressed: (){
                                  setState(() {
                                    isSearchActive = true;
                                  });
                                }
                              ),
                            ]
                          )
                    ],
                  ),
                  body: _chatListProvider.when(
                    data: (chatList){

                      if(!isChatSelected && isScrolled == false){
                        WidgetsBinding.instance!.addPostFrameCallback((_){
                          scrollToBottom(chatList.length);
                          setState(() {
                            isScrolled = true;
                          });
                        });
                      }

                      return Column(
                        children: [
                          if (isSearchActive)
                          Container(
                            color: Palette.primary,
                            width: MQuery.width(1, context),
                            height: MQuery.height(0.075, context),
                            padding: EdgeInsets.symmetric(
                              vertical: MQuery.height(0.01 ,context),
                              horizontal: MQuery.width(0.0225, context)
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: Constants.filterList.map((e){
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0
                                  ),
                                  child: FilterChip(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 5,
                                      bottom: 5
                                    ),
                                    shape: StadiumBorder(side: BorderSide(
                                      color: Constants.filterList.indexOf(e) == isFilterChipSelected
                                      ? Palette.filterSelected
                                      : Palette.filterSelected.withOpacity(0.25)
                                    )),
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Palette.primary,
                                    selectedColor: Palette.filterSelected,
                                    elevation: 0,
                                    showCheckmark: false,
                                    avatar: Constants.filterAvatar[e],
                                    label: Text(e),
                                    labelStyle: TextStyle(
                                      color: Colors.white
                                    ),
                                    selected: Constants.filterList.indexOf(e) == isFilterChipSelected,
                                    onSelected: (bool selected) {
                                      Constants.filterList.indexOf(e) != isFilterChipSelected
                                      ? setState((){
                                          isFilterChipSelected = Constants.filterList.indexOf(e);
                                        })
                                      : setState((){
                                          isFilterChipSelected = -1;
                                        });
                                    },
                                  ),
                                );
                              }).toList().cast<Widget>()        
                            ),
                          ) else
                          SizedBox(),
                          isKeyboardOpen
                          ? SizedBox()
                          : Builder(
                            builder: (context){

                              List<ChatModel> pinnedChats = [];
                              List<int> pinnedChatsIndex = [];

                              for (var i = 0; i < chatList.length; i++) {
                                if(chatList[i].isPinned == true){
                                  pinnedChats.add(chatList[i]);
                                  pinnedChatsIndex.add(i);
                                } 
                              }

                              return pinnedChats.isEmpty
                              ? SizedBox()
                              : Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: (){

                                    _scrollController.scrollTo(
                                      index: pinnedChatsIndex[pinnedChats.length - pinnedMinus],
                                      duration: Duration(milliseconds: 250)
                                    );

                                    if(pinnedMinus == pinnedChats.length){
                                      setState(() {
                                        pinnedMinus = 1;
                                      });
                                    } else {
                                      setState(() {
                                        pinnedMinus++;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: MQuery.width(0.01, context),
                                      right: MQuery.width(0.01, context)
                                    ),
                                    width: MQuery.width(1, context),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Pinned Message #${(pinnedChats.length - pinnedMinus) + 1}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Palette.primary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            FutureBuilder<UserModel>(
                                              future: _userProvider.getUserByID(pinnedChats[pinnedChats.length - pinnedMinus].sender),
                                              builder: (context, snapshot) {

                                                String name = "";
                                                if(snapshot.hasData){
                                                  name = snapshot.data!.name.split(" ")[0] == currentUser.name.split(" ")[0]
                                                  ? "You"
                                                  : snapshot.data!.name.split(" ")[0];
                                                }

                                                int targetIndex = pinnedChats.length - pinnedMinus;

                                                return snapshot.hasData
                                                ? Text(
                                                    pinnedChats[targetIndex].content!.length > 40 && pinnedChats[targetIndex].type == ChatType.plain && pinnedChats[targetIndex].content != ""
                                                    ? "$name: ${pinnedChats[targetIndex].content!.substring(0, 40)}..."
                                                    : pinnedChats[targetIndex].type != ChatType.plain 
                                                      ? "$name: ${
                                                          pinnedChats[targetIndex].type == ChatType.image
                                                          ? "Image"
                                                          : pinnedChats[targetIndex].type == ChatType.image
                                                            ? "Video"
                                                            : "Docs"
                                                        }"
                                                      : "$name: ${pinnedChats[targetIndex].content}",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Colors.black.withOpacity(0.5),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12
                                                    ),
                                                  )
                                                : SizedBox();
                                              }
                                            ),
                                          ] 
                                        ),
                                        AdaptiveIcon(
                                          android: Icons.push_pin,
                                          iOS: CupertinoIcons.pin_fill,
                                          size: 16
                                        ),
                                      ],
                                    )
                                  )
                                )
                              );
                            }
                          ),
                          Expanded(
                            flex: isKeyboardOpen && isReplying != null
                              ? 20
                              : isKeyboardOpen
                              ? 23
                              : isSearchActive
                                ? 45
                                : 48,
                            child: ScrollablePositionedList.builder(
                              itemScrollController: _scrollController,
                              reverse: false,
                              itemCount: chatList.length,
                              itemBuilder: (context, index){

                                ChatModel? replyToModel = chatList[index].replyTo != ""
                                ? chatList.firstWhere((element) => element.id == chatList[index].replyTo)
                                : null;

                                print(replyToModel);

                                return Column(
                                  children: [    
                                    chatList[index].id == chatList.first.id
                                    ? SizedBox()
                                    : chatList[index].id == chatList[1].id
                                      ? HandlesStatusBlock(
                                          isDateBlock: false,
                                          content: DateFormat.yMMMMd('en_US').format(chatList[index].timestamp).toUpperCase()
                                        )
                                      : chatList[index].timestamp.day == DateTime.now().day && !(chatList[index].timestamp.day == chatList[index - 1].timestamp.day)
                                        ? HandlesStatusBlock(
                                            isDateBlock: false,
                                            content: "TODAY"
                                          )
                                        : chatList[index].timestamp.day == DateTime.now().day && (chatList[index].timestamp.day == chatList[index - 1].timestamp.day)
                                          ? SizedBox()
                                          : chatList[index].timestamp.day == DateTime.now().subtract(Duration(days: 1)).day && chatList[index].timestamp.day != chatList[index - 1].timestamp.day
                                            ? HandlesStatusBlock(
                                                isDateBlock: false,
                                                content: "YESTERDAY"
                                              )
                                            : chatList[index].timestamp.day >= DateTime.now().subtract(Duration(days: 2)).day && chatList[index].timestamp.day != chatList[index - 1].timestamp.day
                                              ? HandlesStatusBlock(
                                                  isDateBlock: false,
                                                  content: DateFormat.yMMMMd('en_US').format(chatList[index].timestamp).toUpperCase()
                                                )
                                              : SizedBox(),

                                    chatList[index].type == ChatType.status
                                      ? HandlesStatusBlock(
                                          isDateBlock: true,
                                          content: chatList[index].content ?? ""
                                        )
                                      : chatList[index].type == ChatType.plain
                                      ? PlainChat(
                                          handlesID: handles.id,
                                          chatID: chatList[index].id,
                                          userID: currentUser.id,
                                          index: index,
                                          timestamp: chatList[index].timestamp,
                                          sender: chatList[index].sender,
                                          senderRole: handles.members[chatList[index].sender] == "Members"
                                            ? ""
                                            : handles.members[chatList[index].sender] ?? "",
                                          isRecurring: chatList.first.id == chatList[index].id
                                            ? false
                                            : chatList[index].sender == chatList [index - 1].sender && chatList[index-1].type != ChatType.status,
                                          content: chatList[index].content ?? "",
                                          isPinned: chatList[index].isPinned,
                                          selectChatMethod: selectChat,
                                          chatOnTap: chatOnTap,
                                          selectedChats: selectedChatIndex,
                                          deletedBy: chatList[index].deletedBy,
                                          readBy: chatList[index].readBy,
                                          replyTo: replyToModel,
                                          scrollToTarget: scrollToTargetFromChild,
                                          scrollLocation: replyToModel == null
                                          ? 0
                                          : chatList.indexWhere((element) => element.id == replyToModel.id),
                                        )
                                      : chatList[index].type == ChatType.image
                                      ? ImageChat(
                                          handlesID: handles.id,
                                          chatID: chatList[index].id,
                                          deletedBy: chatList[index].deletedBy,
                                          readBy: chatList[index].readBy,
                                          replyTo: replyToModel,
                                          userID: currentUser.id,
                                          index: index,
                                          timestamp: chatList[index].timestamp,
                                          sender: chatList[index].sender,
                                          senderRole: handles.members[chatList[index].sender] == "Members"
                                            ? ""
                                            : handles.members[chatList[index].sender] ?? "",
                                          isRecurring: chatList.first.id == chatList[index].id
                                            ? false
                                            : chatList[index].sender == chatList [index - 1].sender && chatList[index-1].type != ChatType.status,
                                          content: chatList[index - 1].type == ChatType.image && chatList[index-1].sender == currentUser.id
                                            ? ""
                                            : chatList[index].content ?? "",
                                          isPinned: chatList[index].isPinned,
                                          imageURL: chatList[index].mediaURL ?? "",
                                          selectChatMethod: selectChat,
                                          chatOnTap: chatOnTap,
                                          selectedChats: selectedChatIndex,
                                          scrollToTarget: scrollToTargetFromChild,
                                          scrollLocation: replyToModel == null
                                          ? 0
                                          : chatList.indexWhere((element) => element.id == replyToModel.id),
                                        )
                                      : chatList[index].type == ChatType.video
                                      ? VideoChat(
                                          handlesID: handles.id,
                                          chatID: chatList[index].id,
                                          deletedBy: chatList[index].deletedBy,
                                          readBy: chatList[index].readBy,
                                          replyTo: replyToModel,
                                          userID: currentUser.id,
                                          index: index,
                                          timestamp: chatList[index].timestamp,
                                          sender: chatList[index].sender,
                                          senderRole: handles.members[chatList[index].sender] == "Members"
                                            ? ""
                                            : handles.members[chatList[index].sender] ?? "",
                                          isRecurring: chatList.first.id == chatList[index].id
                                            ? false
                                            : chatList[index].sender == chatList [index - 1].sender && chatList[index-1].type != ChatType.status,
                                          content: chatList[index - 1].type == ChatType.image && chatList[index-1].sender == currentUser.id
                                            ? ""
                                            : chatList[index].content ?? "",
                                          isPinned: chatList[index].isPinned,
                                          videoURL: chatList[index].mediaURL ?? "",
                                          selectChatMethod: selectChat,
                                          chatOnTap: chatOnTap,
                                          selectedChats: selectedChatIndex,
                                          scrollToTarget: scrollToTargetFromChild,
                                          scrollLocation: replyToModel == null
                                          ? 0
                                          : chatList.indexWhere((element) => element.id == replyToModel.id),
                                        )
                                      : chatList[index].type == ChatType.docs 
                                      ? DocumentChat(
                                          handlesID: handles.id,
                                          chatID: chatList[index].id,
                                          deletedBy: chatList[index].deletedBy,
                                          readBy: chatList[index].readBy,
                                          index: index,
                                          userID: currentUser.id,
                                          timestamp: chatList[index].timestamp,
                                          sender: chatList[index].sender,
                                          senderRole: handles.members[chatList[index].sender] == "Members"
                                            ? ""
                                            : handles.members[chatList[index].sender] ?? "",
                                          isRecurring: chatList.first.id == chatList[index].id
                                            ? false
                                            : chatList[index].sender == chatList [index - 1].sender && chatList[index-1].type != ChatType.status,
                                          isPinned: chatList[index].isPinned,
                                          documentURL: chatList[index].mediaURL ?? "",
                                          selectChatMethod: selectChat,
                                          chatOnTap: chatOnTap,
                                          selectedChats: selectedChatIndex,
                                          scrollToTarget: scrollToTargetFromChild,
                                          scrollLocation: replyToModel == null
                                          ? 0
                                          : chatList.indexWhere((element) => element.id == replyToModel.id),
                                        )
                                      : chatList[index].type == ChatType.meets
                                      ? watch(meetChatProvider(chatList[index].id)).when(
                                          data: (meetChat){
                                            return MeetingChat(
                                              handlesID: handles.id,
                                              index: index,
                                              userID: currentUser.id,
                                              timestamp: chatList[index].timestamp,
                                              sender: chatList[index].sender,
                                              senderRole: handles.members[chatList[index].sender] == "Members"
                                                ? ""
                                                : handles.members[chatList[index].sender] ?? "",
                                              isRecurring: chatList.first.id == chatList[index].id
                                                ? false
                                                : chatList[index].sender == chatList [index - 1].sender && chatList[index-1].type != ChatType.status && chatList[index - 1].timestamp.day == chatList[index].timestamp.day,
                                              isPinned: chatList[index].isPinned,
                                              meetingModel: meetChat
                                            );
                                          },
                                          loading: (){
                                            return SizedBox();
                                          },
                                          error: (object , error){
                                            return SizedBox();
                                          }
                                        )
                                      : chatList[index].type == ChatType.project
                                      ? watch(projectChatProvider(chatList[index].id)).when(
                                          data: (projectModel){
                                            return ProjectChat(
                                              handlesID: handles.id,
                                              index: index,
                                              userID: currentUser.id,
                                              timestamp: chatList[index].timestamp,
                                              sender: chatList[index].sender,
                                              senderRole: handles.members[chatList[index].sender] == "Members"
                                                ? ""
                                                : handles.members[chatList[index].sender] ?? "",
                                              isRecurring: chatList.first.id == chatList[index].id
                                                ? false
                                                : chatList[index].sender == chatList [index - 1].sender && chatList[index-1].type != ChatType.status && chatList[index - 1].timestamp.day == chatList[index].timestamp.day,
                                              isPinned: chatList[index].isPinned,
                                              projectModel: projectModel
                                            );
                                          },
                                          loading: (){
                                            return SizedBox();
                                          },
                                          error: (object , error){
                                            print(object);
                                            return SizedBox();
                                          }
                                        )
                                      : SizedBox()
                                  ]
                                );
                              }
                            ),
                          ),
                          Expanded(
                            flex: isKeyboardOpen && isReplying != null
                              ? lineCount + 8
                              : isKeyboardOpen
                              ? lineCount
                              : isReplying != null
                              ? 11
                              : 5,
                            child: Container(
                              padding: EdgeInsets.only(
                                left: MQuery.height(0.015, context),
                                right: MQuery.height(0.015, context),
                                bottom: MQuery.height(0.015, context),
                              ),
                              color: Palette.handlesBackground,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: MQuery.width(0.01, context),
                                        right: MQuery.width(0.01, context),
                                        top: isKeyboardOpen && isReplying != null ? MQuery.width(0.015, context) : MQuery.width(0, context),
                                        bottom: MQuery.width(0.005, context),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          isReplying != null
                                          ? Radius.circular(15)
                                          : Radius.circular(50 - (lineCount * 4))
                                        )
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: isReplying != null
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight: MQuery.height(0.15, context),
                                                  minWidth: MQuery.width(0.35, context)
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
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          FutureBuilder<UserModel>(
                                                            future: _userProvider.getUserByID(isReplying!.sender),
                                                            builder: (context, snapshot) {
                                                              return snapshot.hasData
                                                              ? Text(
                                                                  snapshot.data!.name, 
                                                                  style: TextStyle(
                                                                    color: Palette.primary,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 13,
                                                                  )
                                                                )
                                                              : SizedBox();
                                                            }
                                                          ),
                                                          SizedBox(height: MQuery.height(0.005, context)),
                                                          Text(
                                                            isReplying!.type == ChatType.image
                                                            ? "[Image] ${
                                                                  isReplying!.content!.length >= 35
                                                                  ? isReplying!.content!.substring(0, 32) + "..."
                                                                  : isReplying!.content!
                                                                }"
                                                            : isReplying!.type == ChatType.video
                                                            ? "[Video] ${
                                                                  isReplying!.content!.length >= 35
                                                                  ? isReplying!.content!.substring(0, 32) + "..."
                                                                  : isReplying!.content!
                                                                }"
                                                            : isReplying!.type == ChatType.docs
                                                            ? "[Docs] ${
                                                                  isReplying!.content!.length >= 35
                                                                  ? isReplying!.content!.substring(0, 32) + "..."
                                                                  : isReplying!.content!
                                                                }"
                                                            : isReplying!.content!.length >= 35
                                                              ? isReplying!.content!.substring(0, 32) + "..."
                                                              : isReplying!.content!, 
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12,
                                                              height: 1.25
                                                            )
                                                          )
                                                        ]
                                                      ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            isReplying = null;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 16
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                )
                                              ),
                                              SizedBox(height: MQuery.height(0, context)),
                                              TextFormField(
                                                keyboardType: TextInputType.multiline,
                                                controller: chatController,
                                                maxLines: isKeyboardOpen && isReplying != null
                                                ? 2
                                                : isChatting ? 6 : 1,
                                                decoration: InputDecoration(
                                                  hintText: "Type a message",
                                                  border: InputBorder.none
                                                ),
                                                onChanged: (String value){
                                                  if(value.indexOf("\n") >= 0){
                                                    if(lineCount <= 8){
                                                      setState(() {
                                                        lineCount++;
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          )
                                        : TextFormField(
                                            keyboardType: TextInputType.multiline,
                                            controller: chatController,
                                            maxLines: isChatting ? 6 : 1,
                                            decoration: InputDecoration(
                                              hintText: "Type a message",
                                              border: InputBorder.none
                                            ),
                                            onChanged: (String value){
                                              if(value.indexOf("\n") >= 0){
                                                if(lineCount <= 8){
                                                  setState(() {
                                                    lineCount++;
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                      )
                                    ),
                                  ),
                                  SizedBox(width: MQuery.width(0.01, context)),
                                  Expanded(
                                    flex: 1,
                                    child: isChatting
                                    ? GestureDetector(
                                        onTap: (){
                                          _currentUserProvider.whenData((user){
                                            _chatProvider.sendPlainChat(
                                              handles.id,
                                              ChatModel(
                                                id: Uuid().v4(),
                                                type: ChatType.plain,
                                                content: chatController.text,
                                                replyTo: isReplying != null ? isReplying!.id : "",
                                                readBy: [],
                                                deletedBy: [],
                                                timestamp: DateTime.now(),
                                                sender: user.id,
                                                isPinned: false
                                              )
                                            );
                                          });
                                          setState(() {
                                            chatController.text = "";
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: MQuery.height(0.2, context),
                                          backgroundColor: Palette.secondary,
                                          child: AdaptiveIcon(
                                            android: Icons.send,
                                            iOS: CupertinoIcons.paperplane_fill,
                                            color: Colors.white, size: 24,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                      onTap: (){
                                        Get.bottomSheet(
                                          BottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                              )
                                            ),
                                            onClosing: (){},
                                            builder: (context){
                                              return Container(
                                                padding: EdgeInsets.all(
                                                  MQuery.height(0.02, context)
                                                ),
                                                height: MQuery.height(0.275, context),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Container(
                                                          height: MQuery.height(0.1, context),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              Get.to(() => PickImagesPage(
                                                                replyTo: isReplying != null ? isReplying!.id : "",
                                                                handlesID: widget.handlesID
                                                              ), transition: Transition.cupertino);
                                                            },
                                                            child: Constants.mediaAvatar[keys[0]],
                                                            style: ElevatedButton.styleFrom(
                                                              shape: CircleBorder(),
                                                              padding: EdgeInsets.all(20),
                                                              primary: Palette.primary, // <-- Button color
                                                              onPrimary: Palette.primary, // <-- Splash color
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: MQuery.height(0.1, context),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              Get.to(() => PickVideosPage(
                                                                replyTo: isReplying != null ? isReplying!.id : "",
                                                                handlesID: widget.handlesID,
                                                              ), transition: Transition.cupertino);
                                                            },
                                                            child: Constants.mediaAvatar[keys[1]],
                                                            style: ElevatedButton.styleFrom(
                                                              shape: CircleBorder(),
                                                              padding: EdgeInsets.all(20),
                                                              primary: Palette.primary, // <-- Button color
                                                              onPrimary: Palette.primary, // <-- Splash color
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: MQuery.height(0.1, context),
                                                          child: ElevatedButton(
                                                            onPressed: () async {
                                                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                                                              if(result != null) {
                                                                PlatformFile file = result.files.first;
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context){
                                                                    return Platform.isAndroid
                                                                    ? AlertDialog(
                                                                        content: Text(
                                                                          'Send file: "${file.name}" to ${handles.name}?'
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
                                                                            child: Text("SEND"),
                                                                            style: TextButton.styleFrom(
                                                                              textStyle: TextStyle(
                                                                                color: Palette.primary,
                                                                                fontWeight: FontWeight.w500
                                                                              )
                                                                            ),
                                                                            onPressed: (){
                                                                              Get.back();
                                                                              _chatProvider.uploadDocument(file.path!, handles.name).then((mediaURL){
                                                                                print(mediaURL);
        
                                                                                _chatProvider.sendDocumentChat(
                                                                                  widget.handlesID,
                                                                                  ChatModel(
                                                                                    id: Uuid().v4(),
                                                                                    type: ChatType.docs,
                                                                                    content: chatController.text,
                                                                                    replyTo: isReplying != null ? isReplying!.id : "",
                                                                                    mediaURL: mediaURL,
                                                                                    readBy: [],
                                                                                    deletedBy: [],
                                                                                    timestamp: DateTime.now(),
                                                                                    sender: "",
                                                                                    isPinned: false
                                                                                  )
                                                                                );
                                                                              });
                                                                            },
                                                                          )
                                                                        ],
                                                                      )
                                                                    : CupertinoAlertDialog(
                                                                        content: Text(
                                                                          'Send file: "${file.name}" to  ${handles.name}?'
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
                                                                            child: Text("SEND"),
                                                                            style: TextButton.styleFrom(
                                                                              textStyle: TextStyle(
                                                                                color: Palette.primary,
                                                                                fontWeight: FontWeight.w500
                                                                              )
                                                                            ),
                                                                            onPressed: (){
                                                                              Get.back();
                                                                              _chatProvider.uploadDocument(file.path!, handles.name).then((mediaURL){
                                                                                print(mediaURL);
        
                                                                                _chatProvider.sendDocumentChat(
                                                                                  widget.handlesID,
                                                                                  ChatModel(
                                                                                    id: Uuid().v4(),
                                                                                    type: ChatType.docs,
                                                                                    content: chatController.text,
                                                                                    replyTo: isReplying != null ? isReplying!.id : "",
                                                                                    mediaURL: mediaURL,
                                                                                    readBy: [],
                                                                                    deletedBy: [],
                                                                                    timestamp: DateTime.now(),
                                                                                    sender: "",
                                                                                    isPinned: false
                                                                                  )
                                                                                );
                                                                              });
                                                                            },
                                                                          )
                                                                        ],
                                                                      );
                                                                  }
                                                                );
                                                              } else {
                                                                // User canceled the picker
                                                              }
                                                            },
                                                            child: Constants.mediaAvatar[keys[2]],
                                                            style: ElevatedButton.styleFrom(
                                                              shape: CircleBorder(),
                                                              padding: EdgeInsets.all(20),
                                                              primary: Palette.primary, // <-- Button color
                                                              onPrimary: Palette.primary, // <-- Splash color
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: MQuery.height(0.025, context)),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Container(
                                                          height: MQuery.height(0.1, context),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              Get.to(() => MeetingCreator(
                                                                handlesID: handles.id
                                                              ), transition: Transition.cupertino);
                                                            },
                                                            child: Constants.mediaAvatar[keys[3]],
                                                            style: ElevatedButton.styleFrom(
                                                              shape: CircleBorder(),
                                                              padding: EdgeInsets.all(20),
                                                              primary: Palette.primary, // <-- Button color
                                                              onPrimary: Palette.primary, // <-- Splash color
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: MQuery.height(0.1, context),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Get.back();
                                                              Get.to(() => ProjectCreator(
                                                                handlesID: handles.id
                                                              ), transition: Transition.cupertino);
                                                            },
                                                            child: Constants.mediaAvatar[keys[4]],
                                                            style: ElevatedButton.styleFrom(
                                                              shape: CircleBorder(),
                                                              padding: EdgeInsets.all(20),
                                                              primary: Palette.primary, // <-- Button color
                                                              onPrimary: Palette.primary, // <-- Splash color
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: MQuery.height(0.1, context),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                            },
                                                            child: Constants.mediaAvatar[keys[4]],
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 0,
                                                              shape: CircleBorder(),
                                                              padding: EdgeInsets.all(20),
                                                              primary: Colors.transparent, // <-- Button color
                                                              onPrimary: Palette.primary, // <-- Splash color
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              );
                                            }
                                          )
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: MQuery.height(0.2, context),
                                        backgroundColor: Palette.secondary,
                                        child: AdaptiveIcon(
                                          android: Icons.add,
                                          iOS: CupertinoIcons.add,
                                          color: Colors.white, size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            )
                          )
                        ],
                      );
                    },
                    loading: (){
                      return SizedBox();
                    },
                    error: (object , error){
                      print(object);
                      print(error);
                      return SizedBox();
                    }
                  )
                );
              },
              loading: (){
                return SizedBox();
              },
              error: (object , error){
                return SizedBox();
              }
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