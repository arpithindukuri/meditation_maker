import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:redux/redux.dart';

sealed class NavAction {
  final AppScreen newScreen;

  NavAction({required this.newScreen});
}

class NavToProjectListAction extends NavAction {
  NavToProjectListAction() : super(newScreen: AppScreen.projectList);
}

class NavToProjectEditorAction extends NavAction {
  final Project? project;

  NavToProjectEditorAction({this.project})
      : super(newScreen: AppScreen.projectEditor);
}

final List<
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    currentScreenMiddleware = [
  TypedMiddleware<AppState, NavToProjectEditorAction>(
          _navToProjectEditorMiddleware)
      .call,
];

void _navToProjectEditorMiddleware(
    Store<AppState> store, NavToProjectEditorAction action, next) {
  store.dispatch(SetEditingProjectAction(project: action.project));

  next(action);
}

final currentScreenReducer = combineReducers<AppScreen>([
  TypedReducer<AppScreen, NavToProjectListAction>(_navToProjectList).call,
  TypedReducer<AppScreen, NavToProjectEditorAction>(_navToProjectEditor).call,
]);

AppScreen _navToProjectList(AppScreen state, NavToProjectListAction action) {
  return action.newScreen;
}

AppScreen _navToProjectEditor(
    AppScreen? state, NavToProjectEditorAction action) {
  return action.newScreen;
}