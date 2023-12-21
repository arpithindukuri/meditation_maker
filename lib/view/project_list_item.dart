import 'package:flutter/material.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';

class ProjectListItem extends StatelessWidget {
  final Project project;

  const ProjectListItem({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    String joinedInputs = project.inputs.join(" ");

    if (joinedInputs.isEmpty) {
      joinedInputs = "No inputs";
    }

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
                icon: const Icon(Icons.delete),
                onPressed: () {
                  store.dispatch(DeleteProjectAction(project: project));
                },
              ),
              const SizedBox(width: 4),
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
