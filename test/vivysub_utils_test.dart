import 'dart:convert';
import 'dart:math';

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

  test(
    'subtitle editor comments',
    () {
      final editor = SubtitleEditor(
        parser: assParser,
        onChange: (String value) {},
      );
      Map comments = editor.getComments();
      final firstKey = comments.keys.elementAt(0);
      final Entity firstItem = comments[firstKey]!;

      final sub = SubComment(
        initial: firstItem,
        message: 'New comment',
      );

      final first = firstItem.clone();

      editor.update(
        type: ActionType.comments,
        id: firstKey,
        value: sub,
      );

      expect(
        jsonEncode(
          editor.getComment(firstKey),
        ),
        jsonEncode(sub.export()),
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getComment(firstKey),
        ),
        jsonEncode(first),
      );

      editor.redo();

      expect(
        jsonEncode(
          editor.getComment(firstKey),
        ),
        jsonEncode(sub.export()),
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
        jsonEncode(sub.export()),
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getComment(firstKey),
        ),
        jsonEncode(first),
      );
    },
  );
  test(
    'subtitle editor metadata',
    () {
      final editor = SubtitleEditor(
        parser: assParser,
        onChange: (String value) {},
      );
      Map metadata = editor.getMetadata();

      final firstKey = metadata.keys.first;
      final firstItem = metadata[firstKey];

      final meta = SubMetadata(
        initial: firstItem,
        key: 'Test',
        value: 'Test value',
      );

      final Entity first = firstItem.clone();

      editor.update(
        type: ActionType.metadata,
        id: firstKey,
        value: meta,
      );

      expect(
        jsonEncode(
          editor.getMetadataKey(firstKey),
        ),
        jsonEncode(meta.export()),
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getMetadataKey(firstKey),
        ),
        jsonEncode(first),
      );

      editor.redo();

      expect(
        jsonEncode(
          editor.getMetadataKey(firstKey),
        ),
        jsonEncode(meta.export()),
      );

      editor.remove(type: ActionType.metadata, id: firstKey);

      expect(
        editor.getMetadataKey(firstKey),
        null,
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getMetadataKey(firstKey),
        ),
        jsonEncode(meta.export()),
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getMetadataKey(firstKey),
        ),
        jsonEncode(first),
      );

      editor.history().clearHistory();
    },
  );

  test(
    'subtitle editor style',
    () {
      final editor = SubtitleEditor(
        parser: assParser,
        onChange: (String value) {},
      );
      Map metadata = editor.getStyles();
      final firstKey = metadata.keys.firstWhere((element) {
        final s = metadata[element].value['value'];
        if (s is Map) {
          return s['Name'] == 'DefaultVCD';
        }

        return false;
      });

      final firstItem = metadata[firstKey];
      final Entity first = firstItem.clone();

      final style = SubStyle(
        initial: firstItem,
        name: 'Changed style name',
      );

      editor.update(
        type: ActionType.style,
        id: firstKey,
        value: style,
      );

      expect(
        jsonEncode(
          editor.getStyle(firstKey),
        ),
        jsonEncode(style.export()),
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getStyle(firstKey),
        ),
        jsonEncode(first),
      );

      editor.redo();

      expect(
        jsonEncode(
          editor.getStyle(firstKey),
        ),
        jsonEncode(style.export()),
      );

      editor.remove(type: ActionType.style, id: firstKey);

      expect(
        editor.getStyle(firstKey),
        null,
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getStyle(firstKey),
        ),
        jsonEncode(style.export()),
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getStyle(firstKey),
        ),
        jsonEncode(first),
      );
    },
  );

  test(
    'subtitle editor dialogs',
    () {
      final editor = SubtitleEditor(
        parser: assParser,
        onChange: (String value) {},
      );
      Map dialogs = editor.getDialogs();

      final firstKey = dialogs.keys.firstWhere((element) {
        final s = dialogs[element].value['value'];

        if (s is Map) {
          return true;
        }

        return false;
      });

      final firstItem = dialogs[firstKey];

      final Entity first = firstItem.clone();

      final dialog = SubDialog(
        initial: firstItem,
        text: 'Вітаю Віві!',
      );

      editor.update(
        type: ActionType.dialog,
        id: firstKey,
        value: dialog,
      );

      expect(
        jsonEncode(
          editor.getDialog(firstKey),
        ),
        jsonEncode(dialog.export()),
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getDialog(firstKey),
        ),
        jsonEncode(first),
      );

      editor.redo();

      expect(
        jsonEncode(
          editor.getDialog(firstKey),
        ),
        jsonEncode(dialog.export()),
      );

      editor.remove(type: ActionType.dialog, id: firstKey);

      expect(
        editor.getDialog(firstKey),
        null,
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getDialog(firstKey),
        ),
        jsonEncode(dialog.export()),
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getDialog(firstKey),
        ),
        jsonEncode(first),
      );
    },
  );
}
