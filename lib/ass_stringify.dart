import 'package:vivysub_utils/ass_parser.dart';

pickValues(value, format) {
  return format.map((key) {
    return value[key] ?? '';
  });
}

final stringifyDescriptor = {
  "comment": (comment, format) {
    return '; ${comment['value']}';
  },
  "formatSpec": (formatSpec, format) {
    return formatSpec['key'] + ': ' + formatSpec['value'].join(',');
  },
  "properties": (properties, format) {
    return properties['key'] +
        ': ' +
        pickValues(properties['value'], format).join(',');
  },
  "raw": (raw, format) {
    return raw['key'] + ': ' + raw['value'];
  }
};

class AssStringify {
  late List<Section> _sections;

  AssStringify({required List<Section> sections}) {
    _sections = sections;
  }

  _stringifySection(Section section) {
    final head = section.name;
    dynamic format;

    var body = section.body.map((dynamic descriptor) {
      final method = (descriptor['type'] == 'comment')
          ? 'comment'
          : (descriptor['key'] == 'Format')
              ? 'formatSpec'
              : format != null
                  ? 'properties'
                  : 'raw';

      if (method == 'formatSpec') {
        format = descriptor['value'];
      }

      final worker = stringifyDescriptor[method];

      return worker!(descriptor, format);
    }).join('\n');

    return body.isNotEmpty ? '$head\n$body' : head;
  }

  export() {
    return _sections.map(_stringifySection).join('\n\n');
  }
}
