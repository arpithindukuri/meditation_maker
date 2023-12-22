import 'package:redux/redux.dart';
import 'package:meditation_maker/model/project.dart';

sealed class EditProjectAction {}

class AddInputAction extends EditProjectAction {}

class RemoveInputAction extends EditProjectAction {
  final int index;

  RemoveInputAction(this.index);
}

class SetEditingProjectAction extends EditProjectAction {
  final Project? project;

  SetEditingProjectAction({this.project});
}

final editingProjectReducer = combineReducers<Project?>([
  TypedReducer<Project?, SetEditingProjectAction>(_setEditingProject).call,
  TypedReducer<Project?, AddInputAction>(_addInput).call,
  TypedReducer<Project?, RemoveInputAction>(_removeInput).call,
]);

Project? _setEditingProject(Project? state, SetEditingProjectAction action) {
  return action.project;
}

Project? _addInput(Project? state, AddInputAction action) {
  if (state == null) return null;

  return state.copyWith(inputs: [...state.inputs, SpeakInput(text: '')]);
}

Project? _removeInput(Project? state, RemoveInputAction action) {
  if (state == null) return null;

  return state.copyWith(inputs: [
    ...state.inputs.sublist(0, action.index),
    ...state.inputs.sublist(action.index + 1)
  ]);
}
