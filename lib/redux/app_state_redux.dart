import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/audio_cache_redux.dart';
import 'package:meditation_maker/redux/audio_handler_redux.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    currentScreen: currentScreenReducer(state.currentScreen, action),
    projectList: projectListReducer(state.projectList, action),
    editingProject: editingProjectReducer(state.editingProject, action),
    audioHandler: audioHandlerReducer(state.audioHandler, action),
    isBodyLoading: appLoadingReducer(state.isBodyLoading, action),
    audioCache: audioCacheReducer(state.audioCache, action),
  );
}

List<dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    appMiddleware = [
  ...currentScreenMiddleware,
  ...projectListMiddleware,
  ...audioHandlerMiddleware,
  ...audioCacheMiddleware,
];
