import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';
import 'package:meditation_maker/view/layout/app_body.dart';

import 'app_player_bar.dart';
import 'app_top_bar.dart';

class AppLayout extends StatelessWidget {
  final AppScreen activeScreen;

  const AppLayout({super.key, this.activeScreen = AppScreen.projectList});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
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
