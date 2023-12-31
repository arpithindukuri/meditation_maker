import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/audio_handler_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';
import 'package:meditation_maker/view/layout/app_body.dart';
import 'package:we_slide/we_slide.dart';

import 'app_audio_bar.dart';
import 'app_floating_button.dart';
import 'app_theme.dart';
import 'app_top_bar.dart';

class AppLayout extends StatelessWidget {
  // final AppScreen currentScreen = AppScreen.projectList;

  const AppLayout({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // themeMode: ThemeMode.dark,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        initialRoute: '/${AppScreen.homeScreen.name}',
        routes: {
          '/${AppScreen.homeScreen.name}': (context) =>
              const ScaffoldRoute(routeScreen: AppScreen.homeScreen),
          '/${AppScreen.projectList.name}': (context) =>
              const ScaffoldRoute(routeScreen: AppScreen.projectList),
          '/${AppScreen.projectEditor.name}': (context) =>
              const ScaffoldRoute(routeScreen: AppScreen.projectEditor),
        },
      ),
    );
  }
}

class ScaffoldRoute extends StatelessWidget {
  final AppScreen routeScreen;

  const ScaffoldRoute({super.key, required this.routeScreen});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppScreen>(
      converter: (store) => store.state.currentScreen,
      onInit: (store) {
        // store.dispatch(InitAudioHandlerAction());
      },
      builder: (context, store) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: const AppTopBar(),
          body: AppWeSlideBody(routeScreen: routeScreen),
          // empty transparent bottomAppBar to make floatingActionButtonLocation work
          bottomNavigationBar: BottomAppBar(
            height: audioBarHeight.toDouble(),
            color: Colors.transparent,
            elevation: 0,
            child: const SizedBox(height: 0),
          ),
          floatingActionButton: routeScreen == AppScreen.homeScreen ||
                  routeScreen == AppScreen.projectEditor
              ? null
              : AppFloatingButton(routeScreen),
        );
      },
    );
  }
}

class AppWeSlideBody extends StatelessWidget {
  const AppWeSlideBody({
    super.key,
    required this.routeScreen,
  });

  final AppScreen routeScreen;

  @override
  Widget build(BuildContext context) {
    return WeSlide(
      backgroundColor: Colors.transparent,
      panelMinSize: audioBarHeight.toDouble(),
      panelMaxSize: MediaQuery.of(context).size.height - 28,
      body: AppBody(routeScreen),
      panel: const AppAudioBar(),
      overlay: true,
      overlayColor: Theme.of(context).colorScheme.secondary,
      overlayOpacity: 0.5,
      parallax: true,
      hidePanelHeader: true,
      hideAppBar: true,
      hideFooter: true,
      blurColor: Colors.transparent,
    );
  }
}
