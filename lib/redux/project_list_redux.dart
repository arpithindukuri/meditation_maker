import 'package:redux/redux.dart';
import 'package:meditation_maker/model/project.dart';

sealed class Action {}

class InitializeAction extends Action {}

// class OpenProjectAction extends Action {
//   final int index;

//   OpenProjectAction(this.index);
// }

// class AddInputAction extends Action {}

final projectListReducer = combineReducers<List<Project>>([
  TypedReducer<List<Project>, InitializeAction>(_initialize).call,
  // TypedReducer<List<Project>, OpenProjectAction>(_openProject).call,
  // TypedReducer<Project?, AddInputAction>(_addInput).call,
]);

List<Project> _initialize(List<Project>? state, InitializeAction action) {
  return [
    Project(name: "Proj. 1", inputs: defaultInputs),
    Project(name: "Proj. 2", inputs: defaultInputs),
    Project(name: "Proj. 3", inputs: defaultInputs),
  ];
}

// List<Project>? _openProject(List<Project>? state, OpenProjectAction action) {
//   if(action.index < 0 || action.index >= state!.length) return state;
// }

// Project? _addInput(Project? state, AddInputAction action) {
//   if (state == null) return null;

//   return state.copyWith(inputs: [...state.inputs, SpeakInput(text: '')]);
// }
