import 'dart:io';

import 'package:vivysub_utils/ass_parser.dart';

final content = File('test.ass').readAsStringSync();
final assParser = AssParser(content: content);

final metadata = assParser.getMetadata();
final comments = assParser.getComments();
final dialogs = assParser.getDialogs();
final sections = assParser.getSections();
final styles = assParser.getStyles();
