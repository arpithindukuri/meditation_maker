import 'package:flutter/material.dart';

class AppColors {
  // https://coolors.co/493548-4b4e6d-6a8d92-80b192-a1e887
  // https://coolors.co/3d293d-4b4e6d-6a8d92-b3d0be-a1e887
  static const rawColors = [
    "#5881B8",
    "#EDF2F7",
    "#5881B8",
    "#394556",
    "#A1E887",
  ];

  static final rawColorInts = rawColors
      .map((c) => int.parse('FF${c.substring(1)}', radix: 16))
      .toList();

  static final primaryLight = generateMaterialColor(Color(rawColorInts[0]));
  static final secondaryLight = generateMaterialColor(Color(rawColorInts[1]));
  static final primaryDark = generateMaterialColor(Color(rawColorInts[2]));
  static final secondaryDark = generateMaterialColor(Color(rawColorInts[3]));

  static MaterialColor generateMaterialColor(Color color) {
    // return MaterialColor(color.value, {
    //   50: tintColor(color, 0.95),
    //   100: tintColor(color, 0.8),
    //   200: tintColor(color, 0.6),
    //   300: tintColor(color, 0.4),
    //   400: tintColor(color, 0.2),
    //   500: color,
    //   600: shadeColor(color, 0.1),
    //   700: shadeColor(color, 0.25),
    //   800: shadeColor(color, 0.45),
    //   900: shadeColor(color, 0.5),
    // });
    return MaterialColor(color.value, {
      50: getShade(color, 0.99),
      100: getShade(color, 0.96),
      200: getShade(color, 0.85),
      300: getShade(color, 0.72),
      400: getShade(color, 0.65),
      500: getShade(color, 0.50),
      600: getShade(color, 0.40),
      700: getShade(color, 0.30),
      800: getShade(color, 0.20),
      900: getShade(color, 0.10),
    });
  }

  // static int tintValue(int value, double factor) =>
  //     max(0, min((value + ((255 - value) * factor)).round(), 255));

  // static Color tintColor(Color color, double factor) => Color.fromRGBO(
  //     tintValue(color.red, factor),
  //     tintValue(color.green, factor),
  //     tintValue(color.blue, factor),
  //     1);

  // static int shadeValue(int value, double factor) =>
  //     max(0, min(value - (value * factor).round(), 255));

  // static Color shadeColor(Color color, double factor) => Color.fromRGBO(
  //     shadeValue(color.red, factor),
  //     shadeValue(color.green, factor),
  //     shadeValue(color.blue, factor),
  //     1);

  static Color getShade(Color color, double lightness) =>
      HSLColor.fromColor(color).withLightness(lightness).toColor();

  // static Color saturateColor(Color color, double saturation) {
  //   final hsl = HSLColor.fromColor(color);
  //   print(hsl);
  //   final hslWithSat = hsl.withSaturation(hsl.saturation * saturation);
  //   print(hslWithSat);
  //   final result = hslWithSat.toColor();
  //   print(result);
  //   return result;
  // }
}

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.secondaryLight.shade50,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.primaryLight.shade600,
      background: AppColors.secondaryLight.shade50,
      surface: AppColors.secondaryLight.shade50,
      onSurface: AppColors.primaryLight.shade600,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 12,
      foregroundColor: AppColors.primaryLight.shade500,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryLight.shade700,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryLight.shade700,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          AppColors.primaryLight.shade600,
        ),
        overlayColor: MaterialStateProperty.all(
          AppColors.secondaryLight.shade200,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: AppColors.primaryLight.shade600,
            width: 1,
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          AppColors.primaryLight.shade600,
        ),
        overlayColor: MaterialStateProperty.all(
          AppColors.secondaryLight.shade200,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: AppColors.primaryLight.shade600,
            width: 1,
          ),
        ),
      ),
    ),
    // scaffoldBackgroundColor: AppColors.primaryLight,
  );

  static final dark = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primaryDark,
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.primaryDark.shade900,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.secondaryDark.shade300,
      background: AppColors.secondaryDark.shade900,
      surface: AppColors.secondaryDark.shade900,
      onSurface: AppColors.secondaryDark.shade50,
    ),
    // textTheme: TextTheme(
    //   headlineSmall: TextStyle(
    //     color: AppColors.secondaryDark.shade200,
    //   ),
    // ),
    // scaffoldBackgroundColor: AppColors.primaryDark,
    bottomAppBarTheme: BottomAppBarTheme(
      color: AppColors.secondaryDark.shade800,
      surfaceTintColor: AppColors.secondaryDark.shade800,
    ),
    appBarTheme: AppBarTheme(
      foregroundColor: AppColors.secondaryDark.shade100,
      backgroundColor: Colors.transparent,
      surfaceTintColor: AppColors.secondaryDark.shade50,
    ),
  );
}
