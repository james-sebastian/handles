part of "widgets.dart";

class PlainChat extends ConsumerWidget {
  final String userID;
  final int index;
  final DateTime timestamp;
  final String sender;
  final String senderRole;
  final String content;
  final bool isRecurring;
  final bool isPinned;
  final Set<int> selectedChats;
  final void Function(int) chatOnTap;
  final void Function(int) selectChatMethod;

  const PlainChat({
    Key? key,
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
    required this.selectedChats
  }) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {

    final _userProvider = watch(userProvider);

    return sender == userID
    ? Container(
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
        ))
    : FutureBuilder<UserModel>(
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
                                bottomLeft: Radius.circular(7))),
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
      );
  }
}
