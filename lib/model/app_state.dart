import 'package:meditation_maker/model/audio_player_state.dart';
import 'package:meditation_maker/model/project.dart';

enum AppScreen {
  projectList,
  editingProject,
}

class AppState {
  AppScreen currentScreen;
  List<Project> projectList;
  Project? editingProject;
  AudioPlayerState? playingAudio;

  AppState({
    this.currentScreen = AppScreen.projectList,
    this.projectList = const [],
    this.editingProject,
    this.playingAudio,
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
