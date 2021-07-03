part of "../pages.dart";

class HandlesDetailedPage extends StatefulWidget {
  const HandlesDetailedPage({ Key? key }) : super(key: key);

  @override
  _HandlesDetailedPageState createState() => _HandlesDetailedPageState();
}

class _HandlesDetailedPageState extends State<HandlesDetailedPage> {

  bool isNotificationActive = true;
  TextEditingController paymentAddressController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    paymentAddressController.text = "123456789123";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            leadingWidth: MQuery.width(0.05, context),
            leading: IconButton(
              icon: AdaptiveIcon(
                android: Icons.arrow_back,
                iOS: CupertinoIcons.back,
              ),
              onPressed: (){
                Get.back();
              },
            ),
            actions: [
              IconButton(
                tooltip: "Settings",
                icon: AdaptiveIcon(
                  android: Icons.more_vert_rounded,
                  iOS: CupertinoIcons.ellipsis,
                ),
                onPressed: (){
                  
                }
              ),
            ],
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: top < 140 ? MQuery.width(0.06, context) : MQuery.width(0.02, context),
                    bottom: top < 140 ? MQuery.width(0.0185, context) : MQuery.width(0.02, context),
                    right: MQuery.width(0.02, context),
                  ),
                  title: Text(
                    "Handles DevTeam",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )
                  ),
                  background: Hero(
                    tag: "handles_picture",
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/handles_logo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.6)
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(MQuery.height(0.02, context)),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non dapibus eros. Duis facilisis faucibus accumsan. Sed sit amet convallis felis. Suspendisse non faucibus neque. Praesent sed enim ex. Pellentesque tempor sollicitudin dui vitae ultricies.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )
                  ),
                ),
                Divider(height: 1,),
                ListTile(
                  title: Text(
                    "Media, docs, meetings, products",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )
                  ),
                  trailing: Container(
                    width: MQuery.width(0.04, context),
                    child: Row(
                      children: [
                        Text(
                          "3",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          )
                        ),
                        Spacer(),
                        Icon(
                          CupertinoIcons.chevron_right,
                          size: 16,
                        ),
                      ],
                    )
                  ),
                  onTap: (){Get.to(() => HandlesMediasPage(), transition: Transition.cupertino);}
                ),
                Divider(height: 1,),
                ListTile(
                  shape: Border.symmetric(
                    vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                  ),
                  title: Text(
                    "Mute notifications",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )
                  ),
                  trailing: Switch(
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.withOpacity(0.5),
                    value: isNotificationActive,
                    onChanged: (bool val){

                      //TODO: NOTIFICATION TOGGLE

                      setState(() {
                        isNotificationActive = !isNotificationActive;
                      });
                    },
                  )
                ),
                Divider(height: 1,),
                ListTile(
                  onTap: (){
                  },
                  shape: Border.symmetric(
                    vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                  ),
                  title: Text(
                    "Chat visibility",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )
                  ),
                ),
                Divider(height: 1,),
                ListTile(
                  onTap: (){
                    Get.dialog(
                      Dialog(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MQuery.height(0.75, context)
                          ),
                          child: Container(
                            width: MQuery.width(0.9, context),
                            padding: EdgeInsets.all(MQuery.height(0.02, context)),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Handles DevTeam Payment Address",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Palette.primaryText,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  SizedBox(height: MQuery.height(0.02, context)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Palette.formColor,
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.number,
                                      controller: paymentAddressController,
                                      cursorColor: Palette.primary,
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        suffixIconConstraints: BoxConstraints(
                                          minWidth: 2,
                                          minHeight: 2,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            // Clipboard.setData(ClipboardData(text: widget.meetingModel.meetingURL));
                                          },
                                          icon: AdaptiveIcon(
                                            android: Icons.copy,
                                            iOS: CupertinoIcons.doc_on_clipboard_fill,
                                            color: Palette.primary,
                                            size: 20
                                          )
                                        ),
                                        fillColor: Palette.primary,
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(0.4)
                                        ),
                                        hintText: "Credit card hasn't provided yet",
                                        contentPadding: EdgeInsets.all(15),
                                        border: InputBorder.none
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MQuery.height(0.02, context)),
                                  Text(
                                    "This payment address (Credit Card) is officially afforded by this project's admin(s). Any form of transaction related to this project should be transferred to this address.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Palette.primaryText,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ]
                              )
                            )
                          )
                        )
                      )
                    );
                  },
                  shape: Border.symmetric(
                    vertical: BorderSide(color: Colors.grey.withOpacity(0.5))
                  ),
                  title: Text(
                    "Project payment address",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    )
                  ),
                ),
                Divider(height: 1,),
                SizedBox(height: MQuery.height(0.015, context)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MQuery.height(0.02, context)
                  ),
                  child: Font.out(
                    "Participants (5)",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    color: Colors.black.withOpacity(0.75)
                  ),
                ),
                Container(
                  height: MQuery.height(5 * 0.1, context),
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index){
                      return ListTile(
                        contentPadding: EdgeInsets.fromLTRB(
                          MQuery.width(0.02, context),
                          MQuery.height(0.01, context),
                          MQuery.width(0.02, context),
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
            )
          )
        ],
      ),
    );
  }
}