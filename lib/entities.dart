import 'package:vivysub_utils/types.dart';
import 'package:vivysub_utils/vivysub_utils.dart';

class SubDialog implements BaseEntity {
  late Entity _initial;

  late String? style;
  late String? text;
  late bool? withoutTags;
  late int? endTime;
  late int? startTime;

  SubDialog({
    required Entity initial,
    this.startTime,
    this.endTime,
    this.withoutTags,
    this.style,
    this.text,
  }) {
    _initial = initial;
  }

  removeTags() {
    _initial.value['Text'] = _initial.value['Text'];

    return _initial.value['Text'];
  }

  getDurections() {
    String end = _initial.value['End'];
    String start = _initial.value['Start'];

    final result = timeToSeconds(end) - timeToSeconds(start);
    if (result == 0) {
      return 1;
    }

    return result;
  }

  setStartTime(time) {
    _initial.value['Start'] = convertMsToSubtitleFormat(time);
  }

  setEndTime(time) {
    _initial.value['End'] = convertMsToSubtitleFormat(time);
  }

  @override
  export() {
    final values = Map.from(_initial.value['value']);
    if (text != null) {
      values['Text'] = text;
    }

    if (startTime != null) {
      values['Start'] = convertMsToSubtitleFormat(startTime!);
    }

    if (endTime != null) {
      values['End'] = convertMsToSubtitleFormat(endTime!);
    }

    if (withoutTags != null) {
      values['Text'] = values['Text'].replaceAll(RegExp(r'/{.*?}/gim'), "");
    }

    if (style != null) {
      values['Style'] = style;
    }

    _initial.value['value'] = values;

    return _initial;
  }
}

class SubComment implements BaseEntity {
  final String? message;
  late Entity _initial;

  SubComment({
    required initial,
    this.message,
  }) {
    _initial = initial;
  }

  @override
  export() {
    if (message != null) {
      _initial.value['value'] = message;
    }

    return _initial;
  }
}

class SubMetadata implements BaseEntity {
  final String? key;
  final String? value;
  late Entity _initial;

  SubMetadata({
    required initial,
    this.key,
    this.value,
  }) {
    _initial = initial;
  }

  @override
  export() {
    if (key != null) {
      _initial.value['key'] = key;
    }

    if (value != null) {
      _initial.value['value'] = value;
    }

    return _initial;
  }
}

class SubStyle implements BaseEntity {
  late final Entity _initial;
  final String? name;
  final String? fontname;
  final String? fontsize;
  final String? primaryColour;
  final String? secondaryColour;
  final String? tertiaryColour;
  final String? backColour;
  final String? bold;
  final String? italic;
  final String? borderStyle;
  final String? shadow;
  final String? alignment;
  final String? marginL;
  final String? marginR;
  final String? alphaLevel;
  final String? encoding;

  SubStyle({
    required initial,
    this.name,
    this.fontname,
    this.fontsize,
    this.primaryColour,
    this.secondaryColour,
    this.tertiaryColour,
    this.backColour,
    this.bold,
    this.italic,
    this.borderStyle,
    this.shadow,
    this.alignment,
    this.marginL,
    this.marginR,
    this.alphaLevel,
    this.encoding,
  }) {
    _initial = initial.clone();
  }

  @override
  export() {
    final values = Map.from(_initial.value['value']);
    if (name != null) {
      values['Name'] = name;
    }

    if (fontname != null) {
      values['Fontname'] = fontname;
    }

    if (fontsize != null) {
      values['Fontsize'] = fontsize;
    }

    if (primaryColour != null) {
      values['PrimaryColour'] = primaryColour;
    }

    if (secondaryColour != null) {
      values['SecondaryColour'] = secondaryColour;
    }

    if (tertiaryColour != null) {
      values['TertiaryColour'] = tertiaryColour;
    }

    if (backColour != null) {
      values['BackColour'] = backColour;
    }

    if (bold != null) {
      values['Bold'] = bold;
    }

    if (italic != null) {
      values['Italic'] = italic;
    }

    if (borderStyle != null) {
      values['BorderStyle'] = borderStyle;
    }

    if (italic != null) {
      values['Italic'] = italic;
    }

    if (shadow != null) {
      values['Shadow'] = shadow;
    }

    if (alignment != null) {
      values['Alignment'] = alignment;
    }

    if (marginL != null) {
      values['marginL'] = marginL;
    }

    if (marginR != null) {
      values['MarginR'] = marginR;
    }

    if (alphaLevel != null) {
      values['AlphaLevel'] = alphaLevel;
    }

    if (encoding != null) {
      values['Encoding'] = encoding;
    }

    _initial.value['value'] = values;

    return _initial;
  }
}
