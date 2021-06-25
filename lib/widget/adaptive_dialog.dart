part of "widgets.dart";

class AdaptiveDialog extends StatelessWidget {
  
  final String title;
  final String content;
  final String positiveTitle;
  final String negativeTitle;
  final Function actionMethodPositive;
  final Function actionMethodNegative;

  const AdaptiveDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actionMethodPositive,
    required this.actionMethodNegative,
    required this.positiveTitle,
    required this.negativeTitle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
    ? AlertDialog(
        title: Text(this.title),
        content: Text(this.content),
        actions: [
          TextButton(
            child: Text(negativeTitle),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Palette.warning,
                fontWeight: FontWeight.w500
              )
            ),
            onPressed: actionMethodNegative(),
          ),
          TextButton(
            child: Text(positiveTitle),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Palette.primary,
                fontWeight: FontWeight.w500
              )
            ),
            onPressed: actionMethodPositive(),
          )
        ],
      )
    : CupertinoAlertDialog(
        title: Text(this.title),
        content: Text(this.content),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: actionMethodPositive(),
            child: Text(positiveTitle),
          ),
          CupertinoDialogAction(
            onPressed: actionMethodNegative(),
            child: Text(negativeTitle),
          )
        ],
    );
  }
}