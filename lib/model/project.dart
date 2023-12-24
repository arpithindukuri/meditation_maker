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

  @override
  String toString();
}

class SpeakInput extends Input {
  String text;
  num? delayBetweenLinesMS;

  SpeakInput({this.text = "", this.delayBetweenLinesMS})
      : super(type: InputType.speak);

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

  @override
  String toString() {
    return 'SpeakInput{type: $type, text: $text}';
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

  @override
  String toString() {
    return 'PauseInput{type: $type, delayMS: $delayMS}';
  }
}

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
    for (Input input in this.inputs) {
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
