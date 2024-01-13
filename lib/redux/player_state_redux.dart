import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_maker/api/api.dart';
import 'package:meditation_maker/audio/app_audio_handler.dart';
import 'package:meditation_maker/audio/custom_audio_source.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/model/wrapped.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
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
  final Input? playInput;

  PlayProjectAction({required this.project, this.playInput});
}

// class PlayInputAction extends PlayAudioAction {
//   final Input input;

//   PlayInputAction({required this.input});
// }

class PlayNextInputAction extends PlayAudioAction {}

class PlayPrevInputAction extends PlayAudioAction {}

class PauseAudioAction extends PlayerStateAction {}

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
  TypedMiddleware<AppState, PlayNextInputAction>(
    _playNextInputMiddleware,
  ).call,
  TypedMiddleware<AppState, PlayPrevInputAction>(
    _playPrevInputMiddleware,
  ).call,
  TypedMiddleware<AppState, PauseAudioAction>(
    _pauseAudioMiddleware,
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
  store.dispatch(
    SetPlayerStateAction(
      playerState: store.state.playerState.copyWith(
        isAudioLoading: true,
      ),
    ),
  );

  if (store.state.playerState.audioHandler?.player.playing ?? false) {
    await store.state.playerState.audioHandler?.stop();
  }

  Project project = action.project;
  Input? playInput = action.playInput;

  if (project.inputs.isEmpty) return;

  final isProjectAudioSaved = action.project.inputs.every((input) =>
      (input is PauseInput) ||
      (input is SpeakInput && input.audioBytes != null));

  // if project does not have audio saved,
  // or if project to play is the one currently being edited,
  // get and save audio for project inputs
  if (!isProjectAudioSaved ||
      store.state.currentScreen == AppScreen.projectEditor) {
    final newProj = await getProjectWithAudio(action.project);

    project = newProj;

    // if audio was reloaded from API, update project in project list
    store.dispatch(UpdateProjectAction(project: newProj));
  }

  final playInputIndex = action.playInput == null
      ? 0
      : action.project.inputs.indexOf(action.playInput!);

  playInput = playInput == null
      ? project.inputs.first
      : playInputIndex < 0
          ? project.inputs.first
          : project.inputs[playInputIndex];

  store.dispatch(
    SetPlayerStateAction(
      playerState: store.state.playerState.copyWith(
        playingProject: Wrapped.value(project),
        playingInput: Wrapped.value(playInput),
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

    if (playInputIndex >= 0) {
      await store.state.playerState.audioHandler
          ?.setPlayerAudioSource(audioSources);

      await store.state.playerState.audioHandler
          ?.skipToQueueItem(playInputIndex);

      await store.state.playerState.audioHandler?.seek(Duration.zero);

      // store.dispatch(
      //   SetPlayerStateAction(
      //     playerState: store.state.playerState.copyWith(
      //       isAudioLoading: false,
      //     ),
      //   ),
      // );

      // await store.state.playerState.audioHandler?.play();
      store.state.playerState.audioHandler?.play();
    }
  } catch (e) {
    log(e.toString());
  }

  store.dispatch(
    SetPlayerStateAction(
      playerState: store.state.playerState.copyWith(
        isAudioLoading: false,
      ),
    ),
  );

  next(action);
}

// Future<void> _playInputMiddleware(
//     Store<AppState> store, PlayInputAction action, next) async {
//   final input = action.input;

//   store.dispatch(
//     SetPlayerStateAction(
//       playerState: store.state.playerState.copyWith(
//         playingInput: Wrapped.value(input),
//       ),
//     ),
//   );

//   StreamAudioSource? audioSource;

//   if (input is SpeakInput && input.audioBytes != null) {
//     final List<int> audioBytes = input.audioBytes!;
//     audioSource = SpeakAudioSource(audioBytes);
//   } else if (input is PauseInput) {
//     final duration = (input.delayMS / 1000).round();
//     audioSource = PauseAudioSource(durationParam: Duration(seconds: duration));
//   }

//   if (audioSource != null) {
//     await store.state.playerState.audioHandler
//         ?.setPlayerAudioSource(audioSource);

//     await store.state.playerState.audioHandler?.play();
//   }

//   next(action);
// }

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

  store.dispatch(
      PlayProjectAction(project: currentProject, playInput: nextInput));

  next(action);
}

Future<void> _playPrevInputMiddleware(
  Store<AppState> store,
  PlayPrevInputAction action,
  NextDispatcher next,
) async {
  next(action);
}

Future<void> _pauseAudioMiddleware(
  Store<AppState> store,
  PauseAudioAction action,
  NextDispatcher next,
) async {
  await store.state.playerState.audioHandler?.pause();

  next(action);
}

final playerStateReducer = combineReducers<AudioPlayerState>([
  TypedReducer<AudioPlayerState, SetPlayerStateAction>(_setPlayerState).call,
]);

AudioPlayerState _setPlayerState(
    AudioPlayerState state, SetPlayerStateAction action) {
  return action.playerState;
}
