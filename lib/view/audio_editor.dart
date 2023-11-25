import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:meditation_maker/util/custom_audio_source.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/provider/project_provider.dart';
import 'package:just_audio/just_audio.dart';

class AudioEditor extends ConsumerStatefulWidget {
  const AudioEditor({super.key});

  @override
  ConsumerState<AudioEditor> createState() => _AudioEditorState();
}

class _AudioEditorState extends ConsumerState<AudioEditor> {
  List<TextEditingController> controllers = [];

  late SynthesizeSpeechResponse ttsResponse;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    Project project = ref.read(projectProvider);

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

    for (TextEditingController controller in controllers) {
      controller.addListener(() {
        ref
            .read(projectProvider.notifier)
            .editInput(controllers.indexOf(controller), controller.text);

        // setState(() {
        //   project.inputs[controllers.indexOf(controller)] = controller.text;
        // });
      });
    }
  }

  Future<void> getTTSAudio() async {
    Project project = ref.watch(projectProvider);

    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('synthesize');

    final ssml = project.toSSMLString();

    print(ssml);

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

  Future<void> playAudio() async {
    await getTTSAudio();

    //await writeFile();

    await player.setAudioSource(
        CustomAudioSource(ttsResponse.audioContent?.codeUnits ?? []));

    player.play();
  }

  void stopAudio() async {
    await player.stop();
  }

  void addInput() {
    ref.read(projectProvider.notifier).addInput();

    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void removeInput(int index) {
    ref.read(projectProvider.notifier).deleteInput(index);

    setState(() {
      // inputs.removeAt(index);
      controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Project project = ref.watch(projectProvider);

    return Scaffold(
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: playAudio,
            child: const Icon(Icons.play_arrow),
          ),
          FloatingActionButton(
            onPressed: stopAudio,
            child: const Icon(Icons.stop),
          ),
          FloatingActionButton(
            onPressed: addInput,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: List.generate(
              project.inputs.length,
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
      ),
    );
  }
}
