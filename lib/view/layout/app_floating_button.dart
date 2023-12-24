import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';

class AppFloatingButton extends StatelessWidget {
  final AppScreen currentScreen;

  const AppFloatingButton(this.currentScreen, {super.key});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (context, store) => FloatingActionButton.extended(
        onPressed: () {
          store.dispatch(CreateProjectAction());
        },
        tooltip: 'Add Project',
        label: const Text('Add Project'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
