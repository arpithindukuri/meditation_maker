import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:meditation_maker/view/layout/app_top_bar.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Widget> _getHero(bool isDarkMode) {
    return isDarkMode
        ? [
            Image.asset('assets/images/1_hero-1_dark.png'),
            Image.asset('assets/images/1_hero-3_dark.png'),
            Image.asset('assets/images/1_hero-2_dark.png'),
          ]
        : [
            Image.asset('assets/images/1_hero-1.png'),
            Image.asset('assets/images/1_hero-3.png'),
            Image.asset('assets/images/1_hero-2.png'),
          ];
  }

  Widget _getButton({
    required BuildContext context,
    required String labelText,
    required dynamic Function() onPressed,
    bool isPrimary = false,
    required Widget icon,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox.expand(
            child: labelText == "New Project"
                ? FloatingActionButton.extended(
                    onPressed: onPressed,
                    label: Text(labelText),
                    icon: icon,
                    isExtended: true,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    // extendedTextStyle: Theme.of(context).textTheme.bodyLarge,
                  )
                : Material(
                    borderRadius: BorderRadius.circular(1000),
                    elevation: 7,
                    child: isPrimary
                        ? FilledButton.icon(
                            onPressed: onPressed,
                            label: Text(labelText),
                            icon: icon,
                            // backgroundColor: Theme.of(context).colorScheme.primary,
                            // extendedTextStyle: Theme.of(context).textTheme.bodyLarge,
                          )
                        : ElevatedButton.icon(
                            onPressed: onPressed,
                            label: Text(labelText),
                            icon: icon,
                            // backgroundColor: Theme.of(context).colorScheme.secondary,
                            // foregroundColor:
                            //     Theme.of(context).colorScheme.onSecondary,
                            // extendedTextStyle: Theme.of(context).textTheme.bodyLarge,
                          ),
                  )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) => Column(
        children: [
          Stack(
            children: [
              ..._getHero(Theme.of(context).brightness == Brightness.dark),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: appbarHeight),
                    Text(
                      "Good Morning, Daniel",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.displaySmall!.fontSize!,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "It's time to meditate.",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize!,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 2x2 grid of 4 buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _getButton(
                          context: context,
                          labelText: "New Project",
                          onPressed: () {},
                          isPrimary: true,
                          icon: const Icon(Icons.add_rounded),
                        ),
                        _getButton(
                          context: context,
                          labelText: "Project List",
                          onPressed: () {
                            store.dispatch(
                                NavToProjectListAction(context: context));
                          },
                          isPrimary: true,
                          icon: const Icon(Icons.list_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _getButton(
                          context: context,
                          labelText: "Store",
                          onPressed: () {},
                          icon: const Icon(Icons.store_rounded),
                        ),
                        _getButton(
                          context: context,
                          labelText: "Settings",
                          onPressed: () {},
                          icon: const Icon(Icons.settings_rounded),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
