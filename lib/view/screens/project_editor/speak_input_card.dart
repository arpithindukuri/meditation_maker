import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
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
          input: widget.input.copyWith(
            text: controller.text,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      onInit: (store) {
        _initState(store);
      },
      builder: (context, store) {
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
                      // color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        "3 Sec",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded),
                      onPressed: () {
                        store.dispatch(
                            RemoveInputAction(index: widget.inputIndex));
                      },
                      // color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '. . .',
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 10,
                  controller: controller,
                  onChanged: (text) => {},
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
