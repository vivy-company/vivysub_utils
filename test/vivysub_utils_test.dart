import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vivysub_utils/ass_stringify.dart';
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

  test('ass stringify', () {
    final sections = assParser.getSections();
    final assStringify = AssStringify(sections: sections);

    final result = assStringify.export();

    expect(result, content);
  });

  test('subtitle editor add', () {
    final editor = SubtitleEditor(parser: assParser, onChange: print);

    editor.add(type: ActionType.dialog, value: 'test');
  });

  test('subtitle editor state', () {
    final editor = SubtitleEditor(parser: assParser, onChange: print);

    final dialogs = editor.getDialogs();
    print(jsonEncode(dialogs));
  });

  test('subtitle editor update', () {
    final editor = SubtitleEditor(
        parser: assParser,
        onChange: (String subtitle) {
          expect(subtitle, 'update');
        });

    editor.update(type: ActionType.metadata, value: 'test', id: '1');
  });

  test('subtitle editor remove', () {
    final editor = SubtitleEditor(parser: assParser, onChange: print);

    editor.remove(type: ActionType.comments, id: 'test');
  });
}
