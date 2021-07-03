part of "../pages.dart";

class ContactPicker extends StatefulWidget {
  const ContactPicker({ Key? key }) : super(key: key);

  @override
  _ContactPickerState createState() => _ContactPickerState();
}

class _ContactPickerState extends State<ContactPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.only(
          top: MQuery.width(0.0175, context)
        ),
        height: MQuery.height(0.9, context),
        child: StreamBuilder<Contact>(
          stream: Contacts.streamContacts(bufferSize: 50),
          builder: (context, snapshot){
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: MQuery.width(0.02, context)
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Palette.primary,
                      radius: MQuery.height(0.025, context),
                    ),
                    title: Font.out(
                      snapshot.data!.displayName ?? "",
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start
                    ),
                  ),
                );
              },
            );
          }
        )
      )
    );
  }
}