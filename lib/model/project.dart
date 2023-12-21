import 'dart:convert';

import 'package:meditation_maker/util/ssml.dart';

List<Input> defaultInputs = [
  SpeakInput(text: '111'),
  SpeakInput(text: '222'),
  SpeakInput(text: '333'),
  SpeakInput(text: '444'),
  SpeakInput(text: '555'),
];

enum InputType { speak, pause }

abstract class Input {
  InputType type;

  Input({required this.type});

  Map<String, dynamic> toJson();

  Input? fromJson(Map<String, dynamic> json);

  String toJsonString();

  Input? fromJsonString(String jsonString);
}

class SpeakInput extends Input {
  String text;

  SpeakInput({this.text = ""}) : super(type: InputType.speak);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'text': text,
    };
  }

  @override
  SpeakInput? fromJson(Map<String, dynamic> json) {
    return SpeakInput(text: json['text']);
  }

  @override
  String toJsonString() {
    return json.encode(toJson());
  }

  @override
  SpeakInput? fromJsonString(String jsonString) {
    try {
      return fromJson(json.decode(jsonString));
    } catch (e) {
      return null;
    }
  }
}

class PauseInput extends Input {
  num delayMS;

  PauseInput({this.delayMS = 0}) : super(type: InputType.pause);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'delayMS': delayMS,
    };
  }

  @override
  PauseInput? fromJson(Map<String, dynamic> json) {
    return PauseInput(delayMS: json['delayMS']);
  }

  @override
  String toJsonString() {
    return json.encode(toJson());
  }

  @override
  PauseInput? fromJsonString(String jsonString) {
    try {
      return fromJson(json.decode(jsonString));
    } catch (e) {
      return null;
    }
  }
}

class Project {
  String name;

  List<Input> inputs;

  Project({required this.name, this.inputs = const []});

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
      inputs: List<Input>.of(jsonInputs.map<Input>((input) {
        Input mapResult =
            SpeakInput(text: "ERROR: Invalid input in project file");

        if (input['type'] == InputType.speak.name) {
          input = SpeakInput().fromJson(input);
        } else if (input['type'] == InputType.pause.name) {
          input = PauseInput().fromJson(input);
        } else {
          throw Exception('Invalid input type');
        }

        return mapResult;
      })),
    );

    print('project: $project');

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
}
