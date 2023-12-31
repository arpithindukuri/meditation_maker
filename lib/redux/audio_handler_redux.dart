import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meditation_maker/audio/app_audio_handler.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/audio_cache_redux.dart';
import 'package:redux/redux.dart';
import 'package:audio_service/audio_service.dart';

sealed class AudioAction {}

class InitAudioHandlerAction extends AudioAction {}

class SetAudioHandlerAction extends AudioAction {
  final AppAudioHandler audioHandler;

  SetAudioHandlerAction({required this.audioHandler});
}

class PlayAudioAction extends AudioAction {
  final Project? project;

  PlayAudioAction({this.project});
}

class PauseAudioAction extends AudioAction {}

class StopAudioAction extends AudioAction {}

class SeekAudioAction extends AudioAction {
  final Duration position;

  SeekAudioAction({required this.position});
}

final List<
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    audioHandlerMiddleware = [
  TypedMiddleware<AppState, InitAudioHandlerAction>(
    _initAudioHandlerMiddleware,
  ).call,
  TypedMiddleware<AppState, PlayAudioAction>(
    _playAudioMiddleware,
  ).call,
];

Future<void> _initAudioHandlerMiddleware(
    Store<AppState> store, InitAudioHandlerAction action, next) async {
  final audioHandler = await AudioService.init(
    builder: () => AppAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId:
          'com.example.meditation_maker.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );

  store.dispatch(SetAudioHandlerAction(audioHandler: audioHandler));

  next(action);
}

Future<void> _playAudioMiddleware(
    Store<AppState> store, PlayAudioAction action, next) async {
  // default ssml with error text
  String ssml = '<speak>There was an error synthesizing the audio.</speak>';

  // if play editing project, set ssml to editing project's ssml
  final project = action.project;
  if (project != null) {
    ssml = project.toSSMLString();
  } else if (store.state.editingProject != null) {
    ssml = store.state.editingProject!.toSSMLString();
  }

  if (Firebase.apps.isNotEmpty) {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('synthesize');

    final response = await callable(<String, dynamic>{'ssml': ssml});
    final responseMap = jsonDecode(response.data['jsonString']);
    final responseAudioContent = responseMap['audioContent']['data'];
    final audioCache = String.fromCharCodes(
      Uint8List.fromList(
        (responseAudioContent as List<dynamic>).cast<int>(),
      ),
    );

    store.dispatch(
      SetAudioCacheAction(
        audioCache: audioCache,
      ),
    );
  }

  next(action);
}

final audioHandlerReducer = combineReducers<AppAudioHandler?>([
  TypedReducer<AppAudioHandler?, SetAudioHandlerAction>(_setAudioHandler).call,
  TypedReducer<AppAudioHandler?, PlayAudioAction>(_playAudio).call,
]);

AppAudioHandler? _setAudioHandler(
    AppAudioHandler? state, SetAudioHandlerAction action) {
  return action.audioHandler;
}

AppAudioHandler? _playAudio(AppAudioHandler? state, PlayAudioAction action) {
  state?.play();
  return state;
}
