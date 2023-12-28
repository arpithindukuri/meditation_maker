import 'package:flutter/material.dart';
import 'package:meditation_maker/view/layout/app_top_bar.dart';

class AppAudioBar extends StatelessWidget {
  const AppAudioBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: BottomAppBar(
        height: toolbarHeight,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          // RoundedRectangleBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(20)),
          // ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.stop_rounded),
              onPressed: () {},
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
