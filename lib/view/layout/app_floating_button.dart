import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:redux/redux.dart';

class AppFloatingButton extends StatelessWidget {
  final AppScreen routeScreen;
  final bool isVisible;

  const AppFloatingButton({
    super.key,
    required this.routeScreen,
    required this.isVisible,
  });

  Widget _getFloatingActionButton(Store<AppState> store) {
    switch (routeScreen) {
      case AppScreen.projectList:
        return FloatingActionButton.extended(
          onPressed: () {
            store.dispatch(CreateProjectAction());
          },
          tooltip: 'New Project',
          label: const Text('New Project'),
          icon: const Icon(Icons.add_rounded),
        );
      case AppScreen.projectEditor:
        return FloatingActionButton.extended(
          onPressed: () {
            // store.dispatch(AddInputAction());
          },
          tooltip: 'Add Input',
          label: const Text('Add Input'),
          icon: const Icon(Icons.add_rounded),
        );
      default:
        return FloatingActionButton.extended(
          onPressed: () {},
          tooltip: 'ERROR',
          label: const Text('ERROR'),
          icon: const Icon(Icons.error_rounded),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) => AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 85),
        child: IgnorePointer(
          ignoring: !isVisible,
          child: _getFloatingActionButton(store),
        ),
      ),
    );
  }
}
