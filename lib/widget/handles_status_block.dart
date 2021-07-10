part of "widgets.dart";

class HandlesStatusBlock extends StatelessWidget {

  final String content;
  final bool isDateBlock;

  const HandlesStatusBlock({ Key? key, required this.content, required this.isDateBlock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}