import 'dart:convert';
import 'dart:io';

import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:meditation_maker/model/project.dart';

sealed class ProjectListAction {}

class LoadProjectsAction extends ProjectListAction {}

class SetProjectsAction extends ProjectListAction {
  final List<Project> projects;

  SetProjectsAction({required this.projects});
}

class CreateProjectAction extends ProjectListAction {}

class UpdateProjectAction extends ProjectListAction {
  final Project project;

  UpdateProjectAction({required this.project});
}

class DeleteProjectAction extends ProjectListAction {
  final Project project;

  DeleteProjectAction({required this.project});
}

final List<
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    projectListMiddleware = [
  TypedMiddleware<AppState, LoadProjectsAction>(_loadProjectsMiddleware).call,
  TypedMiddleware<AppState, CreateProjectAction>(_createProjectMiddleware).call,
  TypedMiddleware<AppState, UpdateProjectAction>(_updateProjectMiddleware).call,
  TypedMiddleware<AppState, DeleteProjectAction>(_deleteProjectMiddleware).call,
];

void _loadProjectsMiddleware(
    Store<AppState> state, LoadProjectsAction action, next) async {
  final localDir = await getApplicationDocumentsDirectory();

  final files = localDir.listSync();

  List<Project> projects = [];

  for (final file in files) {
    if (file is File) {
      try {
        final projectMap = jsonDecode(file.readAsStringSync());
        final project = Project.fromJson(projectMap);

        if (project != null) {
          projects.add(project);
        } else {
          continue;
        }
      } catch (e) {
        // projects.add(
        //   Project(
        //     name: file.path.split('/').last,
        //     created: DateTime.now(),
        //     inputs: [
        //       SpeakInput(
        //           text:
        //               'ERROR: File is not a Project JSON at path: "${file.path}"')
        //     ],
        //   ),
        // );
      }
    }
  }

  state.dispatch(SetProjectsAction(projects: projects));

  next(action);
}

// TODO: move to util file
Future<String> getNewProjectName() async {
  final localDir = await getApplicationDocumentsDirectory();
  final localPath = localDir.path;

  String newProjName = "New Project";
  int duplicateNum = 0;

  File file = File('$localPath/$newProjName.json');

  // if it does, check if '$newProjName $duplicateNum.json' exists,
  while (file.existsSync() && duplicateNum < 100) {
    // and increment duplicateNum until a file with such a name doesn't exist
    duplicateNum++;
    file = File('$localPath/$newProjName $duplicateNum.json');
  }

  // then set newProjName to '$newProjName $duplicateNum'
  newProjName = duplicateNum > 0 ? '$newProjName $duplicateNum' : newProjName;

  return newProjName;
}

void _createProjectMiddleware(
    Store<AppState> state, CreateProjectAction action, next) async {
  final localDir = await getApplicationDocumentsDirectory();

  final localPath = localDir.path;

  final newProjName = await getNewProjectName();

  final file = File('$localPath/$newProjName.json');

  final newProject = Project(
    name: newProjName,
    created: DateTime.now(),
    inputs: defaultInputs,
  );

  final jsonString = jsonEncode(newProject.toJson());

  await file.writeAsString(jsonString);

  state.dispatch(LoadProjectsAction());

  next(action);
}

void _updateProjectMiddleware(
    Store<AppState> state, UpdateProjectAction action, next) async {
  final localDir = await getApplicationDocumentsDirectory();

  final localPath = localDir.path;

  final projName = action.project.name;

  final file = File('$localPath/$projName.json');

  final jsonString = jsonEncode(action.project.toJson());

  await file.writeAsString(jsonString);

  state.dispatch(LoadProjectsAction());

  next(action);
}

void _deleteProjectMiddleware(
    Store<AppState> state, DeleteProjectAction action, next) async {
  final localDir = await getApplicationDocumentsDirectory();

  final localPath = localDir.path;

  final file = File('$localPath/${action.project.name}.json');

  if (file.existsSync()) {
    file.deleteSync();
  }

  state.dispatch(LoadProjectsAction());

  next(action);
}

final projectListReducer = combineReducers<List<Project>>([
  TypedReducer<List<Project>, SetProjectsAction>(_setProjects).call,
]);

List<Project> _setProjects(List<Project>? state, SetProjectsAction action) {
  return action.projects;
}
