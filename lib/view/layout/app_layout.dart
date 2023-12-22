import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';
import 'package:meditation_maker/view/layout/app_body.dart';

import 'app_player_bar.dart';
import 'app_top_bar.dart';

// https://coolors.co/754668-587d71-4daa57-b5dda4-f9eccc
const rawColors = ["#493548", "#4b4e6d", "#6a8d92", "#80b192", "#a1e887"];
const rawColorInts = [
  0xFF493548,
  0xFF4b4e6d,
  0xFF6a8d92,
  0xFF80b192,
  0xFFa1e887
];

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
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class AppLayout extends StatelessWidget {
  final AppScreen activeScreen;

  const AppLayout({super.key, this.activeScreen = AppScreen.projectList});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.teal[50],
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: AppColors.primaryDark,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryDark,
          ),
        ),
        home: Scaffold(
          body: const AppBody(),
          appBar: const AppTopBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              store.dispatch(CreateProjectAction());
            },
            tooltip: 'Add Project',
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const AppPlayerBar(),
        ),
      ),
    );
  }
}
