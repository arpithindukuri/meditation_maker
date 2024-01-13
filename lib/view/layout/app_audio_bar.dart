import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/player_state_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';

const audioBarHeight = 100.0;

class AppAudioBar extends StatelessWidget {
  const AppAudioBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AudioPlayerState>(
      converter: (store) => store.state.playerState,
      builder: (context, playerState) {
        return Container(
          // clipBehavior: Clip.,
          height: audioBarHeight,
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 12),
          // alignment: Alignment.bottomCenter,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: playerState.isAudioLoading
                        ? [
                            const Center(
                              child: CircularProgressIndicator(
                                semanticsLabel: 'Audio Bar Loading',
                              ),
                            )
                          ]
                        : playerState.playingProject == null
                            ? [
                                Text(
                                  "No project playing",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                          color:
                                              Theme.of(context).disabledColor),
                                ),
                                // const SizedBox(height: 4),
                              ]
                            : [
                                Text(
                                  playerState.playingProject!.name,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  "00:00 / 00:00",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color:
                                              Theme.of(context).disabledColor),
                                ),
                                const SizedBox(height: 4),
                              ],
                  )),
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    onPressed:
                        playerState.playingProject == null ? null : () {},
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.play_arrow_rounded),
                    onPressed: playerState.playingProject == null
                        ? null
                        : () async {
                            store.dispatch(PlayProjectAction(
                                project: playerState.playingProject!));
                          },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded),
                    onPressed:
                        playerState.playingProject == null ? null : () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
