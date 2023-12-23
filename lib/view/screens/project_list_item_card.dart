import 'package:flutter/material.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/nav_redux.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:meditation_maker/redux/redux_store.dart';

class ProjectListItemCard extends StatelessWidget {
  final Project project;

  const ProjectListItemCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    String joinedInputs = project.inputs.join(" ");

    if (joinedInputs.isEmpty) {
      joinedInputs = "Empty";
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.play_arrow),
            const SizedBox(width: 8),
            Expanded(
              child: ListTile(
                title: Text(project.name),
                subtitle: Text(joinedInputs,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    store.dispatch(DeleteProjectAction(project: project));
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    store.dispatch(NavToProjectEditorAction(project: project));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
