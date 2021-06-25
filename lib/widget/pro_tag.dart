part of "widgets.dart";

class ProTag extends StatelessWidget {
  const ProTag({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 2.5
      ),
      child: Font.out(
        "PRO",
        color: Palette.tertiary,
        fontSize: 12,
        fontWeight: FontWeight.w600
      ),
    );
  }
}