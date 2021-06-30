part of 'widgets.dart';

class ImageChat extends StatelessWidget {
  final int index;
  final DateTime timestamp;
  final String sender;
  final String senderRole;
  final String imageURL;
  final String content;
  final bool isRecurring;
  final bool isPinned;

  const ImageChat({
    Key? key,
    required this.index,
    required this.timestamp,
    required this.sender,
    required this.senderRole,
    required this.imageURL,
    required this.isRecurring,
    required this.isPinned,
    required this.content
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sender == "a" //TODO: CHECK IF SENDER == USER ID
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
                    this.imageURL.length >= 30
                    ? 0.35
                    : this.imageURL.length <= 12
                      ? 0.15
                      : this.imageURL.length * 0.009
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
                      topRight: isRecurring ? Radius.circular(7) : Radius.circular(0),
                      topLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Get.to(() => ImagePreviewer(
                                imageURL: this.imageURL,
                                timeStamp: this.timestamp,
                                sender: this.sender,
                                heroTag: "image-$index",
                                content: this.content
                              ));
                            },
                            child: Hero(
                              tag: "image-$index",
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    child: Image.network(this.imageURL)
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
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
                                        Text(
                                          DateFormat.jm().format(timestamp),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
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
                      this.content == ""
                      ? SizedBox()
                      : Column(
                        children: [
                          SizedBox(height: MQuery.height(0.0075, context)),
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
                  height: MQuery.height(0.02, context),
                  width: MQuery.height(0.02, context),
                  color: this.isRecurring ? Palette.handlesBackground : Palette.primary
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
                color: this.isRecurring ? Palette.handlesBackground : Colors.white
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MQuery.width(
                    this.imageURL.length >= 30
                    ? 0.35
                    : this.imageURL.length <= 12
                      ? 0.15
                      : this.imageURL.length * 0.009
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
                      topLeft: isRecurring ? Radius.circular(7) : Radius.circular(0),
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
                          isRecurring
                          ? SizedBox()
                          : RichText(
                              text: TextSpan(
                                text: "${this.sender} ",
                                style: TextStyle(
                                  //TODO: DYNAMIC COLOR CREATION
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
                      GestureDetector(
                        onTap: (){
                          Get.to(() => ImagePreviewer(
                            imageURL: this.imageURL,
                            timeStamp: this.timestamp,
                            sender: this.sender,
                            heroTag: "image-$index",
                            content: this.content
                          ));
                        },
                        child: Hero(
                          tag: "image-$index",
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: Image.network(this.imageURL)
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat.jm().format(timestamp),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      this.content == ""
                      ? SizedBox()
                      : Column(
                        children: [
                          SizedBox(height: MQuery.height(0.0075, context)),
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
          )
        );
  }
}