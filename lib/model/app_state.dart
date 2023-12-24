import 'package:meditation_maker/model/audio_player_state.dart';
import 'package:meditation_maker/model/project.dart';

enum AppScreen {
  projectList,
  projectEditor,
}

class AppState {
  AppScreen currentScreen;
  List<Project> projectList;
  Project? editingProject;
  AudioPlayerState? playingAudio;
  bool isBodyLoading;

  AppState({
    this.currentScreen = AppScreen.projectList,
    this.projectList = const [],
    this.editingProject,
    this.playingAudio,
    this.isBodyLoading = false,
  });

  AppState copyWith({
    AppScreen? currentScreen,
    List<Project>? projectList,
    Project? editingProject,
    AudioPlayerState? playingAudio,
  }) {
    return AppState(
      currentScreen: currentScreen ?? this.currentScreen,
      projectList: projectList ?? this.projectList,
      editingProject: editingProject ?? this.editingProject,
      playingAudio: playingAudio ?? this.playingAudio,
    );
  }
}
