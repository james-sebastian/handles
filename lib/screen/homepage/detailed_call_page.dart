part of  "../pages.dart";

class DetailedCallPage extends ConsumerWidget {

  final CallModel callModel;
  final HandlesModel handlesModel;

  const DetailedCallPage({ Key? key, required this.callModel, required this.handlesModel}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      appBar: AppBar(
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
        title: Font.out(
          "Call Log Info",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.start,
          color: Colors.white
        ),
        actions: [
          // IconButton(
          //   icon: AdaptiveIcon(
          //     android: Icons.delete,
          //     iOS: CupertinoIcons.trash,
          //   ),
          //   onPressed: (){
          //     showDialog(
          //       context: context,
          //       builder: (context){
          //         return Platform.isAndroid
          //         ? AlertDialog(
          //             title: Text(
          //               "Are you sure you want to delete this call log?",
          //             ),
          //             content: Text(
          //               "This action is irreversible"
          //             ),
          //             actions: [
          //               TextButton(
          //                 child: Text("CANCEL"),
          //                 style: TextButton.styleFrom(
          //                   textStyle: TextStyle(
          //                     color: Palette.warning,
          //                     fontWeight: FontWeight.w500
          //                   )
          //                 ),
          //                 onPressed: (){
          //                   Get.back();
          //                 },
          //               ),
          //               TextButton(
          //                 child: Text("DELETE"),
          //                 style: TextButton.styleFrom(
          //                   textStyle: TextStyle(
          //                     color: Palette.primary,
          //                     fontWeight: FontWeight.w500
          //                   )
          //                 ),
          //                 onPressed: (){
          //                   Get.back();
          //                 },
          //               )
          //             ],
          //           )
          //         : CupertinoAlertDialog(
          //             title: Text(
          //               "Are you sure you want to delete this call log?",
          //             ),
          //             content: Text(
          //               "This action is irreversible"
          //             ),
          //             actions: [
          //               TextButton(
          //                 child: Text("CANCEL"),
          //                 style: TextButton.styleFrom(
          //                   textStyle: TextStyle(
          //                     color: Palette.warning,
          //                     fontWeight: FontWeight.w500
          //                   )
          //                 ),
          //                 onPressed: (){
          //                   Get.back();
          //                 },
          //               ),
          //               TextButton(
          //                 child: Text("DELETE"),
          //                 style: TextButton.styleFrom(
          //                   textStyle: TextStyle(
          //                     color: Palette.primary,
          //                     fontWeight: FontWeight.w500
          //                   )
          //                 ),
          //                 onPressed: (){
          //                   Get.back();
          //                 },
          //               )
          //             ],
          //           );
          //         }
          //       );
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MQuery.height(0.9, context),
          padding: EdgeInsets.all(MQuery.height(0.02, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<UserModel>(
                stream: watch(userProvider).getCurrentUser,
                builder: (context, snapshot) {
                  return snapshot.hasData
                  ? Row(
                      children: [
                        this.callModel.participants.first == snapshot.data!.id
                        ? AdaptiveIcon(
                            android: Icons.call_made,
                            iOS: CupertinoIcons.phone_fill_arrow_down_left,
                            size: 14,
                            color: Palette.secondary,
                          )
                        : this.callModel.participants.first != snapshot.data!.id && this.callModel.participants.indexOf(snapshot.data!.id) >= 0
                          ? AdaptiveIcon(
                              android: Icons.call_received,
                              iOS: CupertinoIcons.phone_fill_arrow_up_right,
                              size: 14,
                              color: Palette.primary,
                            )
                          : AdaptiveIcon(
                              android: Icons.call_missed,
                              iOS: CupertinoIcons.phone_fill_arrow_up_right,
                              size: 14,
                              color: Palette.warning,
                            ),
                        SizedBox(width: MQuery.width(0.0075, context)),
                        Font.out(
                          this.callModel.participants.first == snapshot.data!.id
                          ? "Outgoing call"
                          : this.callModel.participants.first != snapshot.data!.id && this.callModel.participants.indexOf(snapshot.data!.id) >= 0
                            ? "Received call"
                            : "Missed call",
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start,
                          color: Colors.black.withOpacity(0.75)
                        ),
                      ],
                    )
                  : SizedBox();
                }
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(
                  MQuery.width(0, context),
                  MQuery.height(0.01, context),
                  MQuery.width(0, context),
                  0,
                ),
              leading: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundColor: Palette.primary,
                    radius: MQuery.height(0.025, context),
                    backgroundImage: NetworkImage(this.handlesModel.cover)
                  ),
                ],
              ),
              title: Font.out(
                this.handlesModel.name,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start
              ),
              subtitle: StreamBuilder<UserModel>(
                stream: watch(userProvider).getCurrentUser,
                builder: (context, snapshot) {
                  return snapshot.hasData
                  ? Row(
                      children: [
                        this.callModel.participants.first == snapshot.data!.id
                        ? AdaptiveIcon(
                            android: Icons.call_made,
                            iOS: CupertinoIcons.phone_fill_arrow_down_left,
                            size: 14,
                            color: Palette.secondary,
                          )
                        : this.callModel.participants.first != snapshot.data!.id && this.callModel.participants.indexOf(snapshot.data!.id) >= 0
                          ? AdaptiveIcon(
                              android: Icons.call_received,
                              iOS: CupertinoIcons.phone_fill_arrow_up_right,
                              size: 14,
                              color: Palette.primary,
                            )
                          : AdaptiveIcon(
                              android: Icons.call_missed,
                              iOS: CupertinoIcons.phone_fill_arrow_up_right,
                              size: 14,
                              color: Palette.warning,
                            ),
                        SizedBox(width: MQuery.width(0.0075, context)),
                        Font.out(
                          "${DateFormat.yMd().format(this.callModel.startTime!)}, ${DateFormat.Hm().format(this.callModel.startTime!)}",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.start,
                          color: Colors.black.withOpacity(0.75)
                        ),
                      ],
                    )
                  : SizedBox();
                })
              ),
              Divider(),
              SizedBox(height: MQuery.height(0.01, context)),
              Font.out(
                "Participants (${this.callModel.participants.length})",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.start,
                color: Colors.black.withOpacity(0.75)
              ),
              Expanded(
                flex: 6,
                child: ListView.builder(
                  itemCount: this.callModel.participants.length,
                  itemBuilder: (context, index){
                    return FutureBuilder<UserModel>(
                      future: watch(userProvider).getUserByID(this.callModel.participants[index]),
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
                              backgroundImage: NetworkImage(snapshot.data!.profilePicture!)
                            ),
                            title: Font.out(
                              snapshot.data!.name,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.start
                            ),
                            trailing: this.callModel.participants.indexOf(snapshot.data!.id) >= 0
                            ? AdaptiveIcon(
                                android: Icons.call_received,
                                iOS: CupertinoIcons.phone_fill_arrow_up_right,
                                size: 14,
                                color: Palette.primary,
                              )
                            : AdaptiveIcon(
                                android: Icons.call_missed,
                                iOS: CupertinoIcons.phone_fill_arrow_up_right,
                                size: 14,
                                color: Palette.warning,
                              ),
                          )
                        : SizedBox();
                      }
                    );
                  },
                ),
              )
            ]
          ),
        ),
      )
    );
  }
}