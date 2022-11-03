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
      Map styles = editor.getStyles();
      final firstKey = styles.keys.firstWhere((element) {
        final s = styles[element].value['value'];
        if (s is Map) {
          return s['Name'] == 'DefaultVCD';
        }

        return false;
      });

      final firstItem = styles[firstKey];
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

  test(
    'subtitle editor add dialog',
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
        initial: first,
        text: 'Вітаю Віві!',
      );

      editor.add(
        type: ActionType.dialog,
        value: dialog,
        id: dialog.id,
      );

      expect(
        jsonEncode(
          editor.getDialog(dialog.id),
        ),
        jsonEncode(dialog.export()),
      );

      editor.undo();

      expect(
        editor.getDialog(dialog.id),
        null,
      );

      editor.redo();

      expect(
        jsonEncode(
          editor.getDialog(dialog.id),
        ),
        jsonEncode(dialog.export()),
      );

      editor.remove(type: ActionType.dialog, id: dialog.id);

      expect(
        editor.getDialog(dialog.id),
        null,
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getDialog(dialog.id),
        ),
        jsonEncode(dialog.export()),
      );
    },
  );

  test(
    'subtitle editor add comment',
    () {
      final editor = SubtitleEditor(
        parser: assParser,
        onChange: (String value) {},
      );

      Map comments = editor.getComments();

      final firstKey = comments.keys.first;

      final firstItem = comments[firstKey];

      final Entity first = firstItem.clone();

      final comment = SubComment(
        initial: first,
        message: 'Вітаю Віві!',
      );

      editor.add(
        type: ActionType.comments,
        value: comment,
        id: comment.id,
      );

      expect(
        jsonEncode(
          editor.getComment(comment.id),
        ),
        jsonEncode(comment.export()),
      );

      editor.undo();

      expect(
        editor.getComment(comment.id),
        null,
      );

      editor.redo();

      expect(
        jsonEncode(
          editor.getComment(comment.id),
        ),
        jsonEncode(comment.export()),
      );

      editor.remove(type: ActionType.comments, id: comment.id);

      expect(
        editor.getComment(comment.id),
        null,
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getComment(comment.id),
        ),
        jsonEncode(comment.export()),
      );
    },
  );

  test(
    'subtitle editor add metadata',
    () {
      final editor = SubtitleEditor(
        parser: assParser,
        onChange: (String value) {},
      );

      Map metadata = editor.getMetadata();

      final firstKey = metadata.keys.first;

      final firstItem = metadata[firstKey];

      final Entity first = firstItem.clone();

      final metadataEntry =
          SubMetadata(initial: first, key: 'test', value: 'Vivy');

      editor.add(
        type: ActionType.metadata,
        value: metadataEntry,
        id: metadataEntry.id,
      );

      expect(
        jsonEncode(
          editor.getMetadataKey(metadataEntry.id),
        ),
        jsonEncode(metadataEntry.export()),
      );

      editor.undo();

      expect(
        editor.getMetadataKey(metadataEntry.id),
        null,
      );

      editor.redo();

      expect(
        jsonEncode(
          editor.getMetadataKey(metadataEntry.id),
        ),
        jsonEncode(metadataEntry.export()),
      );

      editor.remove(type: ActionType.metadata, id: metadataEntry.id);

      expect(
        editor.getMetadataKey(metadataEntry.id),
        null,
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getMetadataKey(metadataEntry.id),
        ),
        jsonEncode(metadataEntry.export()),
      );
    },
  );

  test(
    'subtitle editor add style',
    () {
      final editor = SubtitleEditor(
        parser: assParser,
        onChange: (String value) {},
      );

      Map styles = editor.getStyles();
      final firstKey = styles.keys.firstWhere((element) {
        final s = styles[element].value['value'];
        if (s is Map) {
          return s['Name'] == 'DefaultVCD';
        }

        return false;
      });

      final firstItem = styles[firstKey];

      final Entity first = firstItem.clone();

      final style = SubStyle(initial: first, name: 'Vivy');

      editor.add(
        type: ActionType.style,
        value: style,
        id: style.id,
      );

      expect(
        jsonEncode(
          editor.getStyle(style.id),
        ),
        jsonEncode(style.export()),
      );

      editor.undo();

      expect(
        editor.getStyle(style.id),
        null,
      );

      editor.redo();

      expect(
        jsonEncode(
          editor.getStyle(style.id),
        ),
        jsonEncode(style.export()),
      );

      editor.remove(type: ActionType.style, id: style.id);

      expect(
        editor.getStyle(style.id),
        null,
      );

      editor.undo();

      expect(
        jsonEncode(
          editor.getStyle(style.id),
        ),
        jsonEncode(style.export()),
      );
    },
  );
}
