import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';
import 'package:meditation_maker/view/project_list.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const ProjectList(),
      ),
    );
  }
}
