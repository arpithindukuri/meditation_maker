import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/app_state_redux.dart';
import 'package:redux/redux.dart';

final store = Store<AppState>(
  appReducer,
  initialState: AppState(
    currentScreen: AppScreen.homeScreen,
    isBodyLoading: false,
    playerState: AudioPlayerState(),
    projectList: [],
    editingProject: null,
  ),
  middleware: appMiddleware,
);
