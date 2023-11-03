import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meditation_maker/custom_audio_source.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/project_provider.dart';
import 'firebase_options.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:just_audio/just_audio.dart';

import 'ssml.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if in development environment, use local emulator
  if (kDebugMode) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VerticalList(),
    );
  }
}

class VerticalList extends ConsumerStatefulWidget {
  const VerticalList({super.key});

  @override
  ConsumerState<VerticalList> createState() => _VerticalListState();
}

class _VerticalListState extends ConsumerState<VerticalList> {
  List<TextEditingController> controllers = [];

  late SynthesizeSpeechResponse ttsResponse;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    Project project = ref.read(projectProvider);

    // init controllers
    controllers = List.generate(
      project.inputs.length,
      (index) => TextEditingController(text: project.inputs[index]),
    );

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

    final response =
        await callable(<String, dynamic>{'ssml': listToSSML(project.inputs)});

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
