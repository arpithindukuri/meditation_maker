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
}

class SpeakInput extends Input {
  String text;

  SpeakInput({required this.text}) : super(type: InputType.speak);
}

class PauseInput extends Input {
  num delayMS;

  PauseInput({required this.delayMS}) : super(type: InputType.pause);
}

class Project {
  String name;

  List<Input> inputs;

  Project({required this.name, required this.inputs});

  String toSSMLString() {
    return inputsToSSML(inputs);
  }

  Project copyWith({String? name, List<Input>? inputs}) {
    return Project(name: name ?? this.name, inputs: inputs ?? this.inputs);
  }
}
