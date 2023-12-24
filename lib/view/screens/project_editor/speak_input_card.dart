import 'package:flutter/material.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:redux/redux.dart';

class SpeakInputCard extends StatefulWidget {
  final Input input;
  final int inputIndex;

  const SpeakInputCard(
      {super.key, required this.input, required this.inputIndex});

  @override
  State<SpeakInputCard> createState() => _SpeakInputCardState();
}

class _SpeakInputCardState extends State<SpeakInputCard> {
  late TextEditingController controller;

  void _initState(Store<AppState> store) {
    // init controller
    if (widget.input.type == InputType.speak) {
      SpeakInput input = widget.input as SpeakInput;
      controller = TextEditingController(text: input.text);
    } else if (widget.input.type == InputType.pause) {
      PauseInput input = widget.input as PauseInput;
      controller = TextEditingController(text: input.delayMS.toString());
    } else {
      controller = TextEditingController(text: "ERROR: Unknown input type");
    }

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
    return Card(
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
                  child: Text("3 Sec"),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.delete_rounded),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (widget.input.type == InputType.speak)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextField(
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: '. . .',
                    filled: true,
                    isDense: true,
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 10,
                  controller: TextEditingController(
                      text: (widget.input as SpeakInput).text),
                  onChanged: (text) => {},
                ),
              ),
            if (widget.input.type == InputType.pause)
              TextField(
                controller: TextEditingController(
                    text: (widget.input as PauseInput).delayMS.toString()),
                onChanged: (text) => {},
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
