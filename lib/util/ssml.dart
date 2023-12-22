import 'package:meditation_maker/model/project.dart';

String inputsToSSML(List<Input> list) {
  String ssml = '<speak>\n';

  for (Input item in list) {
    switch (item.type) {
      case InputType.speak:
        String? itemText = (item as SpeakInput).text;
        ssml += '$itemText.trim()\n';
        break;
      case InputType.pause:
        num? itemDelay = (item as PauseInput).delayMS;
        ssml += '<break time="$itemDelay"/>\n';
        break;
      default:
        break;
    }
  }

  ssml += '</speak>\n';

  return ssml;
}
