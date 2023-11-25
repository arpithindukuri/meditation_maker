import 'package:flutter/material.dart';
import 'package:meditation_maker/view/audio_editor.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AudioEditor(),
    );
  }
}
