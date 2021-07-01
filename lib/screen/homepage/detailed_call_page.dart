part of  "../pages.dart";

class DetailedCallPage extends StatelessWidget {
  const DetailedCallPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: AdaptiveIcon(
              android: Icons.delete,
              iOS: CupertinoIcons.trash,
            ),
            onPressed: (){
              showDialog(
                context: context,
                builder: (context){
                  return Platform.isAndroid
                  ? AlertDialog(
                      title: Text(
                        "Are you sure you want to delete this call log?",
                      ),
                      content: Text(
                        "This action is irreversible"
                      ),
                      actions: [
                        TextButton(
                          child: Text("CANCEL"),
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              color: Palette.warning,
                              fontWeight: FontWeight.w500
                            )
                          ),
                          onPressed: (){
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: Text("DELETE"),
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              color: Palette.primary,
                              fontWeight: FontWeight.w500
                            )
                          ),
                          onPressed: (){
                            Get.back();
                          },
                        )
                      ],
                    )
                  : CupertinoAlertDialog(
                      title: Text(
                        "Are you sure you want to delete this call log?",
                      ),
                      content: Text(
                        "This action is irreversible"
                      ),
                      actions: [
                        TextButton(
                          child: Text("CANCEL"),
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              color: Palette.warning,
                              fontWeight: FontWeight.w500
                            )
                          ),
                          onPressed: (){
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: Text("DELETE"),
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              color: Palette.primary,
                              fontWeight: FontWeight.w500
                            )
                          ),
                          onPressed: (){
                            Get.back();
                          },
                        )
                      ],
                    );
                  }
                );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MQuery.height(0.9, context),
          padding: EdgeInsets.all(MQuery.height(0.02, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AdaptiveIcon(
                    android: Icons.call_made,
                    iOS: CupertinoIcons.phone_fill_arrow_down_left,
                    size: 18,
                    color: Palette.secondary,
                  ),
                  SizedBox(width: MQuery.width(0.0075, context)),
                  Font.out(
                    "Outgoing call",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.start,
                    color: Colors.black.withOpacity(0.75)
                  ),
                ],
              ),
              ListTile(
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
                  "Handles DevTeam",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start
                ),
                subtitle: Row(
                  children: [
                    AdaptiveIcon(
                      android: Icons.call_made,
                      iOS: CupertinoIcons.phone_fill_arrow_down_left,
                      size: 14,
                      color: Palette.secondary,
                    ),
                    SizedBox(width: MQuery.width(0.0075, context)),
                    Font.out(
                      "June 16, 7:43 AM",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.start,
                      color: Colors.black.withOpacity(0.75)
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: (){},
                  icon: AdaptiveIcon(
                    android: Icons.call,
                    iOS: CupertinoIcons.phone_fill,
                    color: Palette.primary,
                  ),
                )
              ),
              Divider(),
              SizedBox(height: MQuery.height(0.01, context)),
              Font.out(
                "Participants (5)",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.start,
                color: Colors.black.withOpacity(0.75)
              ),
              Expanded(
                flex: 6,
                child: ListView.builder(
                  itemCount: 5,
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
                        "Clark Kent",
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.start
                      ),
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