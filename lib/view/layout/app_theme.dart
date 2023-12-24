import 'package:flutter/material.dart';

// https://coolors.co/493548-4b4e6d-6a8d92-80b192-a1e887
// https://coolors.co/3d293d-4b4e6d-6a8d92-b3d0be-a1e887
const rawColors = ["#3D293D", "#4B4E6D", "#6A8D92", "#B3D0BE", "#A1E887"];
final rawColorInts =
    rawColors.map((c) => int.parse('FF${c.substring(1)}', radix: 16)).toList();

class AppColors {
  static final primaryDark = createMaterialColor(Color(rawColorInts[0]));
  static final secondaryDark = createMaterialColor(Color(rawColorInts[1]));
  static final primaryLight = createMaterialColor(Color(rawColorInts[3]));
  static final secondaryLight = createMaterialColor(Color(rawColorInts[2]));
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

final appThemeDataLight = ThemeData(
  primarySwatch: AppColors.primaryDark,
  scaffoldBackgroundColor: AppColors.primaryLight,
);

final appThemeDataDark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: AppColors.primaryDark,
  scaffoldBackgroundColor: AppColors.primaryDark,
  bottomAppBarTheme: BottomAppBarTheme(
    color: AppColors.primaryDark[900],
    surfaceTintColor: Colors.transparent,
    padding: const EdgeInsets.all(24),
  ),
  appBarTheme: AppBarTheme(
    color: AppColors.primaryDark[900],
    surfaceTintColor: Colors.transparent,
  ),
);
