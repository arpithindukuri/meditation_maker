import 'package:flutter/material.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:redux/redux.dart';

class PauseInputCard extends StatefulWidget {
  final PauseInput input;
  final int inputIndex;

  const PauseInputCard(
      {super.key, required this.input, required this.inputIndex});

  @override
  State<PauseInputCard> createState() => _PauseInputCardState();
}

class _PauseInputCardState extends State<PauseInputCard> {
  late TextEditingController controller;

  void _initState(Store<AppState> store) {
    // init controller
    controller = TextEditingController(text: widget.input.delayMS.toString());

    // add listener and dispatch action
    controller.addListener(() {
      if (widget.input is SpeakInput) {
        store.dispatch(
          UpdateInputAction(
            index: widget.inputIndex,
            input: SpeakInput(text: controller.text),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        Expanded(
          flex: 2,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => {},
                        icon: const Icon(Icons.spatial_audio_off_rounded),
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text("Pause for:"),
                      ),
                      IconButton(
                        onPressed: () => {},
                        icon: const Icon(Icons.delete_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: TextEditingController(
                          text: widget.input.delayMS.toString()),
                      onChanged: (text) => {},
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
