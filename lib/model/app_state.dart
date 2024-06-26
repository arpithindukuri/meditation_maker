import 'package:meditation_maker/audio/app_audio_handler.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/model/wrapped.dart';

enum AppScreen {
  homeScreen,
  projectList,
  projectEditor,
}

class AudioPlayerState {
  bool isAudioLoading;
  AppAudioHandler? audioHandler;
  Project? playingProject;
  Input? playingInput;

  AudioPlayerState({
    this.isAudioLoading = false,
    this.audioHandler,
    this.playingProject,
    this.playingInput,
  });

  AudioPlayerState copyWith({
    bool? isAudioLoading,
    AppAudioHandler? audioHandler,
    Wrapped<Project?>? playingProject,
    Wrapped<Input?>? playingInput,
  }) {
    return AudioPlayerState(
      isAudioLoading: isAudioLoading ?? this.isAudioLoading,
      audioHandler: audioHandler ?? this.audioHandler,
      playingProject:
          playingProject != null ? playingProject.value : this.playingProject,
      playingInput:
          playingInput != null ? playingInput.value : this.playingInput,
    );
  }
}

class AppState {
  AppScreen currentScreen;
  List<Project> projectList;
  Project? editingProject;
  AudioPlayerState playerState;
  bool isBodyLoading;
  // String? audioCache;

  // Initial state, loaded by redux in redux_store.dart, initialState: AppState()
  AppState({
    required this.currentScreen,
    required this.projectList,
    this.editingProject,
    required this.playerState,
    required this.isBodyLoading,
    // this.audioCache,
  });

  AppState copyWith({
    AppScreen? currentScreen,
    List<Project>? projectList,
    Wrapped<Project?>? editingProject,
    AudioPlayerState? playerState,
    bool? isBodyLoading,
    // String? audioCache,
  }) {
    return AppState(
      currentScreen: currentScreen ?? this.currentScreen,
      projectList: projectList ?? this.projectList,
      editingProject:
          editingProject != null ? editingProject.value : this.editingProject,
      playerState: playerState ?? this.playerState,
      isBodyLoading: isBodyLoading ?? this.isBodyLoading,
      // audioCache: audioCache ?? this.audioCache,
    );
  }
}
