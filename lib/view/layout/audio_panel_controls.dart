import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation_maker/audio/custom_audio_source.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/player_state_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';
// import 'package:meditation_maker/redux/redux_store.dart';
import 'package:meditation_maker/view/layout/app_audio_bar.dart';

class AudioPanelControls extends StatefulWidget {
  const AudioPanelControls({
    super.key,
  });

  @override
  State<AudioPanelControls> createState() => _AudioPanelControlsState();
}

class _AudioPanelControlsState extends State<AudioPanelControls> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AudioPlayerState>(
      converter: (store) => store.state.playerState,
      builder: (context, playerState) {
        return StreamBuilder<int?>(
            stream: playerState.audioHandler?.player.currentIndexStream,
            builder: (context, currentIndexSnapshot) {
              // log('currentIndexSnapshot: ${currentIndexSnapshot.data}');

              final audioSource = playerState.audioHandler?.player.audioSource;

              if (audioSource == null ||
                  audioSource is! ConcatenatingAudioSource) {
                return const Center(
                  child: Text('No audio source'),
                );
              }

              final audioSourceList = audioSource.children;

              int foldAudioSourceList(List<AudioSource> list) {
                return list.fold<int>(
                  0,
                  (prev, el) {
                    if (el is SpeakAudioSource) {
                      int sampleRate = 24000;
                      int channels = 1;
                      int bitsPerSample = 16;
                      // log('el.bytes.length: ${el.bytes.length * 1000000 ~/ (sampleRate * channels * (bitsPerSample ~/ 8))}');
                      return prev +
                          el.bytes.length *
                              1000000 ~/
                              (sampleRate * channels * (bitsPerSample ~/ 8));
                      // log('el.duration.inMicroseconds: ${el.duration?.inMicroseconds}');
                      // return prev + (el.duration?.inMicroseconds ?? 0);
                    } else if (el is PauseAudioSource) {
                      // log('el.durationParam.inMicroseconds: ${el.durationParam.inMicroseconds}');
                      return prev + (el.durationParam.inMicroseconds);
                    } else {
                      return prev;
                    }
                  },
                );
              }

              final prevInputsDuration = Duration(
                microseconds: foldAudioSourceList(
                  audioSourceList.sublist(
                    0,
                    (currentIndexSnapshot.data ?? 0),
                  ),
                ),
              );

              final totalInputsDuration = Duration(
                microseconds: foldAudioSourceList(audioSourceList),
              );

              final int prevInputsDurationMS =
                  prevInputsDuration.inMicroseconds;
              final int totalInputsDurationMS =
                  totalInputsDuration.inMicroseconds;

              // log('prevInputsDurationMS: $prevInputsDurationMS');
              // log('durationMS: $totalInputsDurationMS');
              // log('audioSourceList: $audioSourceList');

              // ignored because of nested stream builder
              // ignore: avoid_unnecessary_containers
              return Container(
                child: StreamBuilder<Duration>(
                    stream: playerState.audioHandler?.player.positionStream,
                    builder: (context, positionSnapshot) {
                      final int positionMS = prevInputsDurationMS +
                          (positionSnapshot.data?.inMicroseconds ?? 0);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Slider(
                            value: clampDouble(
                                positionMS / totalInputsDurationMS, 0, 1),
                            onChanged: (value) {},
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: audioBarHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox.square(
                                  dimension: audioBarHeight,
                                  child: IconButton(
                                    icon:
                                        const Icon(Icons.skip_previous_rounded),
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox.square(
                                  dimension: audioBarHeight,
                                  child: playerState
                                              .audioHandler?.player.playing ??
                                          false
                                      ? IconButton(
                                          icon: const Icon(Icons.pause_rounded),
                                          onPressed: () {
                                            store.dispatch(PauseAudioAction());
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                              Icons.play_arrow_rounded),
                                          onPressed: () {},
                                        ),
                                ),
                                SizedBox.square(
                                  dimension: audioBarHeight,
                                  child: IconButton(
                                    icon: const Icon(Icons.skip_next_rounded),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              );
            });
      },
    );
  }
}
