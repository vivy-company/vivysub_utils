final content = await File('test.ass').readAsString();
final assParser = AssParser(content: content);

final metadata = assParser.getMetadata();
final comments = assParser.getComments();
final dialogs = assParser.getDialogs();
final sections = assParser.getSections();
final styles = assParser.getStyles();


final assStringify = AssStringify(sections: sections);
String fileContent = assStringify.export();

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
