import 'package:flutter/material.dart';
import 'package:meditation_maker/api/api.dart';
import 'package:meditation_maker/audio/app_audio_handler.dart';
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
  final PlayerState playerState;

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

Future<void> _playProjectMiddleware(
    Store<AppState> store, PlayProjectAction action, next) async {
  Project project = action.project;

  final isProjectAudioSaved = action.project.inputs.every((input) =>
      (input is SpeakInput && input.audioBytes != null) ||
      (input is PauseInput));

  // if project does not have audio saved, get it
  if (!isProjectAudioSaved) {
    final inputs = action.project.inputs;
    List<Input> inputsWithAudio = [];

    for (final input in inputs) {
      if (input is PauseInput) {
        inputsWithAudio.add(input);
        continue;
      } else if (input is SpeakInput) {
        final audioBytes = await getAudioBytesFromSSML(speakInputToSSML(input));
        inputsWithAudio.add(
          input.copyWith(
            audioBytes: Wrapped.value(audioBytes),
          ),
        );
      }
    }

    final projectWithAudio = action.project.copyWith(inputs: inputsWithAudio);

    project = projectWithAudio;
  }

  store.dispatch(
    SetPlayerStateAction(
      playerState: store.state.playerState.copyWith(
        playingProject: Wrapped.value(project),
      ),
    ),
  );

  if (project.inputs.isNotEmpty) {
    store.dispatch(
      PlayInputAction(input: project.inputs.first),
    );
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

  if (input is SpeakInput && input.audioBytes != null) {
    await store.state.playerState.audioHandler
        ?.setPlayerAudioSource(input.audioBytes!);

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

  if (currentProject == null || currentInput == null) return;

  final currentInputIndex = currentProject.inputs.indexOf(currentInput);

  if (currentInputIndex < 0 ||
      currentInputIndex == currentProject.inputs.length - 1) return;

  final nextInput = currentProject.inputs[currentInputIndex + 1];

  store.dispatch(PlayInputAction(input: nextInput));

  next(action);
}

final playerStateReducer = combineReducers<PlayerState>([
  TypedReducer<PlayerState, SetPlayerStateAction>(_setPlayerState).call,
]);

PlayerState _setPlayerState(PlayerState state, SetPlayerStateAction action) {
  return action.playerState;
}
