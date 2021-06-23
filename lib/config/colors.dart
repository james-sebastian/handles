part of "config.dart";

class Palette{

  static int primaryIntForm = 0xFF007BFF;

  static Map<int, Color> materialColorMap = {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  static Color primary = HexColor("007BFF");
  static Color secondary = HexColor("47E5BC");
  static Color tertiary = HexColor("FFD60A");
  static Color primaryText = HexColor("000000");
  static Color secondaryText = HexColor("355366");
  static Color warning = HexColor("CF1B2B");
  static Color formColor = HexColor("F0F0F0");
}