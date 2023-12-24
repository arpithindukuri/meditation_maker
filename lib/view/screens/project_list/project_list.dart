import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';

import 'project_list_item_card.dart';
import 'sort_buttons.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  ProjectListState createState() => ProjectListState();
}

class ProjectListState extends State<ProjectList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Project>>(
        converter: (store) => store.state.projectList,
        onInit: (store) {
          store.dispatch(LoadProjectsAction());
        },
        builder: (context, projects) {
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: projects.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
            itemBuilder: (context, index) {
              final project = projects[index];
                  
              if (index == 0) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton.outlined(
                          icon: const Icon(Icons.search_rounded),
                          onPressed: () {
                            // Navigator.pushNamed(context, '/project-editor');
                          },
                        ),
                        const Row(
                          children: [
                            Text('Filter By: '),
                            SizedBox(width: 2),
                            SortButtons(),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ProjectListItemCard(project: project),
                  ],
                );
              } else if (index == projects.length - 1) {
                return Column(
                  children: [
                    ProjectListItemCard(project: project),
                    const SizedBox(height: 24),
                  ],
                );
              } else {
                return ProjectListItemCard(project: project);
              }
            },
          );
        });
  }
}
