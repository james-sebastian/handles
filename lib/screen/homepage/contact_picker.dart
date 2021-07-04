part of "../pages.dart";

class ContactPicker extends StatefulWidget {
  const ContactPicker({ Key? key }) : super(key: key);

  @override
  _ContactPickerState createState() => _ContactPickerState();
}

class _ContactPickerState extends State<ContactPicker> {

  late ByteData imageData;
  TextEditingController searchController = TextEditingController();
  Set<String> selectedContacts = Set();

  @override
  void initState() { 
    super.initState();
    rootBundle.load('assets/sample_profile.png').then((data) => setState(() => this.imageData = data));
  }

  @override
  Widget build(BuildContext context) {

    print(selectedContacts);

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
          "Invite members from contact",
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
            }
          )
        ],
      ),
      body: Container(
        height: MQuery.height(0.9, context),
        child: FutureBuilder<List<Contact>>(
          future: Contacts.streamContacts(withHiResPhoto: false).toList(),
          builder: (context, snapshot){
            return snapshot.hasData
            ? Column(
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
                          keyboardType: TextInputType.text,
                          controller: searchController,
                          cursorColor: Palette.primary,
                          style: TextStyle(
                            fontSize: 18
                          ),
                          decoration: InputDecoration(
                            suffixIcon: AdaptiveIcon(
                              android: Icons.search,
                              iOS: CupertinoIcons.search,
                              color: Palette.primary
                            ),
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.4)
                            ),
                            hintText: "Search contact",
                            contentPadding: EdgeInsets.only(left: 20, top: 12.5),
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                  )
                ),
                Expanded(
                  flex: 15,
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: MQuery.width(0.02, context)
                          ),
                          child: ListTile(
                            onTap: (){
                              if(selectedContacts.toList().indexOf(snapshot.data![index].phones.first.value ?? "") >= 0){
                                setState(() {
                                  selectedContacts.remove(snapshot.data![index].phones.first.value ?? "");
                                });
                              } else {
                                setState(() {
                                  selectedContacts.add(snapshot.data![index].phones.first.value ?? "");
                                });
                              }
                            },
                            contentPadding: EdgeInsets.zero,
                            title: Font.out(
                              snapshot.data![index].displayName ?? "",
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.start
                            ),
                            trailing: selectedContacts.toList().indexOf(snapshot.data![index].phones.first.value ?? "") >= 0
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
                ]
              )
              : Center(
                child: CircularProgressIndicator(color: Palette.primary)
              );
          }
        )
      )
    );
  }
}