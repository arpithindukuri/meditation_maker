import 'dart:convert';

import 'package:meditation_maker/model/input.dart';
import 'package:meditation_maker/util/ssml.dart';

class Project {
  String name;

  List<Input> inputs;

  String datetimeCreatedISO = DateTime.now().toIso8601String();

  Project(
      {required this.name, this.inputs = const [], String? datetimeCreatedISO})
      : datetimeCreatedISO =
            datetimeCreatedISO ?? DateTime.now().toIso8601String();

  String toSSMLString() {
    return inputsToSSML(inputs);
  }

  Project copyWith({String? name, List<Input>? inputs}) {
    return Project(name: name ?? this.name, inputs: inputs ?? this.inputs);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'inputs': inputs.map((input) => input.toJson()).toList(),
    };
  }

  static Project? fromJson(Map<String, dynamic> json) {
    final jsonName = json['name'];
    final jsonInputs = json['inputs'];

    if (jsonName == null || jsonName is! String) {
      return null;
    }
    if (jsonInputs == null || jsonInputs is! List<dynamic>) {
      return null;
    }

    final project = Project(
      name: json['name'],
      inputs: List<Input>.of(jsonInputs.map<Input>((inputMap) {
        Input mapResult =
            SpeakInput(text: "ERROR: Invalid input in project file");

        if (inputMap['type'] == InputType.speak.name) {
          final res = SpeakInput().fromJson(inputMap);
          if (res != null) {
            mapResult = res;
          }
        } else if (inputMap['type'] == InputType.pause.name) {
          final res = PauseInput().fromJson(inputMap);
          if (res != null) {
            mapResult = res;
          }
        } else {
          throw Exception('Invalid input type');
        }

        return mapResult;
      })),
    );

    return project;
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  static Project? fromJsonString(String jsonString) {
    try {
      return fromJson(json.decode(jsonString));
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    String inputsString = '';
    for (Input input in inputs) {
      inputsString += '$input,\n';
    }
    return '''Project{\n
                name: $name,\n
                inputs: [\n
                  $inputsString\n
                ]\n
              }''';
  }
}
