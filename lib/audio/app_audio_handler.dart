import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_maker/audio/custom_audio_source.dart';
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
    await _player.play();
    _player.playerStateStream.listen(
      (playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          store.dispatch(PlayNextInputAction());
        }
      },
    );
  }

  Future<void> setPlayerAudioSource(List<int> audioBytes) async {
    await _player.setAudioSource(CustomAudioSource(audioBytes));

    // log(audioContent);
    // _player.play();
  }

  Future<void> pause() async {}

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> seek(Duration position) async {}

  Future<void> skipToQueueItem(int i) async {}
}
