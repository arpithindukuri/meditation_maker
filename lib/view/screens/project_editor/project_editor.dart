import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:meditation_maker/util/custom_audio_source.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:just_audio/just_audio.dart';
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

  final player = AudioPlayer();

  void _initState(Store<AppState> store) {
    Project? project = store.state.editingProject;

    if (project == null) return;

    // init controllers
    controllers = List.generate(project.inputs.length, (index) {
      if (project.inputs[index].type == InputType.speak) {
        SpeakInput input = project.inputs[index] as SpeakInput;
        return TextEditingController(text: input.text);
      } else if (project.inputs[index].type == InputType.pause) {
        PauseInput input = project.inputs[index] as PauseInput;
        return TextEditingController(text: input.delayMS.toString());
      } else {
        return TextEditingController();
      }
    });

    // add listeners and set controller state
    for (TextEditingController controller in controllers) {
      controller.addListener(() {
        final input = project.inputs[controllers.indexOf(controller)];
        if (input is SpeakInput) {
          store.dispatch(UpdateInputAction(
              index: controllers.indexOf(controller),
              input: SpeakInput(text: controller.text)));
          // setState(() {
          //   project.inputs[controllers.indexOf(controller)] =
          //       SpeakInput(text: controller.text);
          // });
        }
      });
    }
  }

  Future<void> getTTSAudio(String ssml) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('synthesize');

    final response = await callable(<String, dynamic>{'ssml': ssml});

    setState(() {
      ttsResponse = SynthesizeSpeechResponse.fromJson({
        "audioContent": String.fromCharCodes(Uint8List.fromList(
            (jsonDecode(response.data['jsonString'])['audioContent']['data']
                    as List<dynamic>)
                .cast<int>()))
      });
    });
  }

  Future<void> playAudio(Project project) async {
    await getTTSAudio(project.toSSMLString());

    //await writeFile();

    await player.setAudioSource(
        CustomAudioSource(ttsResponse.audioContent?.codeUnits ?? []));

    player.play();
  }

  void stopAudio() async {
    await player.stop();
  }

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

    return StoreConnector<AppState, Project?>(
      onInit: (store) => _initState(store),
      converter: (store) => store.state.editingProject,
      builder: (context, editingProject) {
        if (editingProject == null) {
          return const Center(child: Text("No project selected"));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: editingProject.inputs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final input = editingProject.inputs[index];

            return Column(children: [
              if (index == 0) const SizedBox(height: toolbarHeight),
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
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
              ),
            ]);
          },
        );
      },
    );
  }
}
