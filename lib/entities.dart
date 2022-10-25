import 'package:vivysub_utils/types.dart';
import 'package:vivysub_utils/vivysub_utils.dart';

class Subtitle implements BaseEntity {
  late Entity _content;

  Subtitle(
      {required Entity subtitle,
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
    _content.value['Text'] =
        _content.value['Text'].replaceAll(RegExp(r'/{.*?}/gim'), "");

    return _content.value['Text'];
  }

  getDurections() {
    String end = _content.value['End'];
    String start = _content.value['Start'];

    final result = timeToSeconds(end) - timeToSeconds(start);
    if (result == 0) {
      return 1;
    }

    return result;
  }

  setStartTime(time) {
    _content.value['Start'] = convertMsToSubtitleFormat(time);
  }

  setEndTime(time) {
    _content.value['End'] = convertMsToSubtitleFormat(time);
  }

  @override
  export() {
    return _content;
  }
}

class SubComment implements BaseEntity {
  late String message;
  late Entity initial;

  SubComment({
    required this.initial,
    required this.message,
  });

  @override
  export() {
    initial.value['value'] = message;

    return initial;
  }
}
