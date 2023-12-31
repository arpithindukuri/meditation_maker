import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/audio_handler_redux.dart';
import 'package:redux/redux.dart';

const audioBarHeight = 100;

class AppAudioBar extends StatelessWidget {
  const AppAudioBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return Container(
          // clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          color: Colors.transparent,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                    width: 2,
                  ),
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.stop_rounded),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded),
                      onPressed: () {
                        store.dispatch(PlayAudioAction());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
