part of 'widgets.dart';

class MeetingChat extends StatefulWidget {
  final int index;
  final DateTime timestamp;
  final String handlesID;
  final String userID;
  final String sender;
  final String senderRole;
  final MeetingModel meetingModel;
  final bool isRecurring;
  final bool isPinned;

  const MeetingChat(
      {Key? key,
      required this.index,
      required this.timestamp,
      required this.handlesID,
      required this.sender,
      required this.senderRole,
      required this.meetingModel,
      required this.isRecurring,
      required this.isPinned,
      required this.userID})
      : super(key: key);

  @override
  _MeetingChatState createState() => _MeetingChatState();
}

class _MeetingChatState extends State<MeetingChat> {
  @override
  Widget build(BuildContext context) {

    Future<Favicon.Icon?> getFavicon(String url) async {
      try {
        return Favicon.Favicon.getBest(this.widget.meetingModel.meetingURL);
      } catch (e) {
        print(e);
      }
    }

    Future<void> activateNotification() async {
      FlutterAppBadger.updateBadgeCount(1);
      print("FIRED!!!");
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Random().nextInt(1000),
          channelKey: 'scheduled',
          title: widget.meetingModel.meetingName,
          body: '${widget.meetingModel.meetingName} is going to start in 5 minutes. Click here to join it!',
          notificationLayout: NotificationLayout.Default,
          payload: {
            "link": widget.meetingModel.meetingURL
          }
        ),
        schedule: NotificationCalendar.fromDate(date: widget.meetingModel.meetingStartTime.subtract(5.minutes))
      );
    }

    return Consumer(
      builder: (ctx, watch, child) {

        final _userProvider = watch(userProvider);

        return widget.sender == widget.userID
            ? GestureDetector(
                onTap: () {
                  Get.to(
                      () => MeetingDetailedPage(
                          meetingModel: this.widget.meetingModel,
                          senderUID: this.widget.sender,
                          handlesID: widget.handlesID,
                          userID: widget.userID),
                      transition: Transition.cupertino);
                },
                child: Container(
                    width: MQuery.width(1, context),
                    margin:
                        EdgeInsets.only(bottom: MQuery.width(0.01, context)),
                    padding: EdgeInsets.symmetric(
                        horizontal: MQuery.width(0.01, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: MQuery.width(0.35, context),
                              minWidth: MQuery.width(0.1, context),
                              minHeight: MQuery.height(0.045, context)),
                          child: Container(
                              padding:
                                  EdgeInsets.all(MQuery.height(0.01, context)),
                              decoration: BoxDecoration(
                                  color: Palette.primary,
                                  borderRadius: BorderRadius.only(
                                      topRight: widget.isRecurring
                                          ? Radius.circular(7)
                                          : Radius.circular(0),
                                      topLeft: Radius.circular(7),
                                      bottomRight: Radius.circular(7),
                                      bottomLeft: Radius.circular(7))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: MQuery.height(0.09, context),
                                        width: MQuery.height(0.09, context),
                                        decoration: BoxDecoration(
                                          color: Palette.handlesBackground,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: FutureBuilder<Favicon.Icon?>(
                                          future: getFavicon(this
                                              .widget
                                              .meetingModel
                                              .meetingURL),
                                          builder: (context, snapshot) {
                                            return snapshot.hasData
                                                ? Padding(
                                                    padding: EdgeInsets.all(
                                                        MQuery.height(
                                                            0.015, context)),
                                                    child: Image.network(
                                                        snapshot.data!.url))
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator());
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Expanded(
                                          flex: 15,
                                          child: Container(
                                            height:
                                                MQuery.height(0.09, context),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                    widget.meetingModel
                                                        .meetingName,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white)),
                                                Text(
                                                    "${DateFormat.jm().format(widget.meetingModel.meetingStartTime)} - ${DateFormat.jm().format(widget.meetingModel.meetingEndTime)}",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white)),
                                                Text(
                                                    widget
                                                      .meetingModel
                                                      .description
                                                      .length >= 30
                                                        ? widget.meetingModel
                                                                .description
                                                                .substring(
                                                                    0, 26) +
                                                            "..."
                                                        : widget.meetingModel
                                                            .description,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white))
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: MQuery.height(0.01, context)),
                                    widget.meetingModel.meetingStartTime.isAfter(DateTime.now())
                                      ? Builder(
                                          builder: (context) {

                                            activateNotification();

                                            return Button(
                                              height: MQuery.height(0.045, context),
                                              width: double.infinity,
                                              color: Palette.secondary,
                                              method: () {},
                                              textColor: Colors.white,
                                              title: "Reminder Active",
                                            );
                                          }
                                        )
                                      : widget.meetingModel.meetingStartTime
                                                  .isBefore(DateTime.now()) &&
                                              widget.meetingModel.meetingEndTime
                                                  .isAfter(DateTime.now())
                                          ? Button(
                                              height:
                                                  MQuery.height(0.045, context),
                                              width: double.infinity,
                                              color: Palette.primary,
                                              borderColor: Colors.white,
                                              method: () async {
                                                await launch(widget
                                                    .meetingModel.meetingURL);
                                              },
                                              textColor: Colors.white,
                                              title: "Join Meeting",
                                            )
                                          : Button(
                                              height:
                                                  MQuery.height(0.045, context),
                                              width: double.infinity,
                                              color: Palette.secondary,
                                              method: () {},
                                              textColor: Colors.white,
                                              title: "Completed",
                                            ),
                                  SizedBox(
                                      height: MQuery.height(0.01, context)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      widget.isPinned
                                          ? AdaptiveIcon(
                                              android: Icons.push_pin,
                                              iOS: CupertinoIcons.pin_fill,
                                              size: 12,
                                              color:
                                                  Colors.white.withOpacity(0.5))
                                          : SizedBox(),
                                      SizedBox(
                                          width: MQuery.width(0.005, context)),
                                      Text(
                                        DateFormat.jm()
                                            .format(widget.timestamp),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
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
                    )),
              )
            : FutureBuilder<UserModel>(
                future: _userProvider.getUserByID(widget.sender),
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                          () => MeetingDetailedPage(
                              meetingModel: this.widget.meetingModel,
                              senderUID: this.widget.sender,
                              userID: this.widget.userID,
                              handlesID: this.widget.handlesID),
                          transition: Transition.cupertino);
                    },
                    child: Container(
                        width: MQuery.width(1, context),
                        margin: EdgeInsets.only(
                            bottom: MQuery.width(0.01, context)),
                        padding: EdgeInsets.symmetric(
                            horizontal: MQuery.width(0.01, context)),
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
                                  maxWidth: MQuery.width(0.35, context),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        widget.isRecurring &&
                                                widget.isPinned != true
                                            ? SizedBox()
                                            : RichText(
                                                text: TextSpan(
                                                  text:
                                                      "${snapshot.data!.name}",
                                                  style: TextStyle(
                                                      color: Palette.primary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "(${this.widget.senderRole})",
                                                        style: TextStyle(
                                                            color:
                                                                Palette.primary,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              ),
                                        widget.isPinned
                                            ? AdaptiveIcon(
                                                android: Icons.push_pin,
                                                iOS: CupertinoIcons.pin_fill,
                                                size: 12)
                                            : SizedBox()
                                      ],
                                    ),
                                    SizedBox(
                                        height: MQuery.height(0.005, context)),
                                    Row(
                                      children: [
                                        Container(
                                          height: MQuery.height(0.09, context),
                                          width: MQuery.height(0.09, context),
                                          decoration: BoxDecoration(
                                            color: Palette.handlesBackground,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: FutureBuilder<Favicon.Icon?>(
                                            future: getFavicon(this
                                                .widget
                                                .meetingModel
                                                .meetingURL),
                                            builder: (context, snapshot) {
                                              return snapshot.hasData
                                                  ? Padding(
                                                      padding: EdgeInsets.all(
                                                          MQuery.height(
                                                              0.015, context)),
                                                      child: Image.network(
                                                          snapshot.data!.url))
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator());
                                            },
                                          ),
                                        ),
                                        Spacer(),
                                        Expanded(
                                            flex: 15,
                                            child: Container(
                                              height:
                                                  MQuery.height(0.09, context),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                      widget.meetingModel
                                                          .meetingName,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(
                                                      "${DateFormat.jm().format(widget.meetingModel.meetingStartTime)} - ${DateFormat.jm().format(widget.meetingModel.meetingEndTime)}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Text(
                                                      widget
                                                                  .meetingModel
                                                                  .description
                                                                  .length >=
                                                              30
                                                          ? widget.meetingModel
                                                                  .description
                                                                  .substring(
                                                                      0, 26) +
                                                              "..."
                                                          : widget.meetingModel
                                                              .description,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400))
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: MQuery.height(0.01, context)),
                                      widget.meetingModel.meetingStartTime.isAfter(DateTime.now())
                                        ? Builder(
                                          builder: (context) {
                                            activateNotification();
                                            return Button(
                                                height:
                                                    MQuery.height(0.045, context),
                                                width: double.infinity,
                                                color: Colors.white,
                                                borderColor: Palette.secondary,
                                                method: () {},
                                                textColor: Palette.secondary,
                                                title: "Reminder Active",
                                              );
                                            }
                                          )
                                        : widget.meetingModel.meetingStartTime.isBefore(DateTime.now()) && widget.meetingModel.meetingEndTime.isAfter(DateTime.now())
                                          ? Button(
                                              height: MQuery.height(
                                                  0.045, context),
                                              width: double.infinity,
                                              color: Palette.primary,
                                              method: () async {
                                                await launch(widget
                                                    .meetingModel.meetingURL);
                                              },
                                              textColor: Colors.white,
                                              title: "Join Meeting",
                                            )
                                          : Button(
                                              height: MQuery.height(
                                                  0.045, context),
                                              width: double.infinity,
                                              color: Palette.secondary,
                                              method: () {},
                                              textColor: Colors.white,
                                              title: "Completed",
                                            ),
                                    SizedBox(
                                        height: MQuery.height(0.01, context)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
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
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  );
                });
      },
    );
  }
}
