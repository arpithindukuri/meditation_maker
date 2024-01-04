import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../firebase_options.dart';
import 'package:meditation_maker/view/layout/app_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // options: const FirebaseOptions(
  //     apiKey: '', appId: '', messagingSenderId: '', projectId: ''));

  // if in development environment, use local emulator
  if (kDebugMode) {
    FirebaseFunctions.instanceFor(region: 'us-central1')
        // from PS > (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.AddressState -eq "Preferred"}).IPAddress
        .useFunctionsEmulator('192.168.1.80', 5001);
  }

  runApp(const AppLayout());
}
