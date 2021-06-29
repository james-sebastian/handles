part of "widgets.dart";

class GeneralStatusTag extends StatelessWidget {

  final String status;
  final Color color;

  const GeneralStatusTag({ 
    Key? key,
    required this.status,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MQuery.height(0.015, context),
        vertical: MQuery.height(0.0075, context),
      ),
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.all(Radius.circular(6.5))
      ),
      child: Center(
        child: Text(
          this.status,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13
          ),
          textAlign: TextAlign.center,
        )
      )
    );
  }
}