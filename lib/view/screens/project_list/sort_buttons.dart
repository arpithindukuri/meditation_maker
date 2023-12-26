import 'package:flutter/material.dart';

enum SortType { name, created, modified, played }

class SortButtons extends StatefulWidget {
  const SortButtons({super.key});

  @override
  State<SortButtons> createState() => _SortButtonsState();
}

class _SortButtonsState extends State<SortButtons> {
  SortType selectedSortType = SortType.name;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<SortType>(
      // style: const ButtonStyle(
      //   visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      // ),
      style: TextButton.styleFrom(
        visualDensity: const VisualDensity(horizontal: 2, vertical: 0),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      showSelectedIcon: false,
      segments: const <ButtonSegment<SortType>>[
        ButtonSegment<SortType>(
          value: SortType.name,
          label: Text('name'),
        ),
        ButtonSegment<SortType>(
          value: SortType.created,
          label: Text('created'),
        ),
        ButtonSegment<SortType>(
          value: SortType.modified,
          label: Text('modified'),
        ),
        ButtonSegment<SortType>(
          value: SortType.played,
          label: Text('played'),
        ),
      ],
      selected: <SortType>{selectedSortType},
      onSelectionChanged: (Set<SortType> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          selectedSortType = newSelection.first;
        });
      },
    );
  }
}
