import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/view/screens/audio_editor/audio_editor.dart';
import 'package:meditation_maker/view/screens/project_list/project_list.dart';

class AppBody extends StatelessWidget {
  final AppScreen routeScreen;

  Widget _getChild() {
    switch (routeScreen) {
      case AppScreen.projectList:
        return const ProjectList();
      case AppScreen.projectEditor:
        return const ProjectEditor();
      default:
        return const ProjectList();
    }
  }

  const AppBody(this.routeScreen, {super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppScreen>(
      converter: (store) => store.state.currentScreen,
      builder: (context, currentScreen) => _getChild(),
    );
  }
}
