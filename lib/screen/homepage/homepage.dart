part of "../pages.dart";

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  bool isHandlesSelected = false;
  bool isSearchActive = false;
  int isFilterChipSelected = -1;
  Set<int> selectedHandles = Set();

  @override
  Widget build(BuildContext context) {

    print(isHandlesSelected);
    print(selectedHandles);

    List<String> filterList = [
      "Photos", "Videos",
      "Docs", "Meetings", "Services"
    ];

    Map<String, Widget> filterAvatar = {
      "Photos": Icon(Icons.image, color: Colors.white, size: 20),
      "Videos": Icon(Icons.videocam, color: Colors.white, size: 20),
      "Docs": SvgPicture.asset("assets/mdi_file-document.svg", height: 18, width: 18),
      "Meetings": SvgPicture.asset("assets/mdi_presentation-play.svg", height: 18, width: 18),
      "Services": Icon(Icons.shopping_cart, color: Colors.white, size: 18)
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child:  Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: Palette.secondary,
            child: Icon(Icons.add, color: Colors.white, size: 28,),
            onPressed: (){},
          ),
          appBar: AppBar(
            elevation: isSearchActive ? 0 : 2.5,
            backgroundColor: Palette.primary,
            toolbarHeight: isSearchActive ? MQuery.height(0.07, context) : MQuery.height(0.125, context),
            leadingWidth: isHandlesSelected || isSearchActive
              ? MQuery.width(0.065, context)
              : MQuery.width(0, context),
            leading: isHandlesSelected || isSearchActive
              ? IconButton(
                  onPressed: (){
                    if(isSearchActive){
                      setState(() {
                        isSearchActive = false;
                      });
                    } else {
                      setState(() {
                        isHandlesSelected = false;
                        selectedHandles = Set();
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_back),
                )
              : SizedBox(width: 0),
            title: isHandlesSelected
              ? FadeIn(
                  child: Font.out(
                    "${selectedHandles.length}",
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                )
              : isSearchActive
                ? FadeIn(
                    child: Container(
                      width: MQuery.width(0.35, context),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search anything...",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 20,
                          )
                        ),
                      )
                    )
                  )
                : FadeIn(
                    child: Font.out(
                      "Handles",
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
            actions: [
              isHandlesSelected
              ? FadeIn(
                  child: Row(
                    children: [
                    IconButton(
                        tooltip: "Pin Handles",
                        icon: Icon(Icons.push_pin),
                        onPressed: (){}
                      ),
                      IconButton(
                        tooltip: "Settings",
                        icon: Icon(Icons.archive),
                        onPressed: (){}
                      ),
                    ],
                  ),
                )
              : isSearchActive
                ? FadeIn(
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: "Search",
                          icon: Icon(Icons.search),
                          onPressed: (){}
                        ),
                      ]
                    ),
                  )
                : FadeIn(
                    child: Row(
                      children: [
                      IconButton(
                          tooltip: "Search",
                          icon: Icon(Icons.search),
                          onPressed: (){
                            setState(() {
                              isSearchActive = true;
                            });
                          }
                        ),
                        IconButton(
                          tooltip: "Settings",
                          icon: Icon(Icons.more_vert_rounded),
                          onPressed: (){}
                        ),
                      ],
                    ),
                  )
            ],
            bottom: isSearchActive
            ? PreferredSize(child: SizedBox(), preferredSize: Size.fromHeight(0))
            : TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "CHATS"),
                Tab(text: "CALLS"),
              ],
            )
          ),
          body: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isSearchActive
                  ? Container(
                      color: Palette.primary,
                      width: MQuery.width(1, context),
                      height: MQuery.height(0.075, context),
                      padding: EdgeInsets.symmetric(
                        vertical: MQuery.height(0.01 ,context),
                        horizontal: MQuery.width(0.0225, context)
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: filterList.map((e){
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 8.0
                            ),
                            child: FilterChip(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 5
                              ),
                              shape: StadiumBorder(side: BorderSide(
                                color: filterList.indexOf(e) == isFilterChipSelected
                                ? Palette.filterSelected
                                : Palette.filterSelected.withOpacity(0.25)
                              )),
                              shadowColor: Colors.transparent,
                              backgroundColor: Palette.primary,
                              selectedColor: Palette.filterSelected,
                              elevation: 0,
                              showCheckmark: false,
                              avatar: filterAvatar[e],
                              label: Text(e),
                              labelStyle: TextStyle(
                                color: Colors.white
                              ),
                              selected: filterList.indexOf(e) == isFilterChipSelected,
                              onSelected: (bool selected) {
                                filterList.indexOf(e) != isFilterChipSelected
                                ? setState((){
                                    isFilterChipSelected = filterList.indexOf(e);
                                  })
                                : setState((){
                                    isFilterChipSelected = -1;
                                  });
                              },
                            ),
                          );
                        }).toList().cast<Widget>()        
                      ),
                  )
                  : SizedBox(),
                  Container(
                    height: isSearchActive ? MQuery.height(0.725, context) : MQuery.height(0.75, context),
                    child: ListView.builder(
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
                            color: //TODO: IF MESSAGE IS NEW, OPACITY 100% 
                              Colors.black.withOpacity(0.75)
                          ),
                          trailing: Container(
                            width: MQuery.width(0.07, context),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Font.out(
                                  "1:13 PM",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.start,
                                  color: Colors.black.withOpacity(0.75)
                                ),
                                //TODO: IF MESSAGE IS NEW // PINNED, DISPLAY INDICATOR / PINNED ICON
                                if (index >= 1)
                                  SizedBox()
                                else Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // CircleAvatar(
                                    //   backgroundColor: Palette.primary,
                                    //   radius: 10,
                                    //   child: Center(
                                    //     child: Font.out(
                                    //       "1",
                                    //       fontSize: 12
                                    //     ),
                                    //   ),
                                    // ),
                                    Icon(Icons.push_pin, size: 20)
                                  ],
                                )
                              ],
                            ),
                          )
                        );
                      }
                    )
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: GestureDetector(
                        child: Text(
                          "Archived Handles",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: Palette.primary
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}