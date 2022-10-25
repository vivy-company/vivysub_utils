# How to use SubtitleEditor

This class provide functionality to edit your parsed .ass subtitle file.

```dart
final content = await File('test.ass').readAsString();
final assParser = AssParser(content: content)

final editor = SubtitleEditor(
  parser: assParser,
  onChange: (String value) {
    // will be triggered if there're changes, returns stringified content for saving to a file
  },
);


final dialogs = editor.getDialogs();
final dialogId = metadata.keys.elementAt(1);
final existingDialog = dialogs[dialogId];

final dialog = SubDialog(
  initial: existingDialog,
  text: 'Hey, Vivy!',
);

editor.update(
  type: ActionType.dialog,
  id: dialogId,
  value: dialog,
);

editor.undo();
editor.redo();

final Entity selectedDialog = editor.getDialog(dialogId);

print(jsonEncode(selectedDialog));
```
