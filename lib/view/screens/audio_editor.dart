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
import 'package:redux/redux.dart';

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
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: List.generate(
                  editingProject.inputs.length,
                  (index) => Row(children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: controllers[index],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeInput(index),
                        ),
                      ])),
            ),
          );
        });
  }
}