import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_maker/api/api.dart';
import 'package:meditation_maker/audio/app_audio_handler.dart';
import 'package:meditation_maker/audio/custom_audio_source.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/model/wrapped.dart';
import 'package:meditation_maker/util/ssml.dart';
import 'package:redux/redux.dart';
import 'package:audio_service/audio_service.dart';

sealed class PlayerStateAction {}

class InitAudioHandlerAction extends PlayerStateAction {}

class SetPlayerStateAction extends PlayerStateAction {
  final AudioPlayerState playerState;

  SetPlayerStateAction({required this.playerState});
}

class PlayAudioAction extends PlayerStateAction {}

class PlayProjectAction extends PlayAudioAction {
  final Project project;

  PlayProjectAction({required this.project});
}

class PlayInputAction extends PlayAudioAction {
  final Input input;

  PlayInputAction({required this.input});
}

class PlayNextInputAction extends PlayAudioAction {}

class PauseAudioAction extends PlayerStateAction {}

class StopAudioAction extends PlayerStateAction {}

class SeekAudioAction extends PlayerStateAction {
  final Duration position;

  SeekAudioAction({required this.position});
}

final List<
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    playerStateMiddleware = [
  TypedMiddleware<AppState, InitAudioHandlerAction>(
    _initAudioHandlerMiddleware,
  ).call,
  TypedMiddleware<AppState, PlayProjectAction>(
    _playProjectMiddleware,
  ).call,
  TypedMiddleware<AppState, PlayInputAction>(
    _playInputMiddleware,
  ).call,
  TypedMiddleware<AppState, PlayNextInputAction>(
    _playNextInputMiddleware,
  ).call,
];

Future<void> _initAudioHandlerMiddleware(
    Store<AppState> store, InitAudioHandlerAction action, next) async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioHandler = await AudioService.init(
    builder: () => AppAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId:
          'com.example.meditation_maker.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );

  store.dispatch(
    SetPlayerStateAction(
      playerState: store.state.playerState.copyWith(
        audioHandler: audioHandler,
      ),
    ),
  );

  next(action);
}

Future<Project> getProjectWithAudio(Project project) async {
  final inputs = project.inputs;
  List<Input> inputsWithAudio = [];

  for (final input in inputs) {
    if (input is PauseInput) {
      inputsWithAudio.add(input);
    } else if (input is SpeakInput) {
      final audioBytes = await getAudioBytesFromSSML(speakInputToSSML(input));
      inputsWithAudio.add(
        input.copyWith(
          audioBytes: Wrapped.value(audioBytes),
        ),
      );
    }
  }

  final projectWithAudio = project.copyWith(inputs: inputsWithAudio);

  return projectWithAudio;
}

Future<void> _playProjectMiddleware(
    Store<AppState> store, PlayProjectAction action, next) async {
  Project project = action.project;

  final isProjectAudioSaved = action.project.inputs.every((input) =>
      (input is PauseInput) ||
      (input is SpeakInput && input.audioBytes != null));

  // if project does not have audio saved,
  // or if project to play is the one currently being edited,
  // get and save audio for project inputs
  if (!isProjectAudioSaved ||
      (store.state.currentScreen == AppScreen.projectEditor &&
          store.state.editingProject == action.project)) {
    final projectWithAudio = await getProjectWithAudio(action.project);

    project = projectWithAudio;
  }

  store.dispatch(
    SetPlayerStateAction(
      playerState: store.state.playerState.copyWith(
        playingProject: Wrapped.value(project),
      ),
    ),
  );

  try {
    ConcatenatingAudioSource? audioSources = ConcatenatingAudioSource(
      useLazyPreparation: false,
      children: project.inputs.map((input) {
        if (input is SpeakInput && input.audioBytes != null) {
          final List<int> audioBytes = input.audioBytes!;
          return SpeakAudioSource(audioBytes);
        } else if (input is PauseInput) {
          final duration = (input.delayMS / 1000).round();
          return PauseAudioSource(durationParam: Duration(seconds: duration));
        } else {
          throw Exception('Input type not supported.');
        }
      }).toList(),
    );

    await store.state.playerState.audioHandler
        ?.setPlayerAudioSource(audioSources);

    await store.state.playerState.audioHandler?.play();

    // if (project.inputs.isNotEmpty) {
    //   store.dispatch(
    //     PlayInputAction(input: project.inputs.first),
    //   );
    // }
  } catch (e) {
    // log(e.toString());
  }

  next(action);
}

Future<void> _playInputMiddleware(
    Store<AppState> store, PlayInputAction action, next) async {
  final input = action.input;

  store.dispatch(
    SetPlayerStateAction(
      playerState: store.state.playerState.copyWith(
        playingInput: Wrapped.value(input),
      ),
    ),
  );

  StreamAudioSource? audioSource;

  if (input is SpeakInput && input.audioBytes != null) {
    final List<int> audioBytes = input.audioBytes!;
    audioSource = SpeakAudioSource(audioBytes);
  } else if (input is PauseInput) {
    final duration = (input.delayMS / 1000).round();
    audioSource = PauseAudioSource(durationParam: Duration(seconds: duration));
  }

  if (audioSource != null) {
    await store.state.playerState.audioHandler
        ?.setPlayerAudioSource(audioSource);

    await store.state.playerState.audioHandler?.play();
  }

  next(action);
}

Future<void> _playNextInputMiddleware(
    Store<AppState> store, PlayNextInputAction action, next) async {
  final currentProject = store.state.playerState.playingProject;
  final currentInput = store.state.playerState.playingInput;

  // log("currentProject: $currentProject");
  // log("currentInput: $currentInput");

  // await store.state.playerState.audioHandler?.stop();

  if (currentProject == null || currentInput == null) return;

  final currentInputIndex = currentProject.inputs.indexOf(currentInput);

  if (currentInputIndex < 0 ||
      currentInputIndex == currentProject.inputs.length - 1) return;

  final nextInput = currentProject.inputs[currentInputIndex + 1];

  store.dispatch(PlayInputAction(input: nextInput));

  next(action);
}

final playerStateReducer = combineReducers<AudioPlayerState>([
  TypedReducer<AudioPlayerState, SetPlayerStateAction>(_setPlayerState).call,
]);

AudioPlayerState _setPlayerState(
    AudioPlayerState state, SetPlayerStateAction action) {
  return action.playerState;
}
