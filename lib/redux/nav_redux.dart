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

class NavToProjectListAction extends NavAction {
  NavToProjectListAction({required super.context})
      : super(newScreen: AppScreen.projectList);
}

class NavExitProjectListAction extends NavAction {
  NavExitProjectListAction({required super.context})
      : super(newScreen: AppScreen.homeScreen);
}

class NavToProjectEditorAction extends NavAction {
  final Project? project;

  NavToProjectEditorAction({required super.context, this.project})
      : super(newScreen: AppScreen.projectEditor);
}

class NavExitProjectEditorAction extends NavAction {
  NavExitProjectEditorAction({required super.context})
      : super(newScreen: AppScreen.projectList);
}

final List<
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>
    currentScreenMiddleware = [
  TypedMiddleware<AppState, NavToProjectEditorAction>(
    _navToProjectEditorMiddleware,
  ).call,
  TypedMiddleware<AppState, NavExitProjectEditorAction>(
    _navExitProjectEditorMiddleware,
  ).call,
];

void _navToProjectEditorMiddleware(
    Store<AppState> store, NavToProjectEditorAction action, next) {
  store.dispatch(SetEditingProjectAction(project: action.project));

  next(action);
}

void _navExitProjectEditorMiddleware(
    Store<AppState> store, NavExitProjectEditorAction action, next) {
  store.dispatch(SetEditingProjectAction(project: null));

  next(action);
}

final currentScreenReducer = combineReducers<AppScreen>([
  TypedReducer<AppScreen, NavToProjectListAction>(_navToProjectList).call,
  TypedReducer<AppScreen, NavExitProjectListAction>(_navExitProjectList).call,
  TypedReducer<AppScreen, NavToProjectEditorAction>(_navToProjectEditor).call,
  TypedReducer<AppScreen, NavExitProjectEditorAction>(_navExitProjectEditor)
      .call,
]);

AppScreen _navToProjectList(AppScreen state, NavToProjectListAction action) {
  Navigator.pushNamed(action.context, '/${action.newScreen.name}');

  return action.newScreen;
}

AppScreen _navExitProjectList(
    AppScreen state, NavExitProjectListAction action) {
  Navigator.pop(action.context);

  return action.newScreen;
}

AppScreen _navToProjectEditor(
    AppScreen state, NavToProjectEditorAction action) {
  Navigator.pushNamed(action.context, '/${action.newScreen.name}');

  return action.newScreen;
}

AppScreen _navExitProjectEditor(
    AppScreen state, NavExitProjectEditorAction action) {
  Navigator.pop(action.context);

  return action.newScreen;
}
