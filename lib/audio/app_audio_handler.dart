import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AppAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations

  final player = AudioPlayer();

  @override
  Future<void> play() async {
    // player.playerStateStream.listen(
    //   (playerState) {
    //     if (playerState.processingState == ProcessingState.completed) {
    //       store.dispatch(PlayNextInputAction());
    //     }
    //   },
    // );
    if (player.audioSource != null) {
      await player.play();
    }
  }

  Future<void> setPlayerAudioSource(AudioSource audioSource) async {
    await player.setAudioSource(audioSource);

    // log(audioContent);
    // _player.play();
  }

  Future<void> pause() async {}

  @override
  Future<void> stop() async {
    await player.stop();
  }

  Future<void> seek(Duration position) async {}

  Future<void> skipToQueueItem(int i) async {}
}
