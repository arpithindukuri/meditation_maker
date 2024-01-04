import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
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

abstract class PlayAudioAction extends AudioAction {}

class PlayEditingProjectAction extends PlayAudioAction {}

class PlayProjectAction extends PlayAudioAction {
  final Project project;

  PlayProjectAction({required this.project});
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
    _setAudioCacheFromPlayingProjectMiddleware,
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

  store.dispatch(SetAudioHandlerAction(audioHandler: audioHandler));

  next(action);
}

Future<void> _setAudioCacheFromPlayingProjectMiddleware(
    Store<AppState> store, PlayAudioAction action, next) async {
  WidgetsFlutterBinding.ensureInitialized();

  // default ssml with error text
  String ssml = '<speak>There was an error synthesizing the audio.</speak>';

  // if play editing project, set ssml to editing project's ssml
  if (action is PlayEditingProjectAction &&
      store.state.editingProject != null) {
    ssml = store.state.editingProject!.toSSMLString();
  } else if (action is PlayProjectAction) {
    ssml = action.project.toSSMLString();
  }

  if (Firebase.apps.isNotEmpty) {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'us-central1')
            .httpsCallable('synthesize');

    final response = await callable(<String, dynamic>{'ssml': ssml});
    final responseMap = jsonDecode(response.data['jsonString']);
    final responseAudioContent =
        (responseMap['audioContent']['data'] as List<dynamic>).cast<int>();
    final audioCache = String.fromCharCodes(
      Uint8List.fromList(
        responseAudioContent,
      ),
    );

    // log('response: ${response.data['jsonString']}');
    // log('responseMap: $responseMap');
    // log('responseAudioContent: $responseAudioContent');
    // log('responseAudioContent length: ${responseAudioContent.length}');
    // log('audioCache: $audioCache');
    // log('audioCache length: ${audioCache.length}');

    store.dispatch(
      SetAudioCacheAction(
        audioCache: audioCache,
      ),
    );

    await store.state.audioHandler?.play();
  }

  next(action);
}

final audioHandlerReducer = combineReducers<AppAudioHandler?>([
  TypedReducer<AppAudioHandler?, SetAudioHandlerAction>(_setAudioHandler).call,
  // TypedReducer<AppAudioHandler?, PlayAudioAction>(_playAudio).call,
]);

AppAudioHandler? _setAudioHandler(
    AppAudioHandler? state, SetAudioHandlerAction action) {
  return action.audioHandler;
}

// AppAudioHandler? _playAudio(AppAudioHandler? state, PlayAudioAction action) {
//   state?.play();
//   // return state;
// }
