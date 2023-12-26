import 'package:flutter/material.dart';
import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/project.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:redux/redux.dart';

class AppLoadingAction {
  final bool isLoading;

  AppLoadingAction({required this.isLoading});
}

final appLoadingReducer = combineReducers<bool>([
  TypedReducer<bool, AppLoadingAction>(_appLoading).call,
]);

bool _appLoading(bool state, AppLoadingAction action) {
  return action.isLoading;
}

sealed class NavAction {
  final BuildContext context;
  final AppScreen newScreen;

  NavAction({required this.newScreen, required this.context});
}

class NavCloseProjectEditorAction extends NavAction {
  NavCloseProjectEditorAction({required super.context})
      : super(newScreen: AppScreen.projectList);
}

class NavToProjectEditorAction extends NavAction {
  final Project? project;

  NavToProjectEditorAction({required super.context, this.project})
      : super(newScreen: AppScreen.projectEditor);
}

final List<
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    currentScreenMiddleware = [
  TypedMiddleware<AppState, NavToProjectEditorAction>(
    _navToProjectEditorMiddleware,
  ).call,
];

void _navToProjectEditorMiddleware(
    Store<AppState> store, NavToProjectEditorAction action, next) {
  store.dispatch(SetEditingProjectAction(project: action.project));

  next(action);
}

final currentScreenReducer = combineReducers<AppScreen>([
  TypedReducer<AppScreen, NavToProjectEditorAction>(_navToProjectEditor).call,
  TypedReducer<AppScreen, NavCloseProjectEditorAction>(_navExitProjectEditor)
      .call,
]);

AppScreen _navExitProjectEditor(
    AppScreen state, NavCloseProjectEditorAction action) {
  Navigator.pop(action.context);

  return action.newScreen;
}

AppScreen _navToProjectEditor(
    AppScreen state, NavToProjectEditorAction action) {
  Navigator.pushNamed(action.context, '/${action.newScreen.name}');

  return action.newScreen;
}
