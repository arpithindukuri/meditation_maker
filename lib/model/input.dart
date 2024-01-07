import 'package:meditation_maker/model/wrapped.dart';

List<Input> defaultInputs = [
  SpeakInput(orderIndex: 0, text: 'some'),
  PauseInput(orderIndex: 1, delayMS: 1000),
  SpeakInput(orderIndex: 2, text: 'text'),
];

enum InputType { speak, pause }

abstract class Input {
  InputType type;
  int orderIndex;

  Input({required this.type, required this.orderIndex});

  Input copyWith({int? orderIndex});

  Map<String, dynamic> toJson();

  // Input? fromJson(Map<String, dynamic> json);

  @override
  String toString();
}

class SpeakInput extends Input {
  String text;
  num? delayBetweenLinesMS;
  List<int>? audioBytes;

  SpeakInput({
    required super.orderIndex,
    this.text = "",
    this.delayBetweenLinesMS,
    this.audioBytes,
  }) : super(
          type: InputType.speak,
        );

  @override
  SpeakInput copyWith({
    int? orderIndex,
    String? text,
    Wrapped<num?>? delayBetweenLinesMS,
    Wrapped<List<int>?>? audioBytes,
  }) {
    return SpeakInput(
      orderIndex: orderIndex ?? this.orderIndex,
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
      'orderIndex': orderIndex,
      'text': text,
      'delayBetweenLinesMS': delayBetweenLinesMS,
      'audioBytes': audioBytes,
    };
  }

  // @override
  static SpeakInput? fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final orderIndex = json['orderIndex'];
    final text = json['text'];
    final delayBetweenLinesMS = json['delayBetweenLinesMS'];
    final audioBytes = json['audioBytes'];

    if (type is! String || type != InputType.speak.name) return null;
    if (orderIndex == null || orderIndex is! int) return null;
    if (text == null || text is! String) return null;

    return SpeakInput(
      orderIndex: orderIndex,
      text: text,
      delayBetweenLinesMS: delayBetweenLinesMS,
      audioBytes: audioBytes,
    );
  }

  @override
  String toString() {
    return 'SpeakInput {'
        '  orderIndex: $orderIndex,'
        '  type: $type,'
        '  text: $text,'
        '  delayBetweenLinesMS: $delayBetweenLinesMS,'
        '  audioBytes: $audioBytes'
        '}';
  }
}

class PauseInput extends Input {
  num delayMS;

  PauseInput({
    required super.orderIndex,
    this.delayMS = 0,
  }) : super(
          type: InputType.pause,
        );

  @override
  PauseInput copyWith({
    int? orderIndex,
    num? delayMS,
  }) {
    return PauseInput(
      orderIndex: orderIndex ?? this.orderIndex,
      delayMS: delayMS ?? this.delayMS,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'orderIndex': orderIndex,
      'delayMS': delayMS,
    };
  }

  // @override
  static PauseInput? fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final orderIndex = json['orderIndex'];
    final delayMS = json['delayMS'];

    if (type is! String || type != InputType.pause.name) return null;
    if (orderIndex == null || orderIndex is! int) return null;
    if (delayMS == null || delayMS is! int) return null;

    return PauseInput(
      orderIndex: orderIndex,
      delayMS: delayMS,
    );
  }

  @override
  String toString() {
    return 'PauseInput {'
        '  type: $type,'
        '  orderIndex: $orderIndex,'
        '  delayMS: $delayMS'
        '}';
  }
}
