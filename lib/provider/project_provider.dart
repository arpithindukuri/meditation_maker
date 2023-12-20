// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:meditation_maker/model/project.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'project_provider.g.dart';

// List<Input> defaultInputs = [
//   SpeakInput(text: '111'),
//   SpeakInput(text: '222'),
//   SpeakInput(text: '333'),
//   // 'Find a quiet place where you won\'t be disturbed.',
//   // 'Sit comfortably with your back straight and your hands resting on your lap.',
//   // 'Close your eyes and take a deep breath in through your nose, hold it for a few seconds, then exhale slowly through your mouth.',
//   // 'Focus on your breath as it goes in and out of your body. If your mind starts to wander, gently bring it back to your breath.',
//   // 'Continue breathing deeply and focusing on your breath for as long as you like.',
// ];

// @riverpod
// class ProjectList extends _$ProjectList {
//   @override
//   Future<List<Project>> build() async {
//     // The logic we previously had in our FutureProvider is now in the build method.
//     return [
//       Project(name: "Proj. 1", inputs: defaultInputs)
//     ];
//   }
// }

// final projectProvider = StateNotifierProvider<ProjectState, Project>((ref) {
//   return ProjectState(project: Project(name: "Proj. 1", inputs: defaultInputs));
// });

// class ProjectState extends StateNotifier<Project> {
//   ProjectState({required Project project}) : super(project);

//   void addInput({String? newInput}) {
//     state = Project(
//         name: state.name,
//         inputs: [...state.inputs, SpeakInput(text: newInput)]);
//   }

//   void editInput(int index, String newText) {
//     state = Project(
//         name: state.name,
//         inputs: List<Input>.of(state.inputs)
//           ..replaceRange(index, index + 1, [SpeakInput(text: newText)]));
//   }

//   void deleteInput(int index) {
//     state = Project(name: state.name, inputs: state.inputs..removeAt(index));
//   }
// }
