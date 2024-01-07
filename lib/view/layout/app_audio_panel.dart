import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/view/layout/app_audio_bar.dart';

import 'audio_panel_controls.dart';
import 'audio_panel_input_carousel.dart';

class AppAudioPanel extends StatelessWidget {
  const AppAudioPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Project?>(
      converter: (store) => store.state.playerState.playingProject,
      builder: (context, playingProject) {
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
                child: playingProject == null
                    ? Center(
                        child: Text(
                          'No Project Playing',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 32,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: audioBarHeight,
                            ),
                            Text(
                              playingProject.name,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            const Expanded(
                              flex: 5,
                              child: AudioPanelInputCarousel(),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            const Expanded(
                              flex: 3,
                              child: AudioPanelControls(),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
