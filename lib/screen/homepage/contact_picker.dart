part of "../pages.dart";

class ContactPicker extends StatefulWidget {

  final void Function(UserModel, String)? addMember;
  final Map<String, String>? handlesMembers;
  final String? handlesID;
  const ContactPicker({ Key? key, this.handlesMembers, this.handlesID, this.addMember }) : super(key: key);

  @override
  _ContactPickerState createState() => _ContactPickerState();
}

class _ContactPickerState extends State<ContactPicker> {

  late ByteData imageData;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  Set<int> selectedContactsIndex = Set();
  Set<String> selectedContacts = Set();

  @override
  void initState() { 
    super.initState();
    rootBundle.load('assets/sample_profile.png').then((data) => setState(() => this.imageData = data));
  }

  @override
  Widget build(BuildContext context) {

    Future<void> askPermission() async {
      var status = await Permission.camera.status;
      if (status.isDenied) {
        Permission.contacts.request();
      }
    }

    askPermission();

    return Consumer(
      builder: (ctx, watch,child) {

        final _handlesProvider = watch(handlesProvider);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon:  AdaptiveIcon(
                android: Icons.close,
                iOS: CupertinoIcons.xmark,
                color: Colors.white
              ),
              onPressed: (){
                Get.back();
              }
            ),
            title: Text(
              "Invite collaborators from contact",
              style: TextStyle(
                fontSize: 18
              )
            ),
            actions: [
              IconButton(
                icon: AdaptiveIcon(
                  android: Icons.arrow_right_alt,
                  iOS: CupertinoIcons.chevron_right,
                  color: Colors.white
                ),
                onPressed: (){

                  int errorCount = 0;

                  selectedContacts.toList().forEach((element) {
                    print(element.trim().replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
                    _handlesProvider.addMember(element.trim().replaceAll(new RegExp(r"\s+\b|\b\s"), "")).then((value){
                      if(value == null){
                        errorCount++;
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$errorCount user with that phone number cannot be found.')));
                      } else {
                        if(widget.handlesID == null || widget.handlesMembers == ""){
                          widget.addMember!(
                            value,
                            "Member"
                          );
                        } else {
                          Map<String, String> newHandleMembers = widget.handlesMembers!;
                          newHandleMembers[value.id] = "Member";
                          _handlesProvider.addHandleCollaborators(value, newHandleMembers, widget.handlesID!, false);
                        }
                      }
                    });
                  });
                }
              )
            ],
          ),
          body: Container(
            height: MQuery.height(0.9, context),
            child: Column(
              children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(MQuery.height(0.02, context)),
                      child: Container(
                        height: MQuery.height(0.065, context),
                        width: MQuery.width(0.9, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Palette.formColor,
                        ),
                        child: Center(
                          child: TextFormField(
                            keyboardType: TextInputType.url,
                            controller: searchController,
                            cursorColor: Palette.primary,
                            style: TextStyle(
                              fontSize: 18
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    searchQuery = searchController.text;
                                  });
                                },
                                icon: AdaptiveIcon(
                                  android: Icons.search,
                                  iOS: CupertinoIcons.search,
                                  color: Palette.primary
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.4)
                              ),
                              hintText: "Search contact",
                              contentPadding: EdgeInsets.only(left: 20, top: 12.5),
                              border: InputBorder.none
                            ),
                            onEditingComplete: (){
                              setState(() {
                                searchQuery = searchController.text;
                                selectedContacts = Set();
                                selectedContactsIndex = Set();
                              });
                            },
                            onFieldSubmitted: (String value){
                              setState(() {
                                searchQuery = searchController.text;
                                selectedContacts = Set();
                                selectedContactsIndex = Set();
                              });
                            }
                          ),
                        ),
                      ),
                    )
                  ),
                  FutureBuilder<Iterable<Contact>>(
                    future: ContactsService.getContacts(withThumbnails: false, query: "$searchQuery"),
                    builder: (context, snapshot){

                      List<Contact> contacts = [];

                      if(snapshot.hasData){
                        contacts = snapshot.data!.toList();
                      }

                      print(selectedContacts);

                      return snapshot.hasData
                      ? Expanded(
                    flex: 15,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){

                        print(selectedContactsIndex.toList().indexOf(index));

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: MQuery.width(0.02, context)
                          ),
                          child: ListTile(
                            onTap: (){
                              print(contacts[index].phones!.first.value);
                              if(selectedContactsIndex.toList().indexOf(index) >= 0){
                                setState(() {
                                  selectedContactsIndex.remove(index);
                                  selectedContacts.remove(contacts[index].phones!.first.value);
                                });
                              } else {
                                setState(() {
                                  selectedContactsIndex.add(index);
                                  selectedContacts.add(contacts[index].phones!.first.value!);
                                });
                              }
                            },
                            contentPadding: EdgeInsets.zero,
                            title: Font.out(
                              contacts[index].displayName ?? "",
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.start
                            ),
                            trailing: selectedContactsIndex.toList().indexOf(index) >= 0
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
                          ),
                        );
                      }
                    ),
                  )
                : Center(
                  child: CircularProgressIndicator(color: Palette.primary)
                );
              }
            )
          ]
        )
          )
        );
      },
    );
  }
}