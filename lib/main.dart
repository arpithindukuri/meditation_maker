import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_functions/cloud_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if in development environment, use local emulator
  if (kDebugMode) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  runApp(const MyApp());
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

class VerticalList extends StatefulWidget {
  const VerticalList({super.key});

  @override
  State createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  late List<String> inputs;
  List<TextEditingController> controllers = [];

  late GoogleSignIn googleSignIn;
  late GoogleSignInAccount? googleSignInAccount;

  late TexttospeechApi textToSpeechAPI;
  late String audio;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // init inputs
    inputs = [
      'Find a quiet place where you won\'t be disturbed.',
      'Sit comfortably with your back straight and your hands resting on your lap.',
      'Close your eyes and take a deep breath in through your nose, hold it for a few seconds, then exhale slowly through your mouth.',
      'Focus on your breath as it goes in and out of your body. If your mind starts to wander, gently bring it back to your breath.',
      'Continue breathing deeply and focusing on your breath for as long as you like.',
    ];

    // init controllers
    controllers = List.generate(
      inputs.length,
      (index) => TextEditingController(text: inputs[index]),
    );
    for (TextEditingController controller in controllers) {
      controller.addListener(() {
        setState(() {
          inputs[controllers.indexOf(controller)] = controller.text;
        });
      });
    }
  }

  Future<void> callFunction() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('repeat');
    final results = await callable(<String, dynamic>{
      'message': 'A message sent from a client device',
      'count': inputs.length
    });
    var result = results.data;

    print(result);
  }

  Future<void> playAudio() async {
    await player.setSourceBytes(Uint8List.fromList(audio.codeUnits));

    await player.resume();
  }

  void stopAudio() async {
    await player.stop();
  }

  void addInput() {
    setState(() {
      inputs.add('');
      controllers.add(TextEditingController());
    });
  }

  void removeInput(int index) {
    setState(() {
      inputs.removeAt(index);
      controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: callFunction,
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
              inputs.length,
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
