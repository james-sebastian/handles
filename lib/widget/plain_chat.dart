part of "widgets.dart";

class PlainChat extends ConsumerWidget {
  final int index;
  final int scrollLocation;
  final String handlesID;
  final String chatID;
  final String userID;
  final String sender;
  final String senderRole;
  final String content;
  final bool isRecurring;
  final bool isPinned;
  final DateTime timestamp;
  final Set<int> selectedChats;
  final List<String> deletedBy;
  final List<String> readBy;
  final void Function(int) chatOnTap;
  final void Function(int) selectChatMethod;
  final void Function(int) scrollToTarget;
  final ChatModel? replyTo;

  const PlainChat({
    Key? key,
    required this.handlesID,
    required this.chatID,
    required this.userID,
    required this.index,
    required this.timestamp,
    required this.sender,
    required this.senderRole,
    required this.content,
    required this.isRecurring,
    required this.isPinned,
    required this.selectChatMethod,
    required this.chatOnTap,
    required this.selectedChats,
    required this.deletedBy,
    required this.readBy,
    required this.scrollToTarget,
    required this.scrollLocation,
    this.replyTo
  }) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {

    final _userProvider = watch(userProvider);
    final _chatProvider = watch(chatProvider);

    return deletedBy.indexOf(this.userID) >= 0
    ? SizedBox()
    : sender == userID
      ? VisibilityDetector(
          key: Key("$index"),
          onVisibilityChanged: (VisibilityInfo info) {
            if(this.readBy.indexOf(this.sender) >= 0){
              print("already read");
            } else {
              List<String> newReadBy = this.readBy;
              newReadBy.add(this.userID);

              _chatProvider.readChat(
                this.handlesID,
                this.chatID,
                newReadBy
              );
            }
          },
          child: Container(
            width: MQuery.width(1, context),
            margin: EdgeInsets.only(
              bottom: MQuery.width(0.01, context)
            ),
            padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
            color: selectedChats.toList().indexOf(index) >= 0
            ? Palette.primary.withOpacity(0.25)
            : Colors.transparent, 
            child: InkWell(
              onTap: (){
                chatOnTap(index);
              },
              onLongPress: (){
                selectChatMethod(index);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MQuery.width(
                          this.content.length >= 30
                          ? 0.35
                          : this.content.length <= 12
                            ? 0.15
                            : this.content.length * 0.009
                          , context
                        ),
                        minWidth: MQuery.width(0.1, context),
                        minHeight: MQuery.height(0.045, context)),
                    child: Container(
                        padding: EdgeInsets.all(MQuery.height(0.01, context)),
                        decoration: BoxDecoration(
                            color: Palette.primary,
                            borderRadius: BorderRadius.only(
                                topRight: isRecurring ? Radius.circular(7) : Radius.circular(0),
                                topLeft: Radius.circular(7),
                                bottomRight: Radius.circular(7),
                                bottomLeft: Radius.circular(7))),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isPinned 
                                ? AdaptiveIcon(
                                    android: Icons.push_pin,
                                    iOS: CupertinoIcons.pin_fill,
                                    size: 12,
                                    color: Palette.handlesBackground,
                                  )
                                : SizedBox(),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat.jm().format(timestamp),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                    SizedBox(width: 5),
                                    AdaptiveIcon(
                                      android: Icons.check,
                                      iOS: CupertinoIcons.checkmark_alt,
                                      size: 16,
                                      color: Palette.handlesBackground,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  this.replyTo != null
                                  ? GestureDetector(
                                    onTap: (){
                                      scrollToTarget(this.scrollLocation);
                                    },
                                    child: ConstrainedBox(
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
                                          color: Colors.grey[200]!.withOpacity(0.35)
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder<UserModel>(
                                                future: _userProvider.getUserByID(replyTo!.sender),
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
                                                replyTo!.type == ChatType.image
                                                ? "[Image] ${
                                                      replyTo!.content!.length >= 35
                                                      ? replyTo!.content!.substring(0, 32) + "..."
                                                      : replyTo!.content!
                                                    }"
                                                : replyTo!.type == ChatType.video
                                                ? "[Video] ${
                                                      replyTo!.content!.length >= 35
                                                      ? replyTo!.content!.substring(0, 32) + "..."
                                                      : replyTo!.content!
                                                    }"
                                                : replyTo!.type == ChatType.docs
                                                ? "[Docs] ${
                                                      replyTo!.content!.length >= 35
                                                      ? replyTo!.content!.substring(0, 32) + "..."
                                                      : replyTo!.content!
                                                    }"
                                                : replyTo!.content!.length >= 35
                                                  ? replyTo!.content!.substring(0, 32) + "..."
                                                  : replyTo!.content!, 
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
                                  : SizedBox(height: MQuery.height(0, context)),
                                  SizedBox(height: MQuery.height(0.005, context)),
                                  SelectableLinkify(
                                    onOpen: (link) async {
                                      print(link.url);
                                      await launch(link.url);
                                    },
                                    text: this.content,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        height: 1.25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                      height: MQuery.height(
                                          this.content.length >= 15
                                              ? 0.025
                                              : 0.0225,
                                          context)),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: SvgPicture.asset(
                      "assets/tool_tip.svg",
                      height: MQuery.height(0.02, context),
                      width: MQuery.height(0.02, context),
                      color: this.isRecurring ? Colors.transparent : Palette.primary
                    ),
                  ),
                ],
              ),
            )),
      )
      : VisibilityDetector(
        key: Key("$index"),
        onVisibilityChanged: (VisibilityInfo info) {
          if(this.readBy.indexOf(this.sender) >= 0){
            print("already read");
          } else {
            List<String> newReadBy = this.readBy;
            newReadBy.add(this.userID);

            _chatProvider.readChat(
              this.handlesID,
              this.chatID,
              newReadBy
            );
          }
        },
        child: FutureBuilder<UserModel>(
          future: _userProvider.getUserByID(this.sender),
          builder: (context, snapshot) {
            return Container(
              width: MQuery.width(1, context),
              margin: EdgeInsets.only(
                bottom: MQuery.width(0.01, context)),
              padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
              color: selectedChats.toList().indexOf(index) >= 0
                ? Palette.primary.withOpacity(0.25)
                : Colors.transparent, 
              child: InkWell(
                onTap: (){
                  chatOnTap(index);
                },
                onLongPress: (){
                  selectChatMethod(index);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/tool_tip.svg",
                      height: MQuery.height(0.02, context),
                      width: MQuery.height(0.02, context),
                      color: this.isRecurring ? Colors.transparent : Colors.white
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MQuery.width(
                            this.content.length >= 30
                            ? 0.35
                            : this.content.length <= 12
                              ? 0.15
                              : this.content.length * 0.0145
                            , context
                          ),
                          minWidth: MQuery.width(0.14, context),
                          minHeight: MQuery.height(0.045, context)),
                      child: Container(
                          padding: EdgeInsets.all(MQuery.height(0.01, context)),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: isRecurring ? Radius.circular(7) : Radius.circular(0),
                                topRight: Radius.circular(7),
                                bottomRight: Radius.circular(7),
                                bottomLeft: Radius.circular(7))
                              ),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Text(
                                DateFormat.jm().format(timestamp),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      isRecurring && isPinned == false
                                      ? SizedBox()
                                      : RichText(
                                          text: TextSpan(
                                            text: snapshot.hasData ? "${snapshot.data!.name} " : " ",
                                            style: TextStyle(
                                              color: Palette.primary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "(${this.senderRole})",
                                                style: TextStyle(
                                                  color: Palette.primary,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                      isPinned
                                      ? AdaptiveIcon(
                                          android: Icons.push_pin,
                                          iOS: CupertinoIcons.pin_fill,
                                          size: 12
                                        )
                                      : SizedBox()
                                    ],
                                  ),
                                  SizedBox(height: MQuery.height(0.005, context)),
                                  this.replyTo != null
                                  ? GestureDetector(
                                    onTap: (){
                                      scrollToTarget(this.scrollLocation);
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
                                                future: _userProvider.getUserByID(replyTo!.sender),
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
                                                replyTo!.type == ChatType.image
                                                ? "[Image] ${
                                                      replyTo!.content!.length >= 35
                                                      ? replyTo!.content!.substring(0, 32) + "..."
                                                      : replyTo!.content!
                                                    }"
                                                : replyTo!.type == ChatType.video
                                                ? "[Video] ${
                                                      replyTo!.content!.length >= 35
                                                      ? replyTo!.content!.substring(0, 32) + "..."
                                                      : replyTo!.content!
                                                    }"
                                                : replyTo!.type == ChatType.docs
                                                ? "[Docs] ${
                                                      replyTo!.content!.length >= 35
                                                      ? replyTo!.content!.substring(0, 32) + "..."
                                                      : replyTo!.content!
                                                    }"
                                                : replyTo!.content!.length >= 35
                                                  ? replyTo!.content!.substring(0, 32) + "..."
                                                  : replyTo!.content!, 
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  height: 1.25
                                                )
                                              )
                                            ]
                                          )
                                        )
                                      ),
                                  )
                                  : SizedBox(height: MQuery.height(0, context)),
                                  SizedBox(height: MQuery.height(0.005, context)),
                                  SelectableLinkify(
                                    onOpen: (link) async {
                                      print(link.url);
                                      await launch(link.url);
                                    },
                                    text: this.content,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        height: 1.25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                  SizedBox(height: MQuery.height(0.02, context)),
                                ],
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ));
          }
        ),
      );
  }
}
