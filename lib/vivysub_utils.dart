library vivysub_utils;

class AssParser {
  late String _content;

  late final List _sections = [];
  late final List _comments = [];
  late final List _metadata = [];

  AssParser({required String content}) {
    _content = content;

    var reg = RegExp(r'^\[(.*)\]', multiLine: true);
    var rawSections = reg.allMatches(_content);

    var sectionsMap = rawSections.toList().asMap();

    sectionsMap.forEach((key, currentSection) {
      dynamic nextSection;
      int startIndex = currentSection.end;

      var nextIndex = key + 1;
      if (nextIndex < sectionsMap.length - 1) {
        nextSection = rawSections.elementAt(nextIndex);
      }

      var lines = _content.substring(startIndex, nextSection?.start);

      _sections.add(
        {"name": currentSection.group(0), "body": _parseSection(lines)},
      );

      for (var element in _sections.toList().elementAt(0)['body']) {
        if (element['type'] != 'comment') {
          _metadata.add(element);
        }
      }
    });
  }

  _parseSection(String lines) {
    List result = [];
    Map formatValue = {};

    for (var line in lines.split('\n')) {
      if (line.trim().isEmpty) {
        continue;
      }

      if (line[0] == ';') {
        result.add({
          "type": 'comment',
          "value": line.substring(1).trim(),
        });

        _comments.add({
          "type": 'comment',
          "value": line.substring(1).trim(),
        });

        continue;
      }

      var parts = line.split(':');

      var key = parts[0];
      String value = parts.skip(1).join(':').trim();

      if (key == 'Format') {
        formatValue = value.split(',').toList().asMap();

        result.add({
          "key": key,
          "value": value.split(',').toList(),
        });

        continue;
      }

      if (key == 'Dialogue' && formatValue.isNotEmpty) {
        var dialogueValue = {};

        var props = value.split(',').toList().asMap();

        props.forEach((key, value) {
          var propKey = formatValue[key];
          dialogueValue[propKey] = value.isNotEmpty ? value : null;
        });

        result.add({
          "key": key,
          "value": dialogueValue,
        });

        continue;
      }

      result.add({
        "key": key,
        "value": value,
      });

      continue;
    }

    return result;
  }

  getSections() {
    return _sections;
  }

  getDialogs() {
    final dialogs = _sections
        .where((element) => (element['name'] as String).contains('Events'));

    return dialogs.elementAt(0)['body'];
  }

  getComments() {
    return _comments;
  }

  getMetadata() {
    return _metadata;
  }
}
