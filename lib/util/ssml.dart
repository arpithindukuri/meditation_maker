import 'package:meditation_maker/model/project.dart';

String inputsToSSML(List<Input> list) {
  String ssml = '<speak>\n';

  for (Input item in list) {
    if (item.type == InputType.speak) {
      String? itemText = (item as SpeakInput).text;

      if (itemText != null) {
        ssml += '$itemText.trim()\n';
      }
    } else if (item.type == InputType.pause) {
      num? itemDelay = (item as PauseInput).delayMS;

      if (itemDelay != null) {
        ssml += '<break time="$itemDelay"/>\n';
      }
    }
  }

  ssml += '</speak>\n';

  return ssml;
}
