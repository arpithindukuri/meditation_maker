import 'package:meditation_maker/model/app_state.dart';
// import 'package:meditation_maker/redux/audio_cache_redux.dart';
import 'package:meditation_maker/redux/player_state_redux.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:redux/redux.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    currentScreen: currentScreenReducer(state.currentScreen, action),
    projectList: projectListReducer(state.projectList, action),
    editingProject: editingProjectReducer(state.editingProject, action),
    playerState: playerStateReducer(state.playerState, action),
    isBodyLoading: appLoadingReducer(state.isBodyLoading, action),
    // audioCache: audioCacheReducer(state.audioCache, action),
  );
}

List<dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    appMiddleware = [
  ...currentScreenMiddleware,
  ...projectListMiddleware,
  ...editingProjectMiddleware,
  ...playerStateMiddleware,
  // ...audioCacheMiddleware,
];
