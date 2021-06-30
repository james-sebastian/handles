part of "../pages.dart";

class ArchivedHandles extends StatefulWidget {
  const ArchivedHandles({ Key? key }) : super(key: key);

  @override
  _ArchivedHandlesState createState() => _ArchivedHandlesState();
}

class _ArchivedHandlesState extends State<ArchivedHandles> {

  bool isHandlesSelected = false;
  Set<int> selectedHandles = Set();

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
          "Archived Handles",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.start,
          color: Colors.white
        ),
        actions: [
          isHandlesSelected
          ? Row(
              children: [
                IconButton(
                  icon: AdaptiveIcon(
                    android: Icons.restore,
                    iOS: CupertinoIcons.restart,
                  ),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return Platform.isAndroid
                        ? AlertDialog(
                            title: Text(
                              "Are you sure you want to restore these archived Handles?",
                            ),
                            content: Text(
                              "This action will make all of the selected Handles displayed in your homepage"
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
                                  //TODO: DELETION LOGIC...
                                  Get.back();
                                },
                              )
                            ],
                          )
                        : CupertinoAlertDialog(
                            //TODO: ASSIGN HANDLES NAME HERE...
                            title: Text(
                              "Are you sure you want to restore these archived Handles?",
                            ),
                            content: Text(
                              "This action will make all of the selected Handles displayed in your homepage"
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
                      },
                    );
                  }
                ),
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
                              "Are you sure you want to delete these archived Handles?",
                            ),
                            content: Text(
                              "This action is irreversible and will make you leave the Handles"
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
                                  //TODO: DELETION LOGIC...
                                  Get.back();
                                },
                              )
                            ],
                          )
                        : CupertinoAlertDialog(
                            //TODO: ASSIGN HANDLES NAME HERE...
                            title: Text(
                              "Are you sure you want to delete these archived Handles?",
                            ),
                            content: Text(
                              "This action is irreversible and will make you leave the Handles"
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
                )
              ],
            )
          : SizedBox()
        ],
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index){
          return ListTile(
            onLongPress: (){
              setState(() {
                isHandlesSelected = true;
                selectedHandles.add(index);
              });
            },
            onTap: (){
              if(isHandlesSelected){
                print(selectedHandles.toList().indexOf(index));
                if(selectedHandles.toList().indexOf(index) < 0){
                  setState(() {
                    selectedHandles.add(index);
                  });
                } else {
                  setState(() {
                    selectedHandles.remove(index);
                  });
                }
              }
            },
            contentPadding: EdgeInsets.fromLTRB(
              MQuery.width(0.02, context),
              index >= 1 ? MQuery.height(0.005, context) : MQuery.height(0.01, context),
              MQuery.width(0.02, context),
              MQuery.height(0.005, context),
            ),
            leading: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  backgroundColor: Palette.primary,
                  radius: MQuery.height(0.025, context),
                ),
                selectedHandles.toList().indexOf(index) >= 0
                ? ZoomIn(
                    duration: Duration(milliseconds: 100),
                    child: Positioned(
                      child: CircleAvatar(
                        backgroundColor: Palette.secondary,
                        radius: 10,
                        child: Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox()
              ],
            ),
            title: Font.out(
              "Handles DevTeam",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start
            ),
            subtitle: Font.out(
              "Steve: Great! no problem. Good luck!",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
              color: Colors.black.withOpacity(0.75)
            ),
            trailing: Container(
              width: MQuery.width(0.06, context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Font.out(
                    "1:13 PM",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    color: Colors.black.withOpacity(0.75)
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AdaptiveIcon(
                        android: Icons.archive,
                        iOS: CupertinoIcons.archivebox_fill,
                        size: 20
                      )
                    ],
                  )
                ],
              ),
            )
          );
        }
      )
    );
  }
}