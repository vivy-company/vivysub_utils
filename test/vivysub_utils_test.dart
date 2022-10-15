import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vivysub_utils/vivysub_utils.dart';
import 'dart:io';

void main() async {
  final content = await File('test/test.ass').readAsString();
  final assParser = AssParser(content: content);

  test('get comments', () {
    final comments = assParser.getComments();
    expect(comments, [
      {
        "type": "comment",
        "value": "This is a Sub Station Alpha v4 script.",
      },
      {
        "type": "comment",
        "value": "For Sub Station Alpha info and downloads,",
      },
      {
        "type": "comment",
        "value": "go to http://www.eswat.demon.co.uk/",
      }
    ]);
  });

  test('get metadata', () {
    final metadata = assParser.getMetadata();
  });

  test('get sections', () {
    List sections = assParser.getSections();
  });

  test('get dialogs', () {
    final dialogs = assParser.getDialogs();
  });

  test('get styles', () {
    final styles = assParser.getStyles();
  });
}
