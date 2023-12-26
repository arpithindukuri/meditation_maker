import 'package:flutter/material.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:redux/redux.dart';

class SpeakInputCard extends StatefulWidget {
  final SpeakInput input;
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
    controller = TextEditingController(text: widget.input.text);

    // add listener and dispatch action
    controller.addListener(() {
      store.dispatch(
        UpdateInputAction(
          index: widget.inputIndex,
          input: SpeakInput(text: controller.text),
        ),
      );
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
            TextField(
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
                  text: widget.input.text),
              onChanged: (text) => {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
