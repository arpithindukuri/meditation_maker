import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:redux/redux.dart';

const double toolbarHeight = 90;

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
          Text(
            "Meditation Maker",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ];
      case AppScreen.projectEditor:
        return [
          IconButton(
            onPressed: () {
              store.dispatch(NavToProjectListAction(context: context));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 12),
          Text(
            'Editing: ${store.state.editingProject?.name}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
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
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            toolbarHeight: toolbarHeight,
            flexibleSpace: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _getChildren(context, store),
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          );
        });
  }

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);
}
