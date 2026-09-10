int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;

  //speed = d/t ( d= distance , t = time)
  final readingTime = wordCount / 180;

  return readingTime.ceil();

  //ceil will take heightes value when double value changed to int.
}
