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

class Subtitle {
  late Map _content;

  Subtitle(
      {required Map subtitle,
      int? startTime,
      int? endTime,
      bool? withoutTags}) {
    _content = subtitle;

    if (endTime != null) {
      setEndTime(endTime);
    }

    if (startTime != null) {
      setStartTime(startTime);
    }

    if (withoutTags!) {
      removeTags();
    }
  }

  removeTags() {
    _content['Text'] = _content['Text'].replaceAll(RegExp(r'/{.*?}/gim'), "");

    return _content['Text'];
  }

  getDurections() {
    String end = _content['End'];
    String start = _content['Start'];

    final result = timeToSeconds(end) - timeToSeconds(start);
    if (result == 0) {
      return 1;
    }

    return result;
  }

  setStartTime(time) {
    _content['Start'] = convertMsToSubtitleFormat(time);
  }

  setEndTime(time) {
    _content['End'] = convertMsToSubtitleFormat(time);
  }

  export() {
    return _content;
  }
}
