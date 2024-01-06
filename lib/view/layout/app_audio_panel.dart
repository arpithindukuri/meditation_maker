import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:meditation_maker/view/layout/app_audio_bar.dart';

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

class AudioPanelInputCarousel extends StatelessWidget {
  const AudioPanelInputCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Project>(
      converter: (store) => store.state.playerState.playingProject!,
      builder: (context, playingProject) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
              width: 2,
            ),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              scrollDirection: Axis.vertical,
              disableCenter: true,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              scrollPhysics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
            ),
            items: playingProject.inputs.map(
              (input) {
                return Builder(
                  builder: (BuildContext context) {
                    return CarouselCard(input: input);
                  },
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}

class CarouselCard extends StatelessWidget {
  final Input input;

  const CarouselCard({super.key, required this.input});

  String _getInputText(Input input) {
    if (input is SpeakInput) {
      return input.text;
    } else if (input is PauseInput) {
      return 'Pause';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(32),
      //   border: Border.all(
      //     color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
      //     width: 2,
      //   ),
      //   color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
      // ),
      child: Text(
        _getInputText(input),
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class AudioPanelControls extends StatelessWidget {
  const AudioPanelControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Project>(
      converter: (store) => store.state.playerState.playingProject!,
      builder: (context, playingProject) {
        return Container(
          // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Slider(
                value: 0.5,
                onChanged: (value) {},
                divisions: playingProject.inputs.length,
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
                        icon: const Icon(Icons.skip_previous_rounded),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox.square(
                      dimension: audioBarHeight,
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow_rounded),
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
          ),
        );
      },
    );
  }
}
