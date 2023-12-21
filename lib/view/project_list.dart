import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';

import 'project_list_item.dart';

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
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ProjectListItem(project: project);
              },
            ),
          );
        });
  }
}
