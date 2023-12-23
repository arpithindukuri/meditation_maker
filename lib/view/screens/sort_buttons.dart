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
      showSelectedIcon: false,
      segments: const <ButtonSegment<SortType>>[
        ButtonSegment<SortType>(
          value: SortType.name,
          label: Text('Day'),
        ),
        ButtonSegment<SortType>(
          value: SortType.created,
          label: Text('Week'),
        ),
        ButtonSegment<SortType>(
          value: SortType.modified,
          label: Text('Month'),
        ),
        ButtonSegment<SortType>(
          value: SortType.played,
          label: Text('Year'),
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
