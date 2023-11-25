import 'package:isar/isar.dart';
import 'package:meditation_maker/util/ssml.dart';

part 'project.g.dart';

enum InputType { speak, pause }

class Input {
  @Enumerated(EnumType.name)
  InputType? type;

  Input({this.type});
}

@embedded
class SpeakInput extends Input {
  String? text;

  SpeakInput({this.text}) : super(type: InputType.speak);
}

@embedded
class PauseInput extends Input {
  num? delayMS;

  PauseInput({this.delayMS}) : super(type: InputType.pause);
}

@collection
class Project {
  Id? id = Isar.autoIncrement;

  String? name;

  List<Input>? inputs;

  Project({this.name, this.inputs});

  String toSSMLString() {
    return inputsToSSML(inputs ?? []);
  }
}
