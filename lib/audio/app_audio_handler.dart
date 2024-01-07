import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_maker/redux/player_state_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';

class AppAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations

  final _player = AudioPlayer();

  @override
  Future<void> play() async {
    _player.playerStateStream.listen(
      (playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          store.dispatch(PlayNextInputAction());
        }
      },
    );
    await _player.play();
  }

  Future<void> setPlayerAudioSource(StreamAudioSource audioSource) async {
    await _player.setAudioSource(audioSource);

    // log(audioContent);
    // _player.play();
  }

  Future<void> pause() async {}

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> seek(Duration position) async {}

  Future<void> skipToQueueItem(int i) async {}
}
