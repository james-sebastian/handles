part of "widgets.dart";

class GeneralStatusTag extends StatelessWidget {

  final String status;
  final Color color;
  final bool? mini;

  const GeneralStatusTag({ 
    Key? key,
    this.mini,
    required this.status,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return mini != null && mini == true
    ? Container(
        padding: EdgeInsets.symmetric(
          horizontal: MQuery.height(0.01, context),
          vertical: MQuery.height(0.005, context),
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
              fontSize: 10
            ),
            textAlign: TextAlign.center,
          )
        )
      )
    : Container(
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