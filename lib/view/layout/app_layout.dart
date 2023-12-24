import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/redux_store.dart';
import 'package:meditation_maker/view/layout/app_body.dart';

import 'app_audio_bar.dart';
import 'app_floating_button.dart';
import 'app_theme.dart';
import 'app_top_bar.dart';

class AppLayout extends StatelessWidget {
  // final AppScreen currentScreen = AppScreen.projectList;

  const AppLayout({super.key});

  Scaffold _getRoute(AppScreen routeScreen) {
    return Scaffold(
      // extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: const AppTopBar(),
      bottomNavigationBar: const AppAudioBar(),
      floatingActionButton: AppFloatingButton(routeScreen),
      body: AppBody(routeScreen),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        theme: appThemeDataLight,
        darkTheme: appThemeDataDark,
        initialRoute: '/${AppScreen.projectList.name}',
        routes: {
          '/${AppScreen.projectList.name}': (context) =>
              _getRoute(AppScreen.projectList),
          '/${AppScreen.projectEditor.name}': (context) =>
              _getRoute(AppScreen.projectEditor),
        },
      ),
    );
  }
}
