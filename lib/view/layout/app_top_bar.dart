import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:redux/redux.dart';

const double toolbarHeight = 90;

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  Widget _getLeading(BuildContext context, Store<AppState> store) {
    switch (store.state.currentScreen) {
      case AppScreen.homeScreen:
        return Image.asset('assets/images/2_icon_nobg.png');
      case AppScreen.projectList:
        return IconButton(
          onPressed: () {
            store.dispatch(NavExitProjectListAction(context: context));
          },
          icon: const Icon(Icons.arrow_back_rounded),
        );
      case AppScreen.projectEditor:
        // return null;
        return IconButton(
          onPressed: () {
            store.dispatch(NavExitProjectEditorAction(context: context));
          },
          icon: const Icon(Icons.arrow_back_rounded),
        );
      default:
        // return null;
        return IconButton(
          onPressed: () {},
          icon: const Icon(Icons.error_rounded),
        );
    }
  }

  Widget _getTitle(BuildContext context, Store<AppState> store) {
    final style = Theme.of(context).textTheme.headlineSmall;

    switch (store.state.currentScreen) {
      case AppScreen.homeScreen:
        return const Text(
          "Meditation Maker",
        );
      case AppScreen.projectList:
        return const Text(
          "My Projects",
        );
      case AppScreen.projectEditor:
        return Text(
          '${store.state.editingProject?.name}',
        );
      default:
        return Text(
          "ERROR: Please restart app.",
          style: style,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          return AppBar(
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            centerTitle: true,
            automaticallyImplyLeading: false,
            // scrolledUnderElevation: 35,
            // elevation: 2,
            toolbarHeight: toolbarHeight,
            leadingWidth: toolbarHeight / 1.3,
            // flexibleSpace: Container(
            //   padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            //   alignment: Alignment.bottomLeft,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: _getChildren(context, store),
            //   ),
            // ),
            leading: Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: _getLeading(context, store)),
            titleSpacing: 0,
            title: _getTitle(context, store),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),

            actions: [
              SizedBox(
                width: toolbarHeight / 1.3,
                height: double.infinity,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_rounded),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);
}
