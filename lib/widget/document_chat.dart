part of "widgets.dart";

class DocumentChat extends StatefulWidget {
  final int index;
  final String userID;
  final DateTime timestamp;
  final String sender;
  final String senderRole;
  final String documentURL;
  final bool isRecurring;
  final bool isPinned;
  final Set<int> selectedChats;
  final void Function(int) chatOnTap;
  final void Function(int) selectChatMethod;

  const DocumentChat(
      {Key? key,
      required this.index,
      required this.userID,
      required this.timestamp,
      required this.sender,
      required this.senderRole,
      required this.documentURL,
      required this.isRecurring,
      required this.isPinned,
      required this.selectChatMethod,
      required this.chatOnTap,
      required this.selectedChats})
      : super(key: key);

  @override
  _DocumentChatState createState() => _DocumentChatState();
}

class _DocumentChatState extends State<DocumentChat> {
  @override
  Widget build(BuildContext context) {
    Future<String> getFileSize(String filepath, int decimals) async {
      http.Response r = await http.get(Uri.parse(filepath));
      final bytes = int.parse(r.headers["content-length"] ?? "0");
      if (bytes <= 0) {
        return "0 B";
      }
      const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      var i = (log(bytes) / log(1024)).floor();
      return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
          ' ' +
          suffixes[i];
    }

    Future<String> getFileExtension(String filePath) async {
      http.Response r = await http.get(Uri.parse(filePath));
      String? extension = r.headers["content-type"];

      return extension!.substring(12, extension.length);
    }

    Future<String?> getFileName(String filePath) async {
      String name = Uri.decodeFull(basenameWithoutExtension(filePath));
      int location = name.lastIndexOf("/");
      return name.substring(location + 1, name.length);
    }

    return Consumer(
      builder: (ctx, watch, child) {
        final _userProvider = watch(userProvider);

        return widget.sender == widget.userID
            ? Container(
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
                                this.widget.documentURL.length >= 30
                                    ? 0.35
                                    : this.widget.documentURL.length <= 12
                                        ? 0.15
                                        : this.widget.documentURL.length *
                                            0.009,
                                context),
                            minWidth: MQuery.width(0.1, context),
                            minHeight: MQuery.height(0.045, context)),
                        child: Container(
                          padding: EdgeInsets.all(MQuery.height(0.01, context)),
                          decoration: BoxDecoration(
                              color: Palette.primary,
                              borderRadius: BorderRadius.only(
                                  topRight: widget.isRecurring
                                      ? Radius.circular(7)
                                      : Radius.circular(0),
                                  topLeft: Radius.circular(7),
                                  bottomRight: Radius.circular(7),
                                  bottomLeft: Radius.circular(7))),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FutureBuilder<String>(
                                          future: getFileSize(
                                              widget.documentURL, 2),
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
                                          future: getFileExtension(
                                              widget.documentURL),
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
                                          }),
                                    ],
                                  ),
                                  Text(
                                    DateFormat.jm().format(widget.timestamp),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        color: Colors.grey[200]!.withOpacity(0.35)
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Andreas", 
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            )
                                          ),
                                          SizedBox(height: MQuery.height(0.005, context)),
                                          Text(
                                            "Fantasies11!!", 
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 12,
                                              height: 1.25
                                            )
                                          )
                                        ]
                                      )
                                    )
                                  ),
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
                                                    future: getFileName(
                                                        widget.documentURL),
                                                    builder:
                                                        (context, snapshot) {
                                                      return snapshot.hasData
                                                          ? Text(
                                                              snapshot.data!.length >=
                                                                      23
                                                                  ? snapshot
                                                                          .data!
                                                                          .substring(
                                                                              0,
                                                                              23) +
                                                                      "..."
                                                                  : snapshot
                                                                      .data!,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14))
                                                          : SizedBox();
                                                    }),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: AdaptiveIcon(
                                                  android: Icons.download,
                                                  iOS: CupertinoIcons
                                                      .cloud_download_fill,
                                                  size: 18,
                                                  color: Palette.primary),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      height: MQuery.height(0.0275, context))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: SvgPicture.asset("assets/tool_tip.svg",
                            height: MQuery.height(0.02, context),
                            width: MQuery.height(0.02, context),
                            color: this.widget.isRecurring
                                ? Colors.transparent
                                : Palette.primary),
                      ),
                    ],
                  ),
                ))
            : FutureBuilder<UserModel>(
                future: _userProvider.getUserByID(widget.sender),
                builder: (context, snapshot) {
                  return Container(
                      width: MQuery.width(1, context),
                      margin:
                          EdgeInsets.only(bottom: MQuery.width(0.01, context)),
                      padding: EdgeInsets.symmetric(
                          horizontal: MQuery.width(0.01, context)),
                      color:
                          widget.selectedChats.toList().indexOf(widget.index) >=
                                  0
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
                                color: this.widget.isRecurring
                                    ? Colors.transparent
                                    : Colors.white),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: MQuery.width(
                                      this.widget.documentURL.length >= 30
                                          ? 0.35
                                          : this.widget.documentURL.length <= 12
                                              ? 0.15
                                              : this.widget.documentURL.length *
                                                  0.009,
                                      context),
                                  minWidth: MQuery.width(0.14, context),
                                  minHeight: MQuery.height(0.045, context)),
                              child: Container(
                                padding: EdgeInsets.all(
                                    MQuery.height(0.01, context)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: widget.isRecurring
                                            ? Radius.circular(7)
                                            : Radius.circular(0),
                                        topRight: Radius.circular(7),
                                        bottomRight: Radius.circular(7),
                                        bottomLeft: Radius.circular(7))),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FutureBuilder<String>(
                                                future: getFileSize(
                                                    widget.documentURL, 2),
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData
                                                      ? Text(
                                                          snapshot.data ?? "",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
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
                                                    color: Colors.black
                                                        .withOpacity(0.5))),
                                            SizedBox(width: 5),
                                            FutureBuilder<String>(
                                                future: getFileExtension(widget.documentURL),
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData
                                                      ? Text(
                                                          snapshot.data!.toUpperCase(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12),
                                                        )
                                                      : SizedBox();
                                                }),
                                          ],
                                        ),
                                        Text(
                                          DateFormat.jm()
                                              .format(widget.timestamp),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            widget.isRecurring &&
                                                    widget.isPinned == false
                                                ? SizedBox()
                                                : RichText(
                                                    text: TextSpan(
                                                      text: snapshot.hasData ? "${snapshot.data!.name} " : "",
                                                      style: TextStyle(
                                                          color:
                                                              Palette.primary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15),
                                                      children: [
                                                        TextSpan(
                                                            text: "(${this.widget.senderRole})",
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15)),
                                                      ],
                                                    ),
                                                  ),
                                            widget.isPinned
                                                ? AdaptiveIcon(
                                                    android: Icons.push_pin,
                                                    iOS:
                                                        CupertinoIcons.pin_fill,
                                                    size: 12)
                                                : SizedBox(),
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                MQuery.height(0.01, context)),
                                        ConstrainedBox(
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
                                                Text(
                                                  "Andreas", 
                                                  style: TextStyle(
                                                    color: Palette.primary,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                  )
                                                ),
                                                SizedBox(height: MQuery.height(0.005, context)),
                                                Text(
                                                  "Fantasies11!!", 
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
                                        SizedBox(height: MQuery.height(0.005, context)),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: MQuery.width(
                                                    0.003, context)),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color:
                                                    Palette.handlesBackground,
                                              ),
                                              height:
                                                  MQuery.height(0.05, context),
                                              width:
                                                  MQuery.width(0.325, context),
                                              padding: EdgeInsets.only(
                                                  left: MQuery.width(
                                                      0.01, context)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          "assets/mdi_file-document.svg",
                                                          height: 18,
                                                          width: 18,
                                                          color:
                                                              Palette.primary),
                                                      SizedBox(
                                                          width: MQuery.width(
                                                              0.01, context)),
                                                      FutureBuilder<String?>(
                                                          future: getFileName(
                                                              widget
                                                                  .documentURL),
                                                          builder: (context,
                                                              snapshot) {
                                                            return snapshot
                                                                    .hasData
                                                                ? Text(
                                                                    snapshot.data!.length >=
                                                                            23
                                                                        ? snapshot.data!.substring(0,
                                                                                23) +
                                                                            "..."
                                                                        : snapshot
                                                                            .data!,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            14))
                                                                : SizedBox();
                                                          }),
                                                    ],
                                                  ),
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: AdaptiveIcon(
                                                        android: Icons.download,
                                                        iOS: CupertinoIcons
                                                            .cloud_download_fill,
                                                        size: 18,
                                                        color: Palette.primary),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                MQuery.height(0.0275, context))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                });
      },
    );
  }
}
