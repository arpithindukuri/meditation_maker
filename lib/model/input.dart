import 'package:meditation_maker/model/wrapped.dart';

List<Input> defaultInputs = [
  SpeakInput(text: 'some'),
  PauseInput(delayMS: 1000),
  SpeakInput(text: 'text'),
];

enum InputType { speak, pause }

abstract class Input {
  InputType type;

  Input({required this.type});

  Input copyWith();

  Map<String, dynamic> toJson();

  Input? fromJson(Map<String, dynamic> json);

  @override
  String toString();
}

class SpeakInput extends Input {
  String text;
  num? delayBetweenLinesMS;
  List<int>? audioBytes;

  SpeakInput({
    this.text = "",
    this.delayBetweenLinesMS,
    this.audioBytes,
  }) : super(type: InputType.speak);

  @override
  SpeakInput copyWith({
    String? text,
    Wrapped<num?>? delayBetweenLinesMS,
    Wrapped<List<int>?>? audioBytes,
  }) {
    return SpeakInput(
      text: text ?? this.text,
      delayBetweenLinesMS: delayBetweenLinesMS != null
          ? delayBetweenLinesMS.value
          : this.delayBetweenLinesMS,
      audioBytes: audioBytes != null ? audioBytes.value : this.audioBytes,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'text': text,
      'delayBetweenLinesMS': delayBetweenLinesMS,
      'audioBytes': audioBytes,
    };
  }

  @override
  SpeakInput? fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final text = json['text'];
    final delayBetweenLinesMS = json['delayBetweenLinesMS'];
    final audioBytes = json['audioBytes'];

    if (type != InputType.speak.name) return null;
    if (text == null) return null;

    return SpeakInput(
      text: text,
      delayBetweenLinesMS: delayBetweenLinesMS,
      audioBytes: audioBytes,
    );
  }

  @override
  String toString() {
    return 'SpeakInput {'
        '  type: $type, '
        '  text: $text, '
        '  delayBetweenLinesMS: $delayBetweenLinesMS, '
        '  audioBytes: $audioBytes'
        '}';
  }
}

class PauseInput extends Input {
  num delayMS;

  PauseInput({this.delayMS = 0}) : super(type: InputType.pause);

  @override
  PauseInput copyWith({num? delayMS}) {
    return PauseInput(delayMS: delayMS ?? this.delayMS);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'delayMS': delayMS,
    };
  }

  @override
  PauseInput? fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final delayMS = json['delayMS'];

    if (type != InputType.pause.name) return null;
    if (delayMS == null) return null;

    return PauseInput(delayMS: delayMS);
  }

  @override
  String toString() {
    return 'PauseInput {'
        '  type: $type, '
        '  delayMS: $delayMS'
        '}';
  }
}
