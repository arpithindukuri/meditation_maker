import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
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
        home: Scaffold(
            body: const ProjectList(),
            appBar: AppBar(
              title: const Center(child: Text("Meditation Maker")),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                store.dispatch(CreateProjectAction());
              },
              tooltip: 'Add Project',
              child: const Icon(Icons.add),
            )),
      ),
    );
  }
}
