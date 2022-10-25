import 'dart:io';

import 'package:vivysub_utils/ass_parser.dart';
import 'package:vivysub_utils/vivysub_utils.dart';

final content = File('test.ass').readAsStringSync();
final assParser = AssParser(content: content);

final sections = assParser.getSections();

final subtitles = AssStringify(sections: sections);

final fileContent = subtitles.export();
