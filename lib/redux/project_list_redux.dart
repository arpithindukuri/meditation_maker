import 'dart:io';

import 'package:meditation_maker/model/app_state.dart';
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

class DeleteProjectAction extends ProjectListAction {
  final Project project;

  DeleteProjectAction({required this.project});
}

class SaveProjectAction extends ProjectListAction {
  final Project project;

  SaveProjectAction({required this.project});
}

final List<
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    projectListMiddleware = [
  TypedMiddleware<AppState, LoadProjectsAction>(_loadProjectsMiddleware).call,
  TypedMiddleware<AppState, CreateProjectAction>(_createProjectMiddleware).call,
  TypedMiddleware<AppState, DeleteProjectAction>(_deleteProjectMiddleware).call,
];

final projectListReducer = combineReducers<List<Project>>([
  // TypedReducer<List<Project>, LoadProjectsAction>(_loadProjects).call,
  TypedReducer<List<Project>, SetProjectsAction>(_setProjects).call,
  // TypedReducer<List<Project>, CreateProjectAction>(_createProject).call,
  // TypedReducer<List<Project>, DeleteProjectAction>(_deleteProject).call,
]);

// List<Project> _loadProjects(List<Project>? state, LoadProjectsAction action) {
//   if (state == null) return [];

//   return state;
// }

List<Project> _setProjects(List<Project>? state, SetProjectsAction action) {
  return action.projects;
}

void _loadProjectsMiddleware(
    Store<AppState> state, LoadProjectsAction action, next) async {
  final localDir = await getApplicationDocumentsDirectory();

  final files = localDir.listSync();

  List<Project> projects = [];

  for (final file in files) {
    if (file is File) {
      final project = Project.fromJsonString(file.readAsStringSync());

      if (project != null) {
        projects.add(project);
      } else {
        continue;
        // projects.add(Project(
        //     name: 'ERROR: File is not a Project JSON at path: "${file.path}"',
        //     inputs: []));
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

  final newProject = Project(name: newProjName, inputs: defaultInputs);

  await file.writeAsString(newProject.toJsonString());

  state.dispatch(LoadProjectsAction());

  next(action);
}

// List<Project> _createProject(List<Project> state, CreateProjectAction action) {
//   return state;
// }

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

// List<Project> _deleteProject(List<Project> state, DeleteProjectAction action) {
//   return state;
// }
 

