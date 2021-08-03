part of '../pages.dart';

enum ItemAction{normal, edit, delete}

class MeetingDetailedPage extends StatefulWidget {

  final MeetingModel meetingModel;
  final String senderUID;
  final String userID;
  final String handlesID;

  const MeetingDetailedPage({
    Key? key,
    required this.meetingModel,
    required this.senderUID,
    required this.userID,
    required this.handlesID
  }) : super(key: key);

  @override
  _MeetingDetailedPageState createState() => _MeetingDetailedPageState();
}

class _MeetingDetailedPageState extends State<MeetingDetailedPage> {

  bool isError = false;
  TextEditingController _meetingURLController = TextEditingController();
  ItemAction itemAction = ItemAction.normal;

  Future<Favicon.Icon?> getFavicon(String url) async{
    try{
      return Favicon.Favicon.getBest(this.widget.meetingModel.meetingURL);
    } catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    _meetingURLController.text = widget.meetingModel.meetingURL;

    return Consumer(
      builder: (ctx, watch,child) {

        final _userProvider = watch(userProvider);

        if(itemAction == ItemAction.edit){
          Get.to(() => MeetingCreator(
            handlesID: widget.handlesID
          ));
        }

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
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white
              )
            ),
            actions: [
              widget.senderUID == widget.userID
              ? Row(
                  children: [
                    IconButton(
                      icon: AdaptiveIcon(
                        android: Icons.edit,
                        iOS: CupertinoIcons.pencil,
                      ),
                      onPressed: (){
                        Get.off(() => MeetingCreator(
                          handlesID: widget.handlesID,
                          meetingModel: widget.meetingModel
                        ));
                      }
                    )
                  ],
                )
              : SizedBox()
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
                              future: getFavicon(widget.meetingModel.meetingURL),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        widget.meetingModel.meetingStartTime.day != DateTime.now().day
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${DateFormat.yMMMMd('en_US').format(widget.meetingModel.meetingStartTime)}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                )
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          )
                                        : SizedBox(),
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
                                          Fluttertoast.showToast(
                                            msg: "Meets join link copied",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                          );
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
                                      return FutureBuilder<UserModel>(
                                        future: _userProvider.getUserByID(widget.meetingModel.attendees[index]),
                                        builder: (context, snapshot) {
                                          return snapshot.hasData
                                          ? ListTile(
                                              contentPadding: EdgeInsets.fromLTRB(
                                                MQuery.width(0, context),
                                                MQuery.height(0.01, context),
                                                MQuery.width(0, context),
                                                0,
                                              ),
                                              leading: CircleAvatar(
                                                backgroundColor: Palette.primary,
                                                radius: MQuery.height(0.025, context),
                                                backgroundImage: snapshot.data!.profilePicture != ""
                                                  ? NetworkImage(snapshot.data!.profilePicture ?? "") as ImageProvider
                                                  : AssetImage("assets/sample_profile.png")
                                              ),
                                              title: Font.out(
                                                snapshot.data!.name,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                textAlign: TextAlign.start
                                              ),
                                            )
                                          : SizedBox();
                                        }
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
                        ? Button(
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
      },
    );
  }
}