part of "widgets.dart";

class HandlesStatusBlock extends StatelessWidget {

  final String content;

  const HandlesStatusBlock({ Key? key, required this.content }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MQuery.height(0.02, context),
        horizontal: MQuery.width(0.04, context)
      ),
      padding: EdgeInsets.all(
        MQuery.height(0.01, context),
      ),
      decoration: BoxDecoration(
        color: Palette.handlesChat,
        borderRadius: BorderRadius.all(Radius.circular(6.5))
      ),
      child: Center(
        child: Text(
          '${this.content}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 13
          ),
          textAlign: TextAlign.center,
        )
      )
    );
  }
}