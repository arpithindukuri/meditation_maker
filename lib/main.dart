import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meditation_maker/redux/audio_handler_redux.dart';
import 'package:meditation_maker/view/layout/app_layout.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'firebase_options.dart';
import './redux/redux_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // options: const FirebaseOptions(
  //     apiKey: '', appId: '', messagingSenderId: '', projectId: ''));

  // if in development environment, use local emulator
  // if (kDebugMode) {
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // }

  store.dispatch(InitAudioHandlerAction());

  runApp(const AppLayout());
}
