import 'package:flutter/material.dart';

class AppAudioBar extends StatelessWidget {
  const AppAudioBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
