import 'package:flutter/material.dart';
import 'package:meditation_maker/model/project.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;

  const ProjectListItem({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final joinedInputs = project.inputs.join(" ");

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(project.name),
                subtitle: Text(joinedInputs,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            Row(children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {},
              ),
            ])
          ],
        ),
      ),
    );
  }
}
