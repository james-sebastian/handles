part of "widgets.dart";

class MessageInfoBottomSheet extends ConsumerWidget {

  final int index; //TODO: MESSAGE UID FOR EVEN MORE FLEXIBILITY
  const MessageInfoBottomSheet({ Key? key, required this.index }) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {

    final _userService = watch(userProvider).getCurrentUser;

    return BottomSheet(
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ) 
      ),
      onClosing: (){},
      builder: (context){
        return StreamBuilder<UserModel>(
          stream: _userService,
          builder: (context, snapshot) {
            return snapshot.hasData
            ?  Container(
                height: MQuery.height(0.95, context),
                padding: EdgeInsets.all(
                  MQuery.height(0.02, context)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Font.out(
                            "Sent by:",
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            textAlign: TextAlign.start,
                            color: Colors.black.withOpacity(0.75)
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.fromLTRB(
                              MQuery.width(0, context),
                              MQuery.height(0.01, context),
                              MQuery.width(0, context),
                              0,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Palette.primary,
                              radius: MQuery.height(0.025, context),
                            ),
                            title: Font.out(
                              "${snapshot.data!.name} (You)",
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.start
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Font.out(
                      "Read by:",
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      color: Colors.black.withOpacity(0.75)
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index){
                            return ListTile(
                              contentPadding: EdgeInsets.fromLTRB(
                                MQuery.width(0, context),
                                MQuery.height(0.01, context),
                                MQuery.width(0, context),
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
                      ),
                    ),
                  ],
                )
              )
            : Center(
                child: CircularProgressIndicator(color: Palette.primary)
            );
          }
        );
      }
    );
  }
}