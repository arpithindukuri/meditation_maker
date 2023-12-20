import 'package:redux/redux.dart';
import 'package:meditation_maker/model/project.dart';

sealed class Action {}

class AddInputAction extends Action {}

class RemoveInputAction extends Action {
  final int index;

  RemoveInputAction(this.index);
}

final editingProjectReducer = combineReducers<Project?>([
  TypedReducer<Project?, AddInputAction>(_addInput).call,
  TypedReducer<Project?, RemoveInputAction>(_removeInput).call,
]);

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
