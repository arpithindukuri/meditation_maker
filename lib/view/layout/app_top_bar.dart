import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:redux/redux.dart';

const double toolbarHeight = 145;

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
        return const Text(
          "ERROR: Please restart app.",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            height: toolbarHeight,
            child: AppBar(
              primary: false,
              automaticallyImplyLeading: false,
              toolbarHeight: toolbarHeight,
              leadingWidth: toolbarHeight / 1.3,
              foregroundColor: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize!,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.7),
              ),
              // scrolledUnderElevation: 35,
              // elevation: 2,
              flexibleSpace: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8),
                          width: 2,
                        ),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.35),
                        borderRadius: BorderRadius.circular(28),
                        // boxShadow: [
                        //   BoxShadow(
                        //     blurRadius: 2,
                        //     color: Colors.white.withOpacity(0.45),
                        //     offset: const Offset(0, 4),
                        //   ),
                        // ],
                      ),
                    ),
                  ),
                ),
              ),
              leading: Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: _getLeading(context, store)),
              titleSpacing: 0,
              title: _getTitle(context, store),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
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
            ),
          );
        });
  }

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);
}
