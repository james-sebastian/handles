part of "../pages.dart";

class HandlesMediasPage extends StatefulWidget {
  const HandlesMediasPage({ Key? key }) : super(key: key);

  @override
  _HandlesMediasPageState createState() => _HandlesMediasPageState();
}

class _HandlesMediasPageState extends State<HandlesMediasPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() { 
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
              onPressed: (){
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