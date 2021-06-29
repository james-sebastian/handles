part of '../pages.dart';

class MeetingDetailedPage extends StatefulWidget {

  final MeetingModel meetingModel;
  final String senderUID;

  const MeetingDetailedPage({
    Key? key,
    required this.meetingModel,
    required this.senderUID
  }) : super(key: key);

  @override
  _MeetingDetailedPageState createState() => _MeetingDetailedPageState();
}

class _MeetingDetailedPageState extends State<MeetingDetailedPage> {

  bool isError = false;
  TextEditingController _meetingURLController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _meetingURLController.text = widget.meetingModel.meetingURL;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.primary,
        toolbarHeight: MQuery.height(0.07, context),
        leading: IconButton(
          icon: AdaptiveIcon(
            android: Icons.arrow_back,
            iOS: CupertinoIcons.back,
          ),
          onPressed: (){
            Get.back();
          },
        ),
        title: Text(
          "Meeting Details",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white
          )
        ),
        actions: [
          //TODO: IF CURRENT UID == SENDER UID DISPLAY EDIT ICON
          // IconButton(
          //   tooltip: "Settings",
          //   icon: AdaptiveIcon(
          //     android: Icons.more_vert_rounded,
          //     iOS: CupertinoIcons.ellipsis,
          //   ),
          //   onPressed: (){}
          // ),
        ]
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MQuery.height(0.93, context),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: MQuery.height(1, context),
                        color: Palette.handlesBackground,
                        child: FutureBuilder<Favicon.Icon?>(
                          future: Favicon.Favicon.getBest(this.widget.meetingModel.meetingURL),
                          builder: (context, snapshot){
                            return snapshot.hasData
                            ? Padding(
                                padding: EdgeInsets.all(MQuery.height(0.05, context)),
                                child: Image.network(snapshot.data!.url)
                              )
                            : Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 16,
                      child: Container(
                        height: MQuery.height(0.3, context),
                        width: MQuery.height(1, context),
                        color: Colors.white,
                        padding: EdgeInsets.all(
                          MQuery.height(0.02, context)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.meetingModel.meetingName,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: MQuery.height(0.015, context)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.meetingModel.meetingStartTime.isAfter(DateTime.now())
                                ? GeneralStatusTag(
                                    status: "NOT STARTED",
                                    color: Palette.tertiary
                                  )
                                : widget.meetingModel.meetingStartTime.isBefore(DateTime.now()) && widget.meetingModel.meetingEndTime.isAfter(DateTime.now())
                                ? GeneralStatusTag(
                                    status: "LIVE",
                                    color: Palette.primary
                                  )
                                : GeneralStatusTag(
                                    status: "COMPLETED",
                                    color: Palette.secondary
                                  ),
                                Text(
                                  "${DateFormat.jm().format(widget.meetingModel.meetingStartTime)} - ${DateFormat.jm().format(widget.meetingModel.meetingEndTime)}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  )
                                ),
                              ],
                            ),
                            SizedBox(height: MQuery.height(0.015, context)),
                            Divider(),
                            SizedBox(height: MQuery.height(0.015, context)),
                            Container(
                              decoration: BoxDecoration(
                                color: Palette.formColor,
                                borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: TextFormField(
                                readOnly: true,
                                keyboardType: TextInputType.url,
                                controller: _meetingURLController,
                                cursorColor: Palette.primary,
                                style: TextStyle(
                                  fontSize: 16
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  suffixIconConstraints: BoxConstraints(
                                    minWidth: 2,
                                    minHeight: 2,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      Clipboard.setData(ClipboardData(text: widget.meetingModel.meetingURL));
                                    },
                                    icon: AdaptiveIcon(
                                      android: Icons.copy,
                                      iOS: CupertinoIcons.doc_on_clipboard_fill,
                                      color: Palette.primary,
                                      size: 20
                                    )
                                  ),
                                  fillColor: Palette.primary,
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: isError ? Palette.warning : Colors.black.withOpacity(0.4)
                                  ),
                                  hintText: "Fill the meeting's join / invitation link",
                                  contentPadding: EdgeInsets.all(15),
                                  border: InputBorder.none
                                ),
                              ),
                            ),
                            SizedBox(height: MQuery.height(0.015, context)),
                            Text(
                              widget.meetingModel.description,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )
                            ),
                            SizedBox(height: MQuery.height(0.0075, context)),
                            Divider(),
                            SizedBox(height: MQuery.height(0.005, context)),
                            Text(
                              "Attendees",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            Container(
                              height: MQuery.height(0.25, context),
                              child: ListView.builder(
                                itemCount: widget.meetingModel.attendees.length,
                                itemBuilder: (context, index){
                                  return ListTile(
                                    contentPadding: EdgeInsets.fromLTRB(
                                      MQuery.width(0, context),
                                      MQuery.height(0.01, context),
                                      MQuery.width(0, context),
                                      0,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Palette.primary,
                                      radius: MQuery.height(0.025, context),
                                    ),
                                    title: Font.out(
                                      widget.meetingModel.attendees[index],
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      textAlign: TextAlign.start
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]
                        )
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      MQuery.height(0.0375, context),
                      MQuery.height(0, context),
                      MQuery.height(0.0375, context),
                      MQuery.height(0.075, context),
                    ),
                    child: widget.meetingModel.meetingStartTime.isAfter(DateTime.now())
                    ? //TODO: REMINDER LOGIC HERE
                      Button(
                        width: double.infinity - MQuery.width(0.075, context),
                        color: Colors.white,
                        borderColor: Palette.secondary,
                        method: (){},
                        textColor: Palette.secondary,
                        title: "Reminder Active",
                      )
                    : widget.meetingModel.meetingStartTime.isBefore(DateTime.now()) && widget.meetingModel.meetingEndTime.isAfter(DateTime.now())
                    ? Button(
                        width: double.infinity - MQuery.width(0.075, context),
                        color: Palette.primary,
                        method: () async {
                          await launch(widget.meetingModel.meetingURL);
                        },
                        textColor: Colors.white,
                        title: "Join Meeting",
                      )
                    : Button(
                        width: double.infinity - MQuery.width(0.075, context),
                        color: Palette.secondary,
                        method: (){},
                        textColor: Colors.white,
                        title: "Completed",
                      ),
                  ),

                )
              ],
            )
          ),
        )
      )
    );
  }
}