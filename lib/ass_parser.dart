import 'package:vivysub_utils/types.dart';

class Section {
  String? name;
  List<Entity> body;

  Section({required this.name, required this.body});

  Map toJson() => {'name': name, 'body': body};
}

class AssParser {
  late String _content;

  late final List<Section> _sections = [];
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
      if (nextIndex <= sectionsMap.length - 1) {
        nextSection = rawSections.elementAt(nextIndex);
      }

      var lines = _content.substring(startIndex, nextSection?.start);

      var section = Section(
        name: currentSection.group(0),
        body: _parseSection(lines),
      );

      _sections.add(section);

      for (var element in _sections.toList().elementAt(0).body) {
        if (element.value['type'] != 'comment') {
          _metadata.add(element);
        }
      }
    });
  }

  List<Entity> _parseSection(String lines) {
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
        formatValue = value.split(',').map((e) => e.trim()).toList().asMap();

        result.add({
          "key": key.trim(),
          "value": value.split(',').map((e) => e.trim()).toList(),
        });

        continue;
      }

      if (formatValue.isNotEmpty) {
        var dialogueValue = {};

        Map props = value.trim().split(',').toList().asMap();
        var validValues = props.length == formatValue.length;

        if (!validValues) {
          List data = [];

          var temp = '';
          props.forEach((key, value) {
            if (key < formatValue.length - 1) {
              data.add(value);
            } else {
              temp = temp.isNotEmpty ? '$temp,$value' : value;
            }
          });

          data.add(temp);

          props = data.toList().asMap();
        }

        props.forEach((key, value) {
          var propKey = formatValue[key];

          dialogueValue[propKey] = value.isNotEmpty ? value : null;
        });

        result.add({
          "key": key.trim(),
          "value": dialogueValue,
        });

        continue;
      }

      result.add({
        "key": key.trim(),
        "value": value,
      });

      continue;
    }

    return result.map(
      (e) {
        return Entity(
          value: e,
        );
      },
    ).toList();
  }

  _getSectionByName(String name) {
    final section = _sections.where((element) => element.name!.contains(name));

    return section.elementAt(0).body;
  }

  getSections() {
    return _sections;
  }

  getDialogs() {
    return _getSectionByName('Events');
  }

  getStyles() {
    return _getSectionByName('Styles');
  }

  getComments() {
    return _comments;
  }

  getMetadata() {
    return _metadata;
  }
}
