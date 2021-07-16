part of "../pages.dart";

class ForwardMessagePage extends StatefulWidget {

  final List<ChatModel> selectedMessages;
  final String originHandlesID;
  const ForwardMessagePage({ Key? key, required this.selectedMessages, required this.originHandlesID}) : super(key: key);

  @override
  _ForwardMessagePageState createState() => _ForwardMessagePageState();
}

class _ForwardMessagePageState extends State<ForwardMessagePage> {

  Set<String> selectedHandles = Set();
  bool isHandlesSelected = false;

  @override
  Widget build(BuildContext context) {

    print(widget.selectedMessages);
    print(selectedHandles);

    return Consumer(
      builder: (ctx, watch,child) {

        final _currentUserProvider = watch(currentUserProvider);
        final _chatProvider = watch(chatProvider);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon:  AdaptiveIcon(
                android: Icons.close,
                iOS: CupertinoIcons.xmark,
                color: Colors.white
              ),
              onPressed: (){
                Get.back();
              }
            ),
            title: Text(
              "Forward ${widget.selectedMessages.length} message(s)",
              style: TextStyle(
                fontSize: 18
              )
            ),
            actions: [
              IconButton(
                icon: AdaptiveIcon(
                  android: Icons.arrow_right_alt,
                  iOS: CupertinoIcons.chevron_right,
                  color: Colors.white
                ),
                onPressed: (){
                  selectedHandles.forEach((handles) {
                    widget.selectedMessages.forEach((chatRaw) {

                      final chat = ChatModel(
                        replyTo: "",
                        deletedBy: chatRaw.deletedBy,
                        sender: chatRaw.sender,
                        timestamp: chatRaw.timestamp,
                        type: chatRaw.type,
                        isPinned: chatRaw.isPinned,
                        readBy: chatRaw.readBy,
                        id: chatRaw.id,
                        mediaURL: chatRaw.mediaURL,
                        content: chatRaw.content
                      );

                      if(chat.type == ChatType.plain){
                        _chatProvider.sendPlainChat(handles, chat);
                      } else if (chat.type == ChatType.image){
                        _chatProvider.sendImageChat(handles, chat);
                      } else if (chat.type == ChatType.video){
                        _chatProvider.sendVideoChat(handles, chat);
                      } else if (chat.type == ChatType.docs){
                        _chatProvider.sendDocumentChat(handles, chat);
                      }
                      Get.offAll(Homepage());
                    });
                  });
                }
              )
            ],
          ),
          body: _currentUserProvider.when(
            data: (user){
              return  Container(
                height: MQuery.height(0.9, context),
                child: ListView.builder(
                  itemCount: user.handlesList!.length - 1,
                  itemBuilder: (context, index){

                    final _singleHandlesProvider = watch(singleHandlesProvider(user.handlesList![index + 1]));

                    return _singleHandlesProvider.when(
                      data: (handles){
                        return handles.archivedBy!.indexOf(user.id) >= 0 || handles.id == widget.originHandlesID
                        ? SizedBox()
                        : ListTile(
                            onTap: (){
                              if(selectedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                setState(() {
                                  selectedHandles.add(user.handlesList![index + 1]);
                                });
                              } else {
                                setState(() {
                                  selectedHandles.remove(user.handlesList![index + 1]);
                                });
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
                                selectedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0
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
                            trailing: Container(
                              width: MQuery.width(0.06, context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Font.out(
                                    "1:13 PM",
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
                                      ? AdaptiveIcon(
                                          android: Icons.push_pin,
                                          iOS: CupertinoIcons.pin_fill,
                                          size: 20
                                        )
                                      : SizedBox()
                                    ],
                                  )
                                ],
                              ),
                            )
                          );
                      },
                      loading: () => SizedBox(),
                      error: (_,__) => SizedBox()
                    );
                  }
                )
              );
            },
            loading: () => SizedBox(),
            error: (_,__) => SizedBox()
          )
        );
      },
    );
  }
}