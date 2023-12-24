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
              (index) => SpeakInputCard(
                input: editingProject.inputs[index],
                inputIndex: index,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SpeakInputCard extends StatefulWidget {
  final Input input;
  final int inputIndex;

  const SpeakInputCard({super.key, required this.input, required this.inputIndex});

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
          store.dispatch(UpdateInputAction(
              index: widget.inputIndex,
              input: SpeakInput(text: controller.text),),);
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.input.type.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            if (widget.input.type == InputType.speak)
              TextField(
                controller: TextEditingController(
                    text: (widget.input as SpeakInput).text),
                onChanged: (text) => {},
              ),
            if (widget.input.type == InputType.pause)
              TextField(
                controller: TextEditingController(
                    text: (widget.input as PauseInput).delayMS.toString()),
                onChanged: (text) => {},
              ),
          ],
        ),
      ),
    );
  }
}
