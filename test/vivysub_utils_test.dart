import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vivysub_utils/entities.dart';
import 'package:vivysub_utils/types.dart';
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

  test('subtitle editor comments', () {
    final editor = SubtitleEditor(parser: assParser, onChange: print);

    Map comments = editor.getComments();

    final firstKey = comments.keys.elementAt(0);
    var firstItem = comments[firstKey];

    var updatedSub = SubComment(
      initial: firstItem,
      message: 'New comment',
    );

    editor.update(
      type: ActionType.comments,
      id: firstKey,
      value: updatedSub,
    );

    expect(
      jsonEncode(
        editor.getComment(firstKey),
      ),
      jsonEncode(updatedSub.export()),
    );

    editor.undo();

    expect(
      jsonEncode(
        editor.getComment(firstKey),
      ),
      jsonEncode(firstItem),
    );

    editor.redo();

    expect(
      jsonEncode(
        editor.getComment(firstKey),
      ),
      jsonEncode(updatedSub.export()),
    );

    editor.remove(type: ActionType.comments, id: firstKey);

    expect(
      editor.getComment(firstKey),
      null,
    );

    editor.undo();

    expect(
      jsonEncode(
        editor.getComment(firstKey),
      ),
      '{"type":"comment","value":"New comment"}',
    );
  });
}
