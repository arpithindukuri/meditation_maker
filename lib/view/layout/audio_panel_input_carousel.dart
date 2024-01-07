import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/redux/redux_store.dart';

class AudioPanelInputCarousel extends StatefulWidget {
  const AudioPanelInputCarousel({
    super.key,
  });

  @override
  State<AudioPanelInputCarousel> createState() =>
      _AudioPanelInputCarouselState();
}

class _AudioPanelInputCarouselState extends State<AudioPanelInputCarousel> {
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();

    store.state.playerState.audioHandler?.player.currentIndexStream.listen(
      (index) {
        if (index != null) {
          _controller.animateToPage(
            index,
            // curve: Curves.easeInOut,
            // duration: const Duration(milliseconds: 800),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AudioPlayerState>(
      converter: (store) => store.state.playerState,
      builder: (context, playerState) {
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
            carouselController: _controller,
            items: playerState.playingProject?.inputs.map(
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
