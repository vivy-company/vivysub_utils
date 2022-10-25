int timeToSeconds(String time) {
  Iterable<int> values = time.split(":").map((e) => e as int);

  final hours = values.elementAt(0);
  final minutes = values.elementAt(1);
  final seconds = values.elementAt(2);

  return hours * 60 * 60 + minutes * 60 + seconds;
}

String convertMsToSubtitleFormat(int ms) {
  final seconds = (ms / 1000) % 60;
  final minutes = ((ms / (60 * 1000)) % 60).floor();
  final hours = ((ms / (3600 * 1000)) % 3600).floor();

  return '$hours:${minutes < 10 ? "0$minutes" : minutes}:${seconds < 10 ? "0${seconds.toDouble()}" : seconds.toDouble()}';
}
