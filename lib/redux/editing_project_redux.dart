import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/model/wrapped.dart';
import 'package:meditation_maker/redux/player_state_redux.dart';
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

final editingProjectMiddleware = [
  TypedMiddleware<AppState, EditProjectAction>(
    _editProjectMiddleware,
  ).call,
];

// set playing project for any project editor action
void _editProjectMiddleware(
  Store<AppState> store,
  EditProjectAction action,
  NextDispatcher next,
) {
  Project? playingProject;
  Input? playingInput;

  if (action is SetEditingProjectAction) {
    playingProject = _setEditingProject(store.state.editingProject, action);
  } else if (action is AddInputAction) {
    playingProject = _addInput(store.state.editingProject, action);
  } else if (action is RemoveInputAction) {
    playingProject = _removeInput(store.state.editingProject, action);
  } else if (action is UpdateInputAction) {
    playingProject = _updateInput(store.state.editingProject, action);
  }

  if (playingProject != null) {
    if (action is SetEditingProjectAction) {
      playingInput =
          playingProject.inputs.isEmpty ? null : playingProject.inputs.first;
    } else if (action is AddInputAction) {
      playingInput = playingProject.inputs[action.index];
    } else if (action is RemoveInputAction) {
      if (playingProject.inputs.isEmpty) {
        playingInput = null;
      } else {
        if (action.index == 0) {
          playingInput = playingProject.inputs.first;
        } else {
          playingInput = playingProject.inputs[action.index];
        }
      }
    } else if (action is UpdateInputAction) {
      playingProject = _updateInput(store.state.editingProject, action);
    }
  }

  store.dispatch(
    SetPlayerStateAction(
      playerState: store.state.playerState.copyWith(
        playingProject: Wrapped.value(playingProject),
        playingInput: Wrapped.value(playingInput),
      ),
    ),
  );

  next(action);
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

Project _addInput(Project? state, AddInputAction action) {
  if (state == null) {
    return Project(
      name: "ERROR while adding input",
      created: DateTime.timestamp(),
      inputs: [],
    );
  } else {
    return state.copyWith(
      inputs: [
        ...state.inputs.sublist(0, action.index + 1),
        if (action.type == InputType.speak)
          SpeakInput(
            orderIndex: action.index + 1,
            text: '',
          ),
        if (action.type == InputType.pause)
          PauseInput(
            orderIndex: action.index + 1,
            delayMS: 0,
          ),
        ...state.inputs.sublist(action.index + 1).map(
              (input) => input.copyWith(
                orderIndex: input.orderIndex + 1,
              ),
            ),
      ],
    );
  }
}

Project _removeInput(Project? state, RemoveInputAction action) {
  if (state == null) {
    return Project(
      name: "ERROR while removing input",
      created: DateTime.timestamp(),
      inputs: [],
    );
  } else {
    return state.copyWith(
      inputs: [
        ...state.inputs.sublist(0, action.index),
        ...state.inputs.sublist(action.index + 1).map(
              (input) => input.copyWith(
                orderIndex: input.orderIndex - 1,
              ),
            )
      ],
    );
  }
}

Project _updateInput(Project? state, UpdateInputAction action) {
  if (state == null) {
    return Project(
      name: "ERROR while updating input",
      created: DateTime.timestamp(),
      inputs: [action.input],
    );
  } else {
    return state.copyWith(
      inputs: [
        ...state.inputs.sublist(0, action.index),
        action.input,
        ...state.inputs.sublist(action.index + 1)
      ],
    );
  }
}
