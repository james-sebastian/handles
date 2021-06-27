part of "../pages.dart";

class HandlesPage extends StatefulWidget {
  const HandlesPage({ Key? key }) : super(key: key);

  @override
  _HandlesPageState createState() => _HandlesPageState();
}

class _HandlesPageState extends State<HandlesPage> {

  late ScrollController _scrollController;
  bool isScrolling = false;

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
              Get.back();
            },
          ),
        ),
        title: ListTile(
          onTap: (){},
          horizontalTitleGap: MQuery.width(0.0075, context),
          contentPadding: EdgeInsets.fromLTRB(
            MQuery.width(0, context),
            MQuery.height(0.01, context),
            MQuery.width(0, context),
            MQuery.height(0.0075, context),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: MQuery.height(0.0215, context),
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
          IconButton(
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
            onPressed: (){}
          ),
        ],
      ),
      body: Column(
        children: [
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
            flex: isKeyboardOpen ? 23 : 50,
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
                      content: "Hello everyone, welcome to the Handles DevTeam! \nBefore we add our client’s representatives into this group, I would like to hold a meeting and discuss a proper workflow in the future. ",
                      isPinned: true,
                    )
                  : index == 2
                    ? PlainChat(
                        timestamp: DateTime.now(),
                        sender: "a",
                        senderRole: "",
                        isRecurring: false,
                        content: "Sure let's do it!aaaaaaaaa",
                        isPinned: false
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
                                            onPressed: () {},
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
                                            onPressed: () {},
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
                                            onPressed: () {},
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
                                            onPressed: () {},
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
                                            onPressed: () {},
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