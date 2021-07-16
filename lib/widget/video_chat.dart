part of "widgets.dart";

class VideoChat extends StatefulWidget {
  final String userID;
  final int index;
  final DateTime timestamp;
  final String sender;
  final String senderRole;
  final String videoURL;
  final String content;
  final bool isRecurring;
  final bool isPinned;
  final Set<int> selectedChats;
  final ChatModel? replyTo;
  final void Function(int) chatOnTap;
  final void Function(int) selectChatMethod;
  final int scrollLocation;
  final void Function(int) scrollToTarget;

  const VideoChat({
    Key? key,
    required this.userID,
    required this.index,
    required this.timestamp,
    required this.sender,
    required this.senderRole,
    required this.videoURL,
    required this.isRecurring,
    required this.isPinned,
    required this.content,
    required this.selectChatMethod,
    required this.chatOnTap,
    required this.selectedChats,
    required this.scrollToTarget,
    required this.scrollLocation,
    this.replyTo,
  }) : super(key: key);

  @override
  _VideoChatState createState() => _VideoChatState();
}

class _VideoChatState extends State<VideoChat> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {

    Future<String?> getThumbnail(String videoURL) async {
      final String? fileName = await VideoThumbnail.thumbnailFile(
        video: this.widget.videoURL,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 180, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 50,
      );

      return fileName;
    }

    return Consumer(
      builder: (ctx, watch,child) {

        final _userProvider = watch(userProvider);

        return widget.sender == widget.userID
          ? FutureBuilder<UserModel>(
              future: _userProvider.getUserByID(widget.sender),
              builder: (context, snapshot) {
                return Container(
                    width: MQuery.width(1, context),
                    margin: EdgeInsets.only(
                      bottom: MQuery.width(0.01, context),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
                    color: widget.selectedChats.toList().indexOf(widget.index) >= 0
                    ? Palette.primary.withOpacity(0.25)
                    : Colors.transparent, 
                    child: InkWell(
                      onTap: (){
                        widget.chatOnTap(widget.index);
                      },
                      onLongPress: (){
                        widget.selectChatMethod(widget.index);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MQuery.width(
                                this.widget.videoURL.length >= 30
                                ? 0.35
                                : this.widget.videoURL.length <= 12
                                  ? 0.15
                                  : this.widget.videoURL.length * 0.009
                                , context
                              ),
                              minWidth: MQuery.width(0.1, context),
                              minHeight: MQuery.height(0.045, context)
                            ),
                            child: Container(
                              padding: EdgeInsets.all(MQuery.height(0.01, context)),
                              decoration: BoxDecoration(
                                color: Palette.primary,
                                borderRadius: BorderRadius.only(
                                  topRight: widget.isRecurring ? Radius.circular(7) : Radius.circular(0),
                                  topLeft: Radius.circular(7),
                                  bottomRight: Radius.circular(7),
                                  bottomLeft: Radius.circular(7)
                                )
                              ),
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
                                  SizedBox(height: MQuery.height(0.005, context)),
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Get.to(() => VideoPreviewer(
                                            videoURL: this.widget.videoURL,
                                            timeStamp: this.widget.timestamp,
                                            sender: snapshot.data!.name,
                                            heroTag: "image-${widget.index}",
                                            content: this.widget.content
                                          ));
                                        },
                                        child: Hero(
                                          tag: "image-${widget.index}",
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 1/1,
                                                child: FutureBuilder<String?>(
                                                  future: getThumbnail(this.widget.videoURL),
                                                  builder: (context, snapshot){
                                                    return snapshot.hasData
                                                    ? Container(
                                                        width: MQuery.width(0.35, context),
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(5))
                                                        ),
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
                                                                color: Colors.black.withOpacity(0.4),
                                                                borderRadius: BorderRadius.all(Radius.circular(5))
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
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.5),
                                                          borderRadius: BorderRadius.all(Radius.circular(5))
                                                        ),
                                                        child: Center(
                                                          child: CircularProgressIndicator(
                                                            color: Palette.primary,
                                                          ),
                                                        )
                                                      );
                                                  },
                                                )
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    widget.isPinned
                                                    ? AdaptiveIcon(
                                                        android: Icons.push_pin,
                                                        iOS: CupertinoIcons.pin_fill,
                                                        size: 12,
                                                        color: Palette.handlesBackground,
                                                      )
                                                    : SizedBox(),
                                                    Text(
                                                      DateFormat.jm().format(widget.timestamp),
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(1),
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 12
                                                      ),
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
                                  this.widget.content == ""
                                  ? SizedBox()
                                  : Column(
                                    children: [
                                      SizedBox(height: MQuery.height(0.0075, context)),
                                      SelectableLinkify(
                                        onOpen: (link) async {
                                          print(link.url);
                                          await launch(link.url);
                                        },
                                        text: this.widget.content,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          height: 1.25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ),
                          ),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: SvgPicture.asset(
                              "assets/tool_tip.svg",
                              color: widget.isRecurring ? Colors.transparent : Palette.primary,
                              height: MQuery.height(0.02, context),
                              width: MQuery.height(0.02, context),
                            ),
                          ),
                        ],
                      ),
                    ));
              }
          )
          : FutureBuilder<UserModel>(
              future: _userProvider.getUserByID(widget.sender),
              builder: (context, snapshot) {
                return Container(
                    width: MQuery.width(1, context),
                    margin: EdgeInsets.only(
                      bottom: MQuery.width(0.01, context)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
                    color: widget.selectedChats.toList().indexOf(widget.index) >= 0
                    ? Palette.primary.withOpacity(0.25)
                    : Colors.transparent, 
                    child: InkWell(
                      onTap: (){
                        widget.chatOnTap(widget.index);
                      },
                      onLongPress: (){
                        widget.selectChatMethod(widget.index);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/tool_tip.svg",
                            height: MQuery.height(0.02, context),
                            width: MQuery.height(0.02, context),
                            color: widget.isRecurring ? Colors.transparent : Colors.white
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MQuery.width(
                                this.widget.videoURL.length >= 30
                                ? 0.35
                                : this.widget.videoURL.length <= 12
                                  ? 0.15
                                  : this.widget.videoURL.length * 0.009
                                , context
                              ),
                              minWidth: MQuery.width(0.14, context),
                              minHeight: MQuery.height(0.045, context)
                            ),
                            child: Container(
                              padding: EdgeInsets.all(MQuery.height(0.01, context)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: widget.isRecurring ? Radius.circular(7) : Radius.circular(0),
                                  topRight: Radius.circular(7),
                                  bottomRight: Radius.circular(7),
                                  bottomLeft: Radius.circular(7)
                                )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.isRecurring && widget.isPinned == false
                                      ? SizedBox()
                                      : RichText(
                                          text: TextSpan(
                                            text: "${snapshot.data!.name} ",
                                            style: TextStyle(
                                              color: Palette.primary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "(${this.widget.senderRole})",
                                                style: TextStyle(
                                                  color: Palette.primary,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                      widget.isPinned
                                      ? AdaptiveIcon(
                                          android: Icons.push_pin,
                                          iOS: CupertinoIcons.pin_fill,
                                          size: 12
                                        )
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
                                  : SizedBox(height: MQuery.height(0, context)),
                                  SizedBox(height: MQuery.height(0.005, context)),
                                  GestureDetector(
                                    onTap: (){
                                      Get.to(() => VideoPreviewer(
                                        videoURL: this.widget.videoURL,
                                        timeStamp: this.widget.timestamp,
                                        sender: snapshot.data!.name,
                                        heroTag: "image-${widget.index}",
                                        content: this.widget.content
                                      ));
                                    },
                                    child: Hero(
                                      tag: "image-${widget.index}",
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1/1,
                                            child: FutureBuilder<String?>(
                                              future: getThumbnail(this.widget.videoURL),
                                              builder: (context, snapshot){
                                                return snapshot.hasData
                                                ? Container(
                                                    width: MQuery.width(0.35, context),
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                                    ),
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
                                                            borderRadius: BorderRadius.all(Radius.circular(5))
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
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.5),
                                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                                    ),
                                                    child: Center(
                                                      child: CircularProgressIndicator(
                                                        color: Palette.primary,
                                                      ),
                                                    )
                                                  );
                                              },
                                            )
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              DateFormat.jm().format(widget.timestamp),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(1),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  this.widget.content == ""
                                  ? SizedBox()
                                  : Column(
                                    children: [
                                      SizedBox(height: MQuery.height(0.0075, context)),
                                      SelectableLinkify(
                                        onOpen: (link) async {
                                          print(link.url);
                                          await launch(link.url);
                                        },
                                        text: this.widget.content,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          height: 1.25,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  );
              }
            );
      },
    );
  }
}