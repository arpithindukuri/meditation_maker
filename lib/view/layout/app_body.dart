import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/view/screens/audio_editor.dart';
import 'package:meditation_maker/view/screens/project_list.dart';

class AppBody extends StatelessWidget {
  // function that gets the body depending on activeScreen
  Widget _getChild(AppScreen currentScreen) {
    switch (currentScreen) {
      case AppScreen.projectList:
        return const ProjectList();
      case AppScreen.projectEditor:
        return const ProjectEditor();
      default:
        return const ProjectList();
    }
  }

  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppScreen>(
        converter: (store) => store.state.currentScreen,
        builder: (context, currentScreen) {
          return _getChild(currentScreen);
        });
  }
}
