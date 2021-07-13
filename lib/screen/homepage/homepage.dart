part of "../pages.dart";

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  
  bool isHandlesSelected = false;
  bool isSearchActive = false;
  int isFilterChipSelected = -1;
  int activePage = 0;
  Set<String> selectedHandles = Set();
  Set<String> selectedPinnedHandles = Set();
  late TabController _tabController;

  @override
  void initState() { 
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(selectedHandles.length == 0 && selectedPinnedHandles.length == 0){
      setState(() {
        isHandlesSelected = false;
      });
    }

    return Consumer(
      builder: (context, watch, _){

        final _currentUserProvider = watch(currentUserProvider);
        final _handlesProvider = watch(handlesProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              backgroundColor: Palette.secondary,
              child: AdaptiveIcon(
                android: Icons.add,
                iOS: CupertinoIcons.add,
                color: Colors.white, size: 28,
              ),
              onPressed: (){
                Get.to(() => HandlesCreatorPage(), transition: Transition.cupertino);
              },
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
                          if(selectedPinnedHandles.isNotEmpty){
                            selectedPinnedHandles = Set();
                          } else {
                            selectedHandles = Set();
                          }
                        });
                      }
                    },
                    icon: AdaptiveIcon(
                      android: Icons.arrow_back,
                      iOS: CupertinoIcons.back,
                    ),
                  )
                : SizedBox(width: 0),
              title: isHandlesSelected
                ? FadeIn(
                    child: Font.out(
                      selectedPinnedHandles.isNotEmpty
                      ? "${selectedPinnedHandles.length}"
                      : "${selectedHandles.length}",
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
                ? _tabController.index == 0
                  ? FadeIn(
                      child: Row(
                        children: [
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
                                        "Are you sure you want to delete these Handles?",
                                      ),
                                      content: Text(
                                        "This action is irreversible and will make you leave this Handles without deleting the actual one"
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
                                            if(selectedPinnedHandles.isNotEmpty){
                                              _handlesProvider.deleteHandles(selectedPinnedHandles.toList());
                                            } else {
                                              _handlesProvider.deleteHandles(selectedHandles.toList());
                                            }
                                            setState(() {
                                              if(selectedPinnedHandles.isNotEmpty){
                                                selectedPinnedHandles = Set();
                                              } else {
                                                selectedHandles = Set();
                                              }
                                            });
                                            Get.back();
                                          },
                                        )
                                      ],
                                    )
                                  : CupertinoAlertDialog(
                                      title: Text(
                                        "Are you sure you want to delete this Handles?",
                                      ),
                                      content: Text(
                                        "This action is irreversible and will make you leave this Handles without deleting the actual one"
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
                          IconButton(
                            tooltip: "Pin Handles",
                            icon: AdaptiveIcon(
                              android: Icons.push_pin,
                              iOS: CupertinoIcons.pin_fill,
                            ),
                            onPressed: (){
                              if(selectedPinnedHandles.isNotEmpty){
                                _handlesProvider.unpinHandles(selectedPinnedHandles.toList());
                                setState(() {
                                  selectedPinnedHandles = Set();
                                });
                              } else {
                                _handlesProvider.pinHandles(selectedHandles.toList());
                                setState(() {
                                  selectedHandles = Set();
                                });
                              }
                            }
                          ),
                          IconButton(
                            tooltip: "Archive",
                            icon: AdaptiveIcon(
                              android: Icons.archive,
                              iOS: CupertinoIcons.archivebox_fill,
                            ),
                            onPressed: (){
                              _handlesProvider.archiveHandles(selectedHandles.toList());
                              setState(() {
                                selectedHandles = Set();
                              });
                            }
                          ),
                        ],
                      ),
                    )
                  : FadeIn(
                      child: Row(
                        children: [
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
                                        "Are you want to delete your call logs?",
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
                                            //TODO: DELETION LOGIC...
                                            Get.back();
                                          },
                                        )
                                      ],
                                    )
                                  : CupertinoAlertDialog(
                                      title: Text(
                                        "Are you want to delete your call logs?",
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
                    )
                : isSearchActive
                  ? FadeIn(
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: "Search",
                            icon: AdaptiveIcon(
                              android: Icons.search,
                              iOS: CupertinoIcons.search,
                            ),
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
                            icon: AdaptiveIcon(
                              android: Icons.search,
                              iOS: CupertinoIcons.search,
                            ),
                            onPressed: (){
                              setState(() {
                                isSearchActive = true;
                              });
                            }
                          ),
                          IconButton(
                            tooltip: "Settings",
                            icon: AdaptiveIcon(
                              android: Icons.more_vert_rounded,
                              iOS: CupertinoIcons.ellipsis,
                            ),
                            onPressed: (){
                              Get.to(() => SettingsPage(), transition: Transition.cupertino);
                            }
                          ),
                        ],
                      ),
                    )
              ],
              bottom: isSearchActive
              ? PreferredSize(child: SizedBox(), preferredSize: Size.fromHeight(0))
              : TabBar(
                  controller: _tabController,
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
            body: _currentUserProvider.when(
              data: (user){

                print("$selectedHandles (normal)");
                print("$selectedPinnedHandles (pinned)");

                return TabBarView(
                  controller: _tabController,
                  children: [
                    !(user.handlesList!.first == "" && user.handlesList!.length > 1)
                    ? EmptyHandles(
                        isHandlesPage: true
                      )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isSearchActive)
                        Container(
                          color: Palette.primary,
                          width: MQuery.width(1, context),
                          height: MQuery.height(0.075, context),
                          padding: EdgeInsets.symmetric(
                            vertical: MQuery.height(0.01 ,context),
                            horizontal: MQuery.width(0.0225, context)
                          ),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: Constants.filterList.map((e){
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
                                    color: Constants.filterList.indexOf(e) == isFilterChipSelected
                                    ? Palette.filterSelected
                                    : Palette.filterSelected.withOpacity(0.25)
                                  )),
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Palette.primary,
                                  selectedColor: Palette.filterSelected,
                                  elevation: 0,
                                  showCheckmark: false,
                                  avatar: Constants.filterAvatar[e],
                                  label: Text(e),
                                  labelStyle: TextStyle(
                                    color: Colors.white
                                  ),
                                  selected: Constants.filterList.indexOf(e) == isFilterChipSelected,
                                  onSelected: (bool selected) {
                                    Constants.filterList.indexOf(e) != isFilterChipSelected
                                    ? setState((){
                                        isFilterChipSelected = Constants.filterList.indexOf(e);
                                      })
                                    : setState((){
                                        isFilterChipSelected = -1;
                                      });
                                  },
                                ),
                              );
                            }).toList().cast<Widget>()        
                          ),
                        ) else
                        SizedBox(),
                        SubscriptionBanner(),
                        Expanded(
                          flex: 6,
                          child: Container(
                            child: ListView.builder(
                              itemCount: user.handlesList!.length - 1,
                              itemBuilder: (context, index){

                                final _singleHandlesProvider = watch(singleHandlesProvider(user.handlesList![index + 1]));

                                return _singleHandlesProvider.when(
                                  data: (handles){

                                    print(handles.cover);

                                    return handles.archivedBy!.indexOf(user.id) >= 0
                                    ? SizedBox()
                                    : ListTile(
                                        onLongPress: (){
                                          setState(() {
                                            isHandlesSelected = true;
                                            if(handles.pinnedBy!.indexOf(user.id) >= 0){
                                              selectedPinnedHandles.add(user.handlesList![index + 1]);
                                            } else {
                                              selectedHandles.add(user.handlesList![index + 1]);
                                            }
                                          });
                                        },
                                        onTap: (){
                                          if(isHandlesSelected){
                                            if(handles.pinnedBy!.indexOf(user.id) >= 0){
                                              if(selectedPinnedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                                setState(() {
                                                  selectedPinnedHandles.add(user.handlesList![index + 1]);
                                                });
                                              } else {
                                                setState(() {
                                                  print("a");
                                                  selectedPinnedHandles.remove(user.handlesList![index + 1]);
                                                });
                                              }
                                            } else {
                                              if(selectedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                                setState(() {
                                                  selectedHandles.add(user.handlesList![index + 1]);
                                                });
                                              } else {
                                                setState(() {
                                                  selectedHandles.remove(user.handlesList![index + 1]);
                                                });
                                              }
                                            }
                                          } else {
                                            Get.to(() => HandlesPage(
                                              handlesID: user.handlesList![index + 1]
                                            ), transition: Transition.cupertino);
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
                                            selectedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0 || selectedPinnedHandles.toList().indexOf(user.handlesList![index + 1]) >= 0
                                            ? ZoomIn(
                                                duration: Duration(milliseconds: 100),
                                                child: Positioned(
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    child: Icon(Icons.check, size: 12, color: Colors.white),
                                                    backgroundColor: Palette.secondary
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
                                          color: //TODO: IF MESSAGE IS NEW, OPACITY 100% 
                                            Colors.black.withOpacity(0.75)
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
                                                  handles.pinnedBy!.indexOf(user.id) >= 0
                                                  ? AdaptiveIcon(
                                                      android: Icons.push_pin,
                                                      iOS: CupertinoIcons.pin_fill,
                                                      size: 20
                                                    )
                                                  : SizedBox()
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      );
                                  },
                                  loading: () => SizedBox(),
                                  error: (_,__) => SizedBox()
                                );
                              }
                            )
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: GestureDetector(
                              onTap: (){
                                Get.to(() => ArchivedHandles(), transition: Transition.cupertino);
                              },
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
                    

                    //
                    ///-CALL PAGE-//
                    //


                    user.handlesList!.isEmpty
                    ? EmptyHandles(isHandlesPage: false)
                    : ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index){
                        return Column(
                          children: [
                            ListTile(
                              onLongPress: (){
                                setState(() {
                                  isHandlesSelected = true;
                                  selectedHandles.add(user.handlesList![index + 1]);
                                });
                              },
                              onTap: (){
                                if(isHandlesSelected){
                                  if(selectedHandles.toList().indexOf(user.handlesList![index + 1]) < 0){
                                    setState(() {
                                      selectedHandles.add(user.handlesList![index + 1]);
                                    });
                                  } else {
                                    setState(() {
                                      selectedHandles.remove(user.handlesList![index + 1]);
                                    });
                                  }
                                } else {
                                  Get.to(() => DetailedCallPage(), transition: Transition.cupertino);
                                }
                              },
                              contentPadding: EdgeInsets.fromLTRB(
                                MQuery.width(0.02, context),
                                index >= 1 ? 0 : MQuery.height(0.01, context),
                                MQuery.width(0.01, context),
                                0,
                              ),
                              leading: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Palette.primary,
                                    radius: MQuery.height(0.025, context),
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
                                "Handles DevTeam",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.start
                              ),
                              subtitle: Row(
                                children: [
                                  //TODO: PHONE STATUS LOGIC
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
                          ],
                        );
                      }
                    ),
                  ],
                );
              },
              loading: (){
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: Palette.primary)
                  )
                );
              },
              error: (object , error){
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: Palette.warning)
                  )
                );
              }
            ),
          ),
        );
      }
    );
  }
}