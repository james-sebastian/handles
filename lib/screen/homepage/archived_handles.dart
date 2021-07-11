part of "../pages.dart";

class ArchivedHandles extends StatefulWidget {
  const ArchivedHandles({ Key? key }) : super(key: key);

  @override
  _ArchivedHandlesState createState() => _ArchivedHandlesState();
}

class _ArchivedHandlesState extends State<ArchivedHandles> {

  bool isHandlesSelected = false;
  Set<String> selectedHandles = Set();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch,child) {

        final _currentUserProvider = watch(currentUserProvider);
        final _handlesProvider = watch(handlesProvider);

        return _currentUserProvider.when(
          data: (user){
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
                                        child: Text("RESTORE"),
                                        style: TextButton.styleFrom(
                                          textStyle: TextStyle(
                                            color: Palette.primary,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),
                                        onPressed: (){
                                          _handlesProvider.unarchiveHandles(selectedHandles.toList());
                                          setState(() {
                                            selectedHandles = Set();
                                          });
                                          Get.back();
                                        },
                                      )
                                    ],
                                  )
                                : CupertinoAlertDialog(
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
                                        child: Text("RESTORE"),
                                        style: TextButton.styleFrom(
                                          textStyle: TextStyle(
                                            color: Palette.primary,
                                            fontWeight: FontWeight.w500
                                          )
                                        ),
                                        onPressed: (){
                                          _handlesProvider.unarchiveHandles(selectedHandles.toList());
                                          setState(() {
                                            selectedHandles = Set();
                                          });
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
                itemCount: user.handlesList!.length - 1,
                itemBuilder: (context, index){

                  final _singleHandlesProvider = watch(singleHandlesProvider(user.handlesList![index + 1]));

                  return _singleHandlesProvider.when(
                    data: (handles){
                      return handles.archivedBy!.indexOf(user.id) >= 0
                      ? ListTile(
                          onLongPress: (){
                            setState(() {
                              isHandlesSelected = true;
                              selectedHandles.add(user.handlesList![index + 1]);
                            });
                          },
                          onTap: (){
                            if(isHandlesSelected){
                              print(selectedHandles.toList().indexOf(user.handlesList![index + 1]));
                              if(selectedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                setState(() {
                                  selectedHandles.add(user.handlesList![index + 1]);
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
                                backgroundImage: NetworkImage(handles.cover)
                              ),
                              selectedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0
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
                            handles.name,
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
                        )
                      : SizedBox();
                    },
                    loading: () => SizedBox(),
                    error: (_,__) => SizedBox(),
                  );
                }
              )
            );
          },
          loading: () => Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Palette.primary)
            )
          ),
          error: (_,__) => Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Palette.warning)
            )
          )
        );
      },
    );
  }
}