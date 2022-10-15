# VivySub Utils

Parse and decode .ass/ssa subtitles

```dart
final content = await File('test.ass').readAsString();
final assParser = AssParser(content: content);

final metadata = assParser.getMetadata();
final comments = assParser.getComments();
final dialogs = assParser.getDialogs();
final sections = assParser.getSections();
final sections = assParser.getStyles();


final assStringify = AssStringify(sections: sections);
String fileContent = assStringify.export();

```
