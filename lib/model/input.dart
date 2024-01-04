import 'dart:convert';

List<Input> defaultInputs = [
  SpeakInput(text: 'some'),
  PauseInput(delayMS: 1000),
  SpeakInput(text: 'text'),
];

// List<Input> defaultInputs = [
//   SpeakInput(text: '111'),
//   PauseInput(delayMS: 1000),
//   SpeakInput(text: '222'),
//   SpeakInput(text: '333'),
//   PauseInput(delayMS: 3000),
//   SpeakInput(text: '444'),
//   SpeakInput(text: '555'),
// ];

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
