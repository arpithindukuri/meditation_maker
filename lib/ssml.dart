String listToSSML(List<String> list) {
  String ssml = '<speak>\n';
  for (String item in list) {
    ssml += item;
    ssml += '\n';
    ssml += '<break time="3s"/>\n';
  }
  ssml += '</speak>\n';
  return ssml;
}
