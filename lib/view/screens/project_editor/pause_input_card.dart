import "package:flutter/services.dart";
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
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
      store.dispatch(
        UpdateInputAction(
          index: widget.inputIndex,
          input: PauseInput(
            delayMS: controller.text.isEmpty ? 0 : int.parse(controller.text),
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
        return Row(
          children: [
            Expanded(child: Container()),
            Expanded(
              flex: 3,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.pause_rounded,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Expanded(
                            child: Text(
                              "Pause for:",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: const InputDecoration(
                            filled: true,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          controller: controller,
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
      },
    );
  }
}
