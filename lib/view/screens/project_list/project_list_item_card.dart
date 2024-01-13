import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/player_state_redux.dart';
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
    String joinedInputs = project.inputs
        .whereType<SpeakInput>()
        .map((input) {
          return input.text.replaceAll("\n", " ");
        })
        .toList()
        .join(" ");

    if (joinedInputs.isEmpty) {
      joinedInputs = "Empty";
    }

    return StoreConnector<AppState, bool>(
        converter: (store) => store.state.playerState.isAudioLoading,
        builder: (context, isAudioLoading) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow_rounded),
                    onPressed: isAudioLoading
                        ? null
                        : () {
                            store.dispatch(PlayProjectAction(project: project));
                          },
                  ),
                  Expanded(
                    child: ListTile(
                      titleTextStyle: Theme.of(context).textTheme.bodyLarge,
                      subtitleTextStyle: Theme.of(context).textTheme.bodyMedium,
                      title: Text(project.name),
                      subtitle: Text(joinedInputs,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded),
                        onPressed: isAudioLoading
                            ? null
                            : () {
                                store.dispatch(
                                  DeleteProjectAction(project: project),
                                );
                              },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: isAudioLoading
                            ? null
                            : () {
                                store.dispatch(
                                  NavToProjectEditorAction(
                                    context: context,
                                    project: project,
                                  ),
                                );
                              },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
