part of "widgets.dart";

class HandlesStatusBlock extends StatelessWidget {

  final int index;
  final String sender;
  final String userID;
  final String handlesID;
  final String chatID;
  final List<String> readBy;
  final String content;
  final bool isDateBlock;

  const HandlesStatusBlock({
    Key? key,
    required this.content,
    required this.isDateBlock,
    required this.chatID,
    required this.handlesID,
    required this.index,
    required this.readBy,
    required this.sender,
    required this.userID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch,child) {

        final _chatProvider = watch(chatProvider);

        return VisibilityDetector(
          key: Key("$index"),
          onVisibilityChanged: (VisibilityInfo info) {
            if(this.readBy.indexOf(this.sender) >= 0){
              print("already read");
            } else {
              List<String> newReadBy = this.readBy;
              newReadBy.add(this.userID);

              _chatProvider.readChat(
                this.handlesID,
                this.chatID,
                newReadBy
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(
              bottom: MQuery.height(isDateBlock ? 0 : 0.02, context),
              top: MQuery.height(0.02, context),
              left: MQuery.width(0.08, context),
              right: MQuery.width(0.08, context)
            ),
            padding: EdgeInsets.all(
              MQuery.height(0.01, context),
            ),
            decoration: BoxDecoration(
              color: Palette.handlesChat,
              borderRadius: BorderRadius.all(Radius.circular(6.5))
            ),
            child: Text(
              '${this.content}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 13
              ),
              textAlign: TextAlign.center,
            )
          ),
        );
      },
    );
  }
}