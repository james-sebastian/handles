part of 'widgets.dart';

class Button extends StatelessWidget {
  final void Function() method;
  final String title;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final double? height;
  final double? width;

  const Button(
      {Key? key,
      this.height,
      this.width,
      this.borderColor,
      required this.title,
      required this.method,
      required this.color,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Container(
            height: height ?? MQuery.width(0.0575, context),
            width: width ?? MQuery.width(0.25, context),
            decoration: BoxDecoration(
                border: Border.all(color: borderColor ?? Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: borderColor != null ? 0 : 1, primary: color),
                onPressed: method,
                child: Font.out(title,
                    height: 1,
                    fontSize:
                        (height ?? 0) == MQuery.width(0.045, context) ? 14 : 18,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          )
        : Container(
            height: height ?? MQuery.width(0.0575, context),
            width: width ?? MQuery.width(0.3, context),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                color: color,
                onPressed: method,
                child: Font.out(title,
                    height: 1,
                    fontSize: (height ?? 0.0) == MQuery.width(0.045, context)
                        ? 14
                        : 18,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          );
  }
}
