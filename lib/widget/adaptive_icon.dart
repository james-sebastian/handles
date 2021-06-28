part of "widgets.dart";

class AdaptiveIcon extends StatelessWidget {

  final IconData android;
  final IconData iOS;
  final double? size;
  final Color? color;
  const AdaptiveIcon({ Key? key, required this.android, required this.iOS, this.size, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      !Platform.isAndroid
      ? android
      : iOS,
      size: size,
      color: color
    );
  }
}