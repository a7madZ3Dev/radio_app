import 'dart:ui';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "FF");
    if (hexColor.length == 8) {
      return int.parse(hexColor, radix: 16);
    }
    return int.parse('FFffffff', radix: 16);
  }

}
