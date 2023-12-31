import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:meditation_maker/view/layout/app_top_bar.dart';
import 'package:redux/redux.dart';

import 'speak_input_card.dart';
import 'pause_input_card.dart';

class ProjectEditor extends StatefulWidget {
  const ProjectEditor({super.key});

  @override
  State<ProjectEditor> createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> {
  List<TextEditingController> controllers = [];

  late SynthesizeSpeechResponse ttsResponse;

  Future<void> getTTSAudio(String ssml) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('synthesize');

    final response = await callable(<String, dynamic>{'ssml': ssml});

    setState(
      () {
        ttsResponse = SynthesizeSpeechResponse.fromJson(
          {
            "audioContent": String.fromCharCodes(
              Uint8List.fromList(
                (jsonDecode(response.data['jsonString'])['audioContent']['data']
                        as List<dynamic>)
                    .cast<int>(),
              ),
            ),
          },
        );
      },
    );
  }

  Future<void> playAudio() async {}

  void stopAudio() async {}

  void addInput() {
    // TODO: ref.read(projectProvider.notifier).addInput();

    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void removeInput(int index) {
    // TODO: ref.read(projectProvider.notifier).deleteInput(index);

    setState(() {
      // inputs.removeAt(index);
      controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Project project = ref.watch(projectProvider);

    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        if (store.state.editingProject == null) {
          return const Center(child: Text("No project selected"));
        } else if (store.state.editingProject!.inputs.isEmpty) {
          return const Column(
            children: [
              SizedBox(height: appbarHeight),
              AddInputButton(index: -1),
            ],
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          itemCount: store.state.editingProject?.inputs.length ?? 0,
          separatorBuilder: (context, index) => const SizedBox(height: 0),
          itemBuilder: (context, index) {
            final input = store.state.editingProject!.inputs[index];

            return Column(children: [
              if (index == 0) const SizedBox(height: appbarHeight - 28),
              if (index == 0) const AddInputButton(index: -1),
              if (input.type == InputType.speak)
                SpeakInputCard(
                  input: input as SpeakInput,
                  inputIndex: index,
                ),
              if (input.type == InputType.pause)
                PauseInputCard(
                  input: input as PauseInput,
                  inputIndex: index,
                ),
              AddInputButton(index: index),
            ]);
          },
        );
      },
    );
  }
}

class AddInputButton extends StatelessWidget {
  final int index;

  const AddInputButton({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        if (store.state.editingProject == null) {
          return const Center(child: Text("No project selected"));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton.filledTonal(
                tooltip: 'Add input',
                icon: const Icon(Icons.add_rounded),
                // color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              );
            },
            menuChildren: [
              MenuItemButton(
                child: const Text('Speak'),
                onPressed: () => store.dispatch(
                    AddInputAction(index: index, type: InputType.speak)),
              ),
              MenuItemButton(
                child: const Text('Pause'),
                onPressed: () => store.dispatch(
                    AddInputAction(index: index, type: InputType.pause)),
              ),
            ],
          ),
        );
      },
    );
  }
}
