import 'package:meditation_maker/model/input.dart';
import 'package:redux/redux.dart';
import 'package:meditation_maker/model/project.dart';

sealed class EditProjectAction {}

class SetEditingProjectAction extends EditProjectAction {
  final Project? project;

  SetEditingProjectAction({this.project});
}

class AddInputAction extends EditProjectAction {
  final int index;
  final InputType type;

  AddInputAction({required this.index, required this.type});
}

class RemoveInputAction extends EditProjectAction {
  final int index;

  RemoveInputAction({required this.index});
}

class UpdateInputAction extends EditProjectAction {
  final int index;
  final Input input;

  UpdateInputAction({required this.index, required this.input});
}

final editingProjectReducer = combineReducers<Project?>([
  TypedReducer<Project?, SetEditingProjectAction>(_setEditingProject).call,
  TypedReducer<Project?, AddInputAction>(_addInput).call,
  TypedReducer<Project?, RemoveInputAction>(_removeInput).call,
  TypedReducer<Project?, UpdateInputAction>(_updateInput).call,
]);

Project? _setEditingProject(Project? state, SetEditingProjectAction action) {
  return action.project;
}

Project? _addInput(Project? state, AddInputAction action) {
  if (state == null) return null;

  return state.copyWith(inputs: [
    ...state.inputs.sublist(0, action.index + 1),
    if (action.type == InputType.speak) SpeakInput(text: ''),
    if (action.type == InputType.pause) PauseInput(delayMS: 0),
    ...state.inputs.sublist(action.index + 1),
  ]);

  // return state.copyWith(inputs: [...state.inputs, SpeakInput(text: '')]);
}

Project? _removeInput(Project? state, RemoveInputAction action) {
  if (state == null) return null;

  return state.copyWith(inputs: [
    ...state.inputs.sublist(0, action.index),
    ...state.inputs.sublist(action.index + 1)
  ]);
}

Project? _updateInput(Project? state, UpdateInputAction action) {
  if (state == null) return null;

  return state.copyWith(
    inputs: [
      ...state.inputs.sublist(0, action.index),
      action.input,
      ...state.inputs.sublist(action.index + 1)
    ],
  );
}
