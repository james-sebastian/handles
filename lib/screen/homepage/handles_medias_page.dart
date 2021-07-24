part of "../pages.dart";

class HandlesMediasPage extends StatefulWidget {

  final String handlesID;
  final String currentUserID;
  const HandlesMediasPage({ Key? key, required this.handlesID, required this.currentUserID }) : super(key: key);

  @override
  _HandlesMediasPageState createState() => _HandlesMediasPageState();
}

class _HandlesMediasPageState extends State<HandlesMediasPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState(){ 
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Consumer(
          builder: (ctx, watch,child) {

            final _singleHandlesProvider = watch(singleHandlesProvider(widget.handlesID));
            final _handlesProvider = watch(handlesProvider);
            final _chatProvider = watch(chatProvider);

            return Scaffold(
              appBar: _singleHandlesProvider.when(
                data: (handles){
                  return AppBar(
                    backgroundColor: Palette.primary,
                    leading: IconButton(
                      icon: AdaptiveIcon(
                        android: Icons.arrow_back,
                        iOS: CupertinoIcons.back,
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                    ),
                    bottom: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          text: "All"
                        ),
                        Tab(text: "Medias"),
                        Tab(text: "Docs"),
                        Tab(text: "Projects"),
                        Tab(text: "Meets"),
                      ],
                    ),
                    title: Text("${handles.name}'s Medias"),
                  );
                },
                loading: () => AppBar(),
                error: (_,__) => AppBar(),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  StreamBuilder<List<ChatModel>>(
                    stream: _chatProvider.handlesChats(widget.handlesID),
                    builder: (context, snapshot) {

                      List<List<ChatModel>> mediaChats = [];
                      Set<String> mediaChatTimestamps = Set();

                      if(snapshot.hasData){
                        snapshot.data!.forEach((element) {
                          if(element.mediaURL != "" && element.deletedBy.indexOf(widget.currentUserID) < 0){
                            mediaChatTimestamps.add(element.timestamp.toString().substring(0, 10));
                          }
                        });
                      }

                      if(snapshot.hasData){
                        if(mediaChatTimestamps.isNotEmpty){
                          mediaChatTimestamps.forEach((date) {
                            List<ChatModel> dayChats = [];
                            snapshot.data!.forEach((chat){
                              if(chat.timestamp.toString().substring(0, 10) == date && chat.mediaURL != "" && chat.deletedBy.indexOf(widget.currentUserID) < 0){
                                print("anying");
                                dayChats.add(chat);
                              }
                            });
                            mediaChats.add(dayChats);
                          });
                        }
                      }

                      return snapshot.hasData
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: mediaChats.length, //day separator
                          itemBuilder: (context, index){

                            List<List<ChatModel>> dayMediaChats = [];
                            Set<ChatType> mediaChatType = Set();

                            snapshot.data!.forEach((element) {
                              if(element.mediaURL != "" && element.deletedBy.indexOf(widget.currentUserID) < 0){
                                mediaChatType.add(element.type);
                              }
                            });

                            if(mediaChatType.isNotEmpty){
                              mediaChatType.forEach((type) {
                                List<ChatModel> dayChats = [];
                                snapshot.data!.forEach((chat){
                                  if(chat.type == type && chat.mediaURL != "" && chat.deletedBy.indexOf(widget.currentUserID) < 0){
                                    dayChats.add(chat);
                                  }
                                });
                                dayMediaChats.add(dayChats);
                              });
                            }

                            print(dayMediaChats);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(dayMediaChats.length, (index){
                                return MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: Container(
                                    height: 125, // multiple by 3,
                                    child: GridView.builder(
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 1 / 1,
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0
                                      ),
                                      itemCount: dayMediaChats[index].length,
                                      itemBuilder: (BuildContext ctx, index2) {
                                        return Container(
                                          alignment: Alignment.center,
                                          child: Text(dayMediaChats[index][index2].type.toString()),
                                          color: Colors.white,
                                        );
                                      }
                                    ),
                                  ),
                                );
                              })
                            );
                          },
                        )
                      : SizedBox();
                    }
                  ),
                  Icon(Icons.directions_transit),
                  Icon(Icons.directions_bike),
                  Icon(Icons.directions_bike),
                  Icon(Icons.directions_bike),
                ],
              ),
            );
          },
        )
      ),
    );
  }
}