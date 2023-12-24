import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    currentScreen: currentScreenReducer(state.currentScreen, action),
    projectList: projectListReducer(state.projectList, action),
    editingProject: editingProjectReducer(state.editingProject, action),
    playingAudio: null,
    isBodyLoading: appLoadingReducer(state.isBodyLoading, action),
  );
}

List<dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    appMiddleware = [...currentScreenMiddleware, ...projectListMiddleware];
