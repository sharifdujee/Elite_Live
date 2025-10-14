import 'package:flutter/material.dart';

class AppColors {
  static const Color lightPrimary = Color.fromARGB(255, 0, 205, 208);
  static const Color darkPrimary = Colors.black;
  static const Color darkSecondary = Color.fromARGB(255, 31, 30, 30);
  static const Color lightAccent = Color.fromARGB(255, 137, 211, 240);
  static const Color lightBG = Color(0xfffcfcff);
  static const Color darkBG = Colors.black;
  static final Color primaryColor = Color.lerp(Color(0xFF591AD4), Color(0xFFC121A0), 1)!;
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF591AD4),
      Color(0xFFC121A0),
    ],
  );

  static const Color primaryLightColor = Color(0xff62524d);
  static const Color backgroundColor = Color(0xffd7ead6);
  static const Color textGrey = Color(0xFF808080);
  static const Color textWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color primaryWhiteSmoke = Color(0xFFF5F5F5);
  static const Color mediumYellow = Color(0xffFDB846);
  static const Color darkYellow = Color(0xffE99E22);
  static const Color bPrimaryColor = Color(0xFFFFC61F);
  static const Color bgPrimaryColor = Color(0xffffd31d);
  static const Color lightGrey = Color(0xFFD0D0D0);
  static const Color nestBlue = Color(0xFF0757AC);
  static const Color white = Color(0xffffffff);
  static const Color bgColor = Color(0xffededed);
  static const Color navbarcolor = Color(0xff1450A3);

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1, 'shade values must be between 0 and 1');
    final HSLColor hsl = HSLColor.fromColor(color);
    final HSLColor hslDark = hsl.withLightness(
      (darker ? (hsl.lightness - value) : (hsl.lightness + value))
          .clamp(0.0, 1.0),
    );

    return hslDark.toColor();
  }
  static MaterialColor getMaterialColorFromColor(Color color) {
    final Map<int, Color> colorShades = <int, Color>{
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color),
      500: color,
      600: getShade(color, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.toARGB32(), colorShades);
  }

  static const Color mainColor = Color(0xff141414);
  static const Color textGray = Color(0xffB3B3B3);
  static const Color texWithUnderline = Color(0xff4C4C4C);
  static const Color dividerColor = Color(0xff1F1F1F);
  static const Color musicTabBorderDark = Color(0xff666666);
  static const Color checkGreen = Color(0xff00E45B);
  static const Color textGreen = Color(0xff6AD26E);
  static const Color tealAcent = Color(0xff00CCD0);
  static const Color textFieldBorderColor = Color(0xff343434);
  static const Color textColor = Color(0xFF636F85);
  static const Color textColorBlack = Color(0xFF191919);
  static const Color tabBorderColor = Color(0xff1A1A1A);
  static const Color paymentIconBorderColor = Color(0xff666666);
  static const Color languageBorderColor = Color(0xff3F3F3F);
  static const Color lightModeontainerBg = Color(0xffF7F7F7);

  /// added by sharif
 static const Color professionColor = Color(0xFFF8FAFC);
 static const Color liveColor = Color(0xFFFF4D67);
 static const Color textHeader = Color(0xFF2D2D2D);
 static const Color textBody = Color(0xFF636F85);

}