import 'package:meditation_maker/model/input.dart';

class Project {
  String name;
  DateTime created;
  List<Input> inputs;

  Project({required this.name, required this.created, this.inputs = const []});

  Project copyWith({
    String? name,
    DateTime? created,
    List<Input>? inputs,
  }) {
    return Project(
      name: name ?? this.name,
      created: created ?? this.created,
      inputs: inputs ?? this.inputs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'created': created.toIso8601String(),
      'inputs': inputs.map((input) => input.toJson()).toList(),
    };
  }

  static Project? fromJson(Map<String, dynamic> json) {
    final jsonName = json['name'];
    final jsonCreated = json['created'];
    final jsonInputs = json['inputs'];

    if (jsonName == null || jsonName is! String) {
      return null;
    }
    if (jsonCreated == null || jsonCreated is! String) {
      return null;
    }
    if (jsonInputs == null || jsonInputs is! List<dynamic>) {
      return null;
    }

    try {
      final String name = jsonName;
      final DateTime created = DateTime.parse(jsonCreated);
      final List<Input> inputs = List<Input>.of(
        jsonInputs.map<Input>(
          (inputMap) {
            final inputType = inputMap['type'];

            if (inputType == null || inputType is! String) {
              throw Exception('Invalid input type');
            }

            Input? mapResult;

            if (inputType == InputType.speak.name) {
              mapResult = SpeakInput().fromJson(inputMap);
            } else if (inputType == InputType.pause.name) {
              mapResult = PauseInput().fromJson(inputMap);
            }

            return mapResult ??
                SpeakInput(text: 'Error in saved project file. Invalid input.');
          },
        ),
      );

      final project = Project(
        name: name,
        created: created,
        inputs: inputs,
      );

      return project;
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'Project {'
        '  name: $name, '
        '  created: $created, '
        '  inputs: $inputs'
        '}';
  }
}
