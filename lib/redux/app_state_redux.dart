import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/editing_project_redux.dart';
import 'package:meditation_maker/redux/project_list_redux.dart';

AppState appReducer(AppState state, action) {
  return AppState(
      projectList: projectListReducer(state.projectList, action),
      editingProject: editingProjectReducer(state.editingProject, action),
      playingAudio: null);
}
