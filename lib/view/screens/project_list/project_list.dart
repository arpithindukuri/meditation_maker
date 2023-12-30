import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';
import 'package:meditation_maker/view/layout/app_top_bar.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 36),
            itemCount: projects.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 12,
            ),
            itemBuilder: (context, index) {
              final project = projects[index];

              return Column(
                children: [
                  if (index == 0)
                    const SizedBox(
                      height: appbarHeight,
                    ),
                  if (index == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.sort_rounded),
                            SizedBox(width: 8),
                            SortButtons(),
                          ],
                        ),
                        IconButton.outlined(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.search_rounded),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  if (index == 0) const SizedBox(height: 24),
                  ProjectListItemCard(project: project),
                  if (index == projects.length - 1) const SizedBox(height: 24),
                ],
              );
            },
          );
        });
  }
}
