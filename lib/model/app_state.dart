import 'package:meditation_maker/audio/app_audio_handler.dart';
import 'package:meditation_maker/model/project.dart';

enum AppScreen {
  homeScreen,
  projectList,
  projectEditor,
}

class AppState {
  AppScreen currentScreen;
  List<Project> projectList;
  Project? editingProject;
  AppAudioHandler? audioHandler;
  bool isBodyLoading;
  String? audioCache;

  // Initial state, loaded by redux in redux_store.dart, initialState: AppState()
  AppState({
    this.currentScreen = AppScreen.homeScreen,
    this.projectList = const [],
    this.editingProject,
    this.audioHandler,
    this.isBodyLoading = false,
    this.audioCache,
  });

  AppState copyWith({
    AppScreen? currentScreen,
    List<Project>? projectList,
    Project? editingProject,
    AppAudioHandler? audioHandler,
    bool? isBodyLoading,
    String? audioCache,
  }) {
    return AppState(
      currentScreen: currentScreen ?? this.currentScreen,
      projectList: projectList ?? this.projectList,
      editingProject: editingProject ?? this.editingProject,
      audioHandler: audioHandler ?? this.audioHandler,
      isBodyLoading: isBodyLoading ?? this.isBodyLoading,
      audioCache: audioCache ?? this.audioCache,
    );
  }
}
