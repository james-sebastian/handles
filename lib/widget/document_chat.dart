part of "widgets.dart";

class DocumentChat extends StatefulWidget {
  final int index;
  final DateTime timestamp;
  final String sender;
  final String senderRole;
  final String documentURL;
  final bool isRecurring;
  final bool isPinned;

  const DocumentChat({
    Key? key,
    required this.index,
    required this.timestamp,
    required this.sender,
    required this.senderRole,
    required this.documentURL,
    required this.isRecurring,
    required this.isPinned,
  }) : super(key: key);

  @override
  _DocumentChatState createState() => _DocumentChatState();
}

class _DocumentChatState extends State<DocumentChat> {
  @override
  Widget build(BuildContext context) {
    return widget.sender == "a" //TODO: CHECK IF SENDER == USER ID
      ? Container(
          width: MQuery.width(1, context),
          margin: EdgeInsets.only(
            bottom: MQuery.width(0.01, context)
          ),
          padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
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
                      : this.widget.documentURL.length * 0.009
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
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "1.4 MB",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.5)
                                )
                              ),
                              SizedBox(width: 5),
                              Text(
                                "PDF",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat.jm().format(widget.timestamp),
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
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: Palette.handlesBackground,
                                ),
                                height: MQuery.height(0.05, context),
                                width: MQuery.width(0.325, context),
                                padding: EdgeInsets.only(
                                  left: MQuery.width(0.01, context)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset("assets/mdi_file-document.svg", height: 18, width: 18, color: Palette.primary),
                                        SizedBox(width: MQuery.width(0.01, context)),
                                        Text(
                                          "asn.pdf",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14
                                          )
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: (){},
                                      icon: AdaptiveIcon(
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
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: SvgPicture.asset(
                  "assets/tool_tip.svg",
                  height: MQuery.height(0.02, context),
                  width: MQuery.height(0.02, context),
                  color: this.widget.isRecurring ? Palette.handlesBackground : Palette.primary
                ),
              ),
            ],
          ))
      : Container(
          width: MQuery.width(1, context),
          margin: EdgeInsets.only(
            bottom: MQuery.width(0.01, context)),
          padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/tool_tip.svg",
                height: MQuery.height(0.02, context),
                width: MQuery.height(0.02, context),
                color: this.widget.isRecurring ? Palette.handlesBackground : Colors.white
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MQuery.width(
                    this.widget.documentURL.length >= 30
                    ? 0.35
                    : this.widget.documentURL.length <= 12
                      ? 0.15
                      : this.widget.documentURL.length * 0.009
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
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "1.4 MB",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.5)
                                )
                              ),
                              SizedBox(width: 5),
                              Text(
                                "PDF",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat.jm().format(widget.timestamp),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.isRecurring && widget.isPinned == false
                              ? SizedBox()
                              : RichText(
                                  text: TextSpan(
                                    text: "${this.widget.sender} ",
                                    style: TextStyle(
                                      //TODO: DYNAMIC COLOR CREATION
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
                              : SizedBox(),
                            ],
                          ),
                          SizedBox(height: MQuery.height(0.01, context)),
                          Row(
                            children: [
                              SizedBox(width: MQuery.width(0.003, context)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: Palette.handlesBackground,
                                ),
                                height: MQuery.height(0.05, context),
                                width: MQuery.width(0.325, context),
                                padding: EdgeInsets.only(
                                  left: MQuery.width(0.01, context)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset("assets/mdi_file-document.svg", height: 18, width: 18, color: Palette.primary),
                                        SizedBox(width: MQuery.width(0.01, context)),
                                        Text(
                                          "asn.pdf",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14
                                          )
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: (){},
                                      icon: AdaptiveIcon(
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
              )
            ],
          )
        );
  }
}