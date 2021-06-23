part of "config.dart";

class Font{
  static Text out(String title, {double? height, double? fontSize, FontWeight? fontWeight, Color? color, TextAlign? textAlign}){
    return Text(
      title,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
        height: height ?? 1.5,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Palette.primaryText
      )
    );
  }
}