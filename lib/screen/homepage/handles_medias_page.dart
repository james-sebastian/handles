part of "../pages.dart";

class HandlesMediasPage extends StatefulWidget {
  const HandlesMediasPage({ Key? key }) : super(key: key);

  @override
  _HandlesMediasPageState createState() => _HandlesMediasPageState();
}

class _HandlesMediasPageState extends State<HandlesMediasPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  Future<String> createFolder(String folderName) async {
    final path = Directory("storage/emulated/0/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } else {
      print("a");
    }
    if ((await path.exists())) {
      print("existed");
      return path.path;
    } else {
      print("created");
      path.create();
      return path.path;
    }
  }

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
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Palette.primary,
            leading: IconButton(
              icon: AdaptiveIcon(
                android: Icons.arrow_back,
                iOS: CupertinoIcons.back,
              ),
              onPressed: () async {
                createFolder("handles");
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
            title: Text("Handles DevTeam's Medias"),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}