import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/model/wrapped.dart';
import 'package:meditation_maker/util/ssml.dart';

Future<List<int>?> getAudioBytesFromSSML(String ssml) async {
  if (Firebase.apps.isNotEmpty) {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'us-central1')
            .httpsCallable('synthesize');

    final response = await callable(<String, dynamic>{'ssml': ssml});
    final responseMap = jsonDecode(response.data['jsonString']);
    final responseAudioContent =
        (responseMap['audioContent']['data'] as List<dynamic>).cast<int>();
    final audioContentString = String.fromCharCodes(
      Uint8List.fromList(
        responseAudioContent,
      ),
    );

    return audioContentString.codeUnits;
  }

  return null;
}

Future<Project> getProjectWithAudio(Project project) async {
  final inputs = project.inputs;
  List<Input> inputsWithAudio = [];

  for (final input in inputs) {
    if (input is PauseInput) {
      inputsWithAudio.add(input);
    } else if (input is SpeakInput) {
      final audioBytes = await getAudioBytesFromSSML(speakInputToSSML(input));
      inputsWithAudio.add(
        input.copyWith(
          audioBytes: Wrapped.value(audioBytes),
        ),
      );
    }
  }

  final projectWithAudio = project.copyWith(inputs: inputsWithAudio);

  return projectWithAudio;
}

Future<Input> getInputWithAudio(Input input) async {
  if (input is SpeakInput) {
    final audioBytes = await getAudioBytesFromSSML(speakInputToSSML(input));
    return input.copyWith(
      audioBytes: Wrapped.value(audioBytes),
    );
  }

  return input;
}
