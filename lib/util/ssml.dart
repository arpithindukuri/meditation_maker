import 'package:meditation_maker/model/input.dart';

String inputsToSSML(List<Input> list) {
  String ssml = '<speak>';

  for (Input item in list) {
    switch (item.type) {
      case InputType.speak:
        String? itemText = (item as SpeakInput).text;
        ssml += '$itemText\n ';
        break;
      case InputType.pause:
        num? itemDelay = (item as PauseInput).delayMS;
        ssml += '<break time="${itemDelay/1000}s"/>\n ';
        break;
      default:
        break;
    }
  }

  ssml += '</speak>';

  return ssml;
}
