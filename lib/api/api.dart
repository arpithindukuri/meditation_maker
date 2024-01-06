import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

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
