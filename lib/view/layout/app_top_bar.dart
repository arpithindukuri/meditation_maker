import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:redux/redux.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  List<Widget> _getChildren(BuildContext context, Store<AppState> store) {
    switch (store.state.currentScreen) {
      case AppScreen.projectList:
        return [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          const SizedBox(width: 12),
          const Text("Meditation Maker"),
        ];
      case AppScreen.projectEditor:
        return [
          IconButton(
            onPressed: () {
              store.dispatch(NavToProjectListAction());
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 12),
          Text('Editing: ${store.state.editingProject?.name}'),
        ];
      default:
        return [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.error),
          ),
          const SizedBox(width: 12),
          const Text("Error: Please restart app"),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          return AppBar(
            title: Row(
              children: _getChildren(context, store),
            ),
          );
        });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
