import 'package:flutter/material.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:meditation_maker/view/layout/app_audio_panel.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/player_state_redux.dart';
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
      child: StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        onInit: (store) async {
          store.dispatch(InitAudioHandlerAction());
        },
        builder: (context, store) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          // themeMode: ThemeMode.dark,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialRoute: '/${AppScreen.homeScreen.name}',
          routes: {
            '/${AppScreen.homeScreen.name}': (context) =>
                ScaffoldRoute(routeScreen: AppScreen.homeScreen),
            '/${AppScreen.projectList.name}': (context) =>
                ScaffoldRoute(routeScreen: AppScreen.projectList),
            '/${AppScreen.projectEditor.name}': (context) =>
                ScaffoldRoute(routeScreen: AppScreen.projectEditor),
          },
        ),
      ),
    );
  }
}

class ScaffoldRoute extends StatefulWidget {
  final AppScreen routeScreen;

  ScaffoldRoute({super.key, required this.routeScreen});

  @override
  State<ScaffoldRoute> createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  WeSlideController controller = WeSlideController();

  bool isPanelOpen = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() => isPanelOpen = controller.isOpened);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      onInit: (store) async {
        // store.dispatch(InitAudioHandlerAction());
      },
      builder: (context, store) {
        return PopScope(
          canPop:
              !isPanelOpen && store.state.currentScreen == AppScreen.homeScreen,
          onPopInvoked: (didPop) {
            if (!didPop) {
              if (isPanelOpen) {
                controller.hide();
              } else if (store.state.currentScreen == AppScreen.projectList) {
                store.dispatch(NavExitProjectListAction(context: context));
              } else if (store.state.currentScreen == AppScreen.projectEditor) {
                store.dispatch(NavExitProjectEditorAction(context: context));
              }
            }
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            appBar: AppTopBar(isVisible: !isPanelOpen),
            body: AppWeSlideBody(
              routeScreen: widget.routeScreen,
              controller: controller,
            ),
            // empty transparent bottomAppBar to make floatingActionButtonLocation work
            bottomNavigationBar: const BottomAppBar(
              height: audioBarHeight,
              color: Colors.transparent,
              elevation: 0,
              child: SizedBox(height: 0),
            ),
            floatingActionButton: widget.routeScreen == AppScreen.homeScreen ||
                    widget.routeScreen == AppScreen.projectEditor
                ? null
                : AppFloatingButton(
                    routeScreen: widget.routeScreen,
                    isVisible: !isPanelOpen,
                  ),
          ),
        );
      },
    );
  }
}

class AppWeSlideBody extends StatelessWidget {
  final AppScreen routeScreen;
  final WeSlideController controller;

  const AppWeSlideBody({
    super.key,
    required this.routeScreen,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return WeSlide(
      controller: controller,
      backgroundColor: Colors.transparent,
      panelMinSize: audioBarHeight,
      panelMaxSize: MediaQuery.of(context).size.height - 28,
      body: AppBody(routeScreen),
      panel: const AppAudioPanel(),
      panelHeader: const AppAudioBar(),
      overlay: true,
      overlayColor: Theme.of(context).colorScheme.secondary,
      overlayOpacity: 0.5,
      parallax: true,
      parallaxOffset: 0.035,
      footerHeight: 0,
      hideFooter: true,
      // hideAppBar: true,
      blurColor: Colors.transparent,
    );
  }
}
