import 'package:meditation_maker/model/input.dart';

// String inputsToSSML(List<Input> list) {
//   String ssml = '<speak>';

//   for (Input item in list) {
//     switch (item.type) {
//       case InputType.speak:
//         String? itemText = (item as SpeakInput).text;
//         ssml += '$itemText\n ';
//         break;
//       case InputType.pause:
//         num? itemDelay = (item as PauseInput).delayMS;
//         ssml += '<break time="${itemDelay / 1000}s"/>\n ';
//         break;
//       default:
//         break;
//     }
//   }

//   ssml += '</speak>';

//   return ssml;
// }

String speakInputToSSML(SpeakInput input) {
  String ssml = '<speak>\n';

  for (String line in input.text.split('\n')) {
    ssml += '$line\n ';

    if (input.delayBetweenLinesMS != null) {
      final breakTimeSec = input.delayBetweenLinesMS! / 1000;
      ssml += '<break time="${breakTimeSec}s" />\n ';
    }
  }

  ssml += '</speak>';

  return ssml;
}
