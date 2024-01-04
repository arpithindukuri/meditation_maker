import 'package:meditation_maker/model/app_state.dart';
import 'package:redux/redux.dart';

sealed class AudioCacheAction {}

class SetAudioCacheAction extends AudioCacheAction {
  final String? audioCache;

  SetAudioCacheAction({this.audioCache});
}

final List<
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    audioCacheMiddleware = [
  TypedMiddleware<AppState, SetAudioCacheAction>(
    _setAudioCacheMiddleware,
  ).call,
];

Future<void> _setAudioCacheMiddleware(
    Store<AppState> store, SetAudioCacheAction action, next) async {
  final audioCache = action.audioCache;

  if (audioCache != null) {
    await store.state.audioHandler?.setPlayerAudioSource(audioCache);
  }

  next(action);
}

final audioCacheReducer = combineReducers<String?>([
  TypedReducer<String?, SetAudioCacheAction>(_setAudioCache).call,
]);

String? _setAudioCache(String? state, SetAudioCacheAction action) {
  return action.audioCache;
}
