part of "../pages.dart";

class HandlesPage extends StatefulWidget {
  const HandlesPage({ Key? key }) : super(key: key);

  @override
  _HandlesPageState createState() => _HandlesPageState();
}

class _HandlesPageState extends State<HandlesPage> {

  late ScrollController _scrollController;
  bool isScrolling = false;
  bool isSearchActive = false;
  int isFilterChipSelected = -1;

  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(
      bottomOffset
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.addPostFrameCallback((_) => scrollToBottom());

    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    List<String> keys = [
      "Photos",
      "Videos",
      "Docs",
      "Meetings",
      "Services"
    ];

    return Scaffold(
      backgroundColor: Palette.handlesBackground,
      floatingActionButton: isScrolling
      ? FloatingActionButton(
          onPressed: (){},
        )
      : SizedBox(),
      appBar: AppBar(
        elevation: isSearchActive ? 0 : 1,
        toolbarHeight: MQuery.height(0.075, context),
        leadingWidth: MQuery.width(0.04, context),
        leading: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            child: AdaptiveIcon(
              android: Icons.arrow_back,
              iOS: CupertinoIcons.back,
            ),
            onTap: (){
              if(isSearchActive){
                setState(() {
                  isSearchActive = false;
                }); 
              } else {
                Get.back();
              }
            },
          ),
        ),
        title: isSearchActive
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
                    fontSize: 18,
                  )
                ),
              )
            )
          )
        : ListTile(
            onTap: (){
              Get.to(() => HandlesDetailedPage());
            },
            horizontalTitleGap: MQuery.width(0.0125, context),
            contentPadding: EdgeInsets.fromLTRB(
              MQuery.width(0, context),
              MQuery.height(0.01, context),
              MQuery.width(0, context),
              MQuery.height(0.0075, context),
            ),
            leading: Hero(
              tag: "handles_picture",
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/handles_logo.png"),
                radius: MQuery.height(0.0215, context),
              ),
            ),
            title: Font.out(
              "Handles DevTeam",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
              color: Colors.white
            ),
            subtitle: Font.out(
              "Andy, Grant, Steve, Mark, Luke, ...",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
              color: Colors.white.withOpacity(0.75)
            ),
          ),
        actions: [
          isSearchActive
          ? SizedBox()
          : IconButton(
            padding: EdgeInsets.zero,
            tooltip: "Make a Group Call",
            icon: AdaptiveIcon(
              android: Icons.add_call,
              iOS: CupertinoIcons.phone_solid,
            ),
            onPressed: (){}
          ),
          IconButton(
            tooltip: "Search",
            icon: AdaptiveIcon(
              android: Icons.search,
              iOS: CupertinoIcons.search
            ),
            onPressed: (){
              if(!isSearchActive){
                setState(() {
                  isSearchActive = true;
                });
              } else {
                //TODO: SEARCH MECHANISM HERE
              }
            }
          ),
        ],
      ),
      body: Column(
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
          isKeyboardOpen
          ? SizedBox()
          : Expanded(
              flex: 4,
              child: InkWell(
                onTap: (){
                  //TODO: LOGIC: CALCULATE TARGET POSITION BY LIST'S INDEX
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: MQuery.width(0.01, context),
                    right: MQuery.width(0.01, context)
                  ),
                  width: MQuery.width(1, context),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Pinned Message #5",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Palette.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Andy: Hello everyone, welcome to the Handles DevTeam! ...",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                              fontSize: 12
                            ),
                          ),
                        ] 
                      ),
                      AdaptiveIcon(
                        android: Icons.push_pin,
                        iOS: CupertinoIcons.pin_fill,
                        size: 16
                      ),
                    ],
                  )
                ),
              )
            ),
          Expanded(
            flex: isKeyboardOpen
              ? 23
              : isSearchActive
                ? 45
                : 50,
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              itemCount: 100,
              itemBuilder: (context, index){
                if (index == 0) {
                  return HandlesStatusBlock(
                    content: "Andy created “Handles DevTeam”"
                  );
                } else {
                  return index == 1
                  ? PlainChat(
                      timestamp: DateTime.now(),
                      sender: "Andy",
                      senderRole: "Admin",
                      isRecurring: false,
                      content: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                      isPinned: true,
                    )
                  : index == 2
                  ? PlainChat(
                      timestamp: DateTime.now(),
                      sender: "a",
                      senderRole: "",
                      isRecurring: false,
                      content: "Sure let's do it!",
                      isPinned: false
                    ) 
                  : index == 3
                  ? ImageChat(
                      index: index,
                      timestamp: DateTime.now(),
                      isRecurring: true,
                      isPinned: false,
                      sender: "a",
                      senderRole: "Admin",
                      imageURL: "https://images.pexels.com/photos/1054289/pexels-photo-1054289.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      content: "aaaaaaaaaaaaaaaaaa"
                    )
                  : index == 4
                  ? VideoChat(
                      index: index,
                      timestamp: DateTime.now(),
                      isRecurring: false,
                      isPinned: true,
                      sender: "Maya",
                      senderRole: "Admin",
                      videoURL: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
                      content: "aaaaaaaaaaaaaaaaaa"
                    )
                  : index == 5
                  ? AudioChat(
                      index: index,
                      timestamp: DateTime.now(),
                      isRecurring: false,
                      isPinned: true,
                      sender: "b",
                      senderRole: "Admin",
                      audioURL: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
                    )
                  : index == 6
                  ? DocumentChat(
                      index: index,
                      timestamp: DateTime.now(),
                      isRecurring: true,
                      isPinned: true,
                      sender: "b",
                      senderRole: "Admin",
                      documentURL: "http://www.africau.edu/images/default/sample.pdf",
                    )
                  : index == 7
                  ? MeetingChat(
                      index: index,
                      timestamp: DateTime.now(),
                      isRecurring: false,
                      isPinned: true,
                      sender: "a",
                      senderRole: "Admin",
                      meetingModel: MeetingModel(
                        meetingName: "Handles DevTeam Opening Meeting",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non dapibus eros. Duis facilisis faucibus accumsan. Sed sit amet convallis felis. Suspendisse non faucibus neque. Praesent sed enim ex. Pellentesque tempor sollicitudin dui vitae ultricies.",
                        meetingStartTime: DateTime.now(),
                        meetingURL: "https://meet.google.com/wyd-ytsf-kwi",
                        meetingEndTime: DateTime.now().add(Duration(hours: 2)),
                        attendees: //TODO: FILL ATTENDEES UID HERE
                        [
                          "Clark Kent",
                          "Bruce Wayne",
                          "Diana Prince"
                        ]
                      ),
                    )
                  : index == 8
                  ? ServiceChat(
                      index: index,
                      timestamp: DateTime.now(),
                      isRecurring: false,
                      isPinned: true,
                      sender: "Axxel",
                      senderRole: "Admin",
                      serviceModel: ServiceModel(
                        serviceName: "WebSocket: Upgrade",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non dapibus eros. Duis facilisis faucibus accumsan. Sed sit amet convallis felis. Suspendisse non faucibus neque. Praesent sed enim ex. Pellentesque tempor sollicitudin dui vitae ultricies.",
                        paymentStatus: ProjectPaymentStatus.unpaid,
                        status: ProjectStatus.in_progress,
                        milestones: [
                          MilestoneModel(
                            fee: 20,
                            paymentStatus: ProjectPaymentStatus.unpaid,
                            status: ProjectStatus.completed,
                            milestoneName: "Schematics Planning",
                            isCompleted: true,
                            description: "Planning for the project's schematics",
                            dueDate: DateTime.now().subtract(Duration(days: 2))
                          ),
                          MilestoneModel(
                            fee: 200,
                            paymentStatus: ProjectPaymentStatus.unpaid,
                            status: ProjectStatus.pending,
                            milestoneName: "Schematics Planning",
                            isCompleted: false,
                            description: "Planning for the project's schematics of lorem ipsum color si damet esquis sita gamma color si damet",
                            dueDate: DateTime.now().add(Duration(days: 2))
                          ),
                          MilestoneModel(
                            fee: 150,
                            paymentStatus: ProjectPaymentStatus.unpaid,
                            status: ProjectStatus.pending,
                            milestoneName: "Schematics Planning",
                            isCompleted: false,
                            description: "Planning for the project's schematics"
                          )
                        ]
                      ),
                    )
                  : SizedBox();
                }
              }
            ),
          ),
          Expanded(
            flex: isKeyboardOpen ? 4 : 5,
            child: Container(
              padding: EdgeInsets.only(
                left: MQuery.height(0.015, context),
                right: MQuery.height(0.015, context),
                bottom: MQuery.height(0.015, context)
              ),
              color: Palette.handlesBackground,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                      ),
                      child: TextFormField(
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          contentPadding: EdgeInsets.fromLTRB(
                            MQuery.width(0.02, context),
                            MQuery.height(0.0175, context),
                            MQuery.width(0.02, context),
                            MQuery.height(0, context)
                          ),
                          border: InputBorder.none
                        ),
                      )
                    ),
                  ),
                  SizedBox(width: MQuery.width(0.01, context)),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        Get.bottomSheet(
                          BottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              )
                            ),
                            onClosing: (){},
                            builder: (context){
                              return Container(
                                padding: EdgeInsets.all(
                                  MQuery.height(0.02, context)
                                ),
                                height: MQuery.height(0.275, context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: MQuery.height(0.1, context),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                              Get.to(() => PickImagesPage(), transition: Transition.cupertino);
                                            },
                                            child: Constants.mediaAvatar[keys[0]],
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(20),
                                              primary: Palette.primary, // <-- Button color
                                              onPrimary: Palette.primary, // <-- Splash color
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: MQuery.height(0.1, context),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                              Get.to(() => PickVideosPage(), transition: Transition.cupertino);
                                            },
                                            child: Constants.mediaAvatar[keys[1]],
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(20),
                                              primary: Palette.primary, // <-- Button color
                                              onPrimary: Palette.primary, // <-- Splash color
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: MQuery.height(0.1, context),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                                              if(result != null) {
                                                PlatformFile file = result.files.first;
                                                showDialog(
                                                  context: context,
                                                  builder: (context){
                                                    return Platform.isAndroid
                                                    ? AlertDialog(
                                                        content: Text(
                                                          //TODO: ASSIGN HANDLES NAME HERE...
                                                          'Send file: "${file.name}" to Handles DevTeam?'
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
                                                            child: Text("SEND"),
                                                            style: TextButton.styleFrom(
                                                              textStyle: TextStyle(
                                                                color: Palette.primary,
                                                                fontWeight: FontWeight.w500
                                                              )
                                                            ),
                                                            onPressed: (){
                                                              Get.back();
                                                              //TODO: FILE SEND LOGIC...
                                                            },
                                                          )
                                                        ],
                                                      )
                                                    : CupertinoAlertDialog(
                                                        content: Text(
                                                          //TODO: ASSIGN HANDLES NAME HERE...
                                                          'Send file: "${file.name}" to Handles DevTeam?'
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
                                                            child: Text("SEND"),
                                                            style: TextButton.styleFrom(
                                                              textStyle: TextStyle(
                                                                color: Palette.primary,
                                                                fontWeight: FontWeight.w500
                                                              )
                                                            ),
                                                            onPressed: (){
                                                              Get.back();
                                                              //TODO: FILE SEND LOGIC...
                                                            },
                                                          )
                                                        ],
                                                      );
                                                  }
                                                );
                                              } else {
                                                // User canceled the picker
                                              }
                                            },
                                            child: Constants.mediaAvatar[keys[2]],
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(20),
                                              primary: Palette.primary, // <-- Button color
                                              onPrimary: Palette.primary, // <-- Splash color
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: MQuery.height(0.025, context)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: MQuery.height(0.1, context),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                              Get.to(() => MeetingCreator(), transition: Transition.cupertino);
                                            },
                                            child: Constants.mediaAvatar[keys[3]],
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(20),
                                              primary: Palette.primary, // <-- Button color
                                              onPrimary: Palette.primary, // <-- Splash color
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: MQuery.height(0.1, context),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                              Get.to(() => ProjectCreator(), transition: Transition.cupertino);
                                            },
                                            child: Constants.mediaAvatar[keys[4]],
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(20),
                                              primary: Palette.primary, // <-- Button color
                                              onPrimary: Palette.primary, // <-- Splash color
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Constants.mediaAvatar[keys[2]],
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(20),
                                            primary: Colors.transparent, // <-- Button color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              );
                            }
                          )
                        );
                      },
                      child: CircleAvatar(
                        radius: MQuery.height(0.2, context),
                        backgroundColor: Palette.secondary,
                        child: AdaptiveIcon(
                          android: Icons.add,
                          iOS: CupertinoIcons.add,
                          color: Colors.white, size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            )
          )
        ],
      ),
    );
  }
}