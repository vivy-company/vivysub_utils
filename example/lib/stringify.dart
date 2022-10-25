
final content = await File('test.ass').readAsString();
final assParser = AssParser(content: content);

final sections = assParser.getSections();

final subtitles = AssStringify(sections: sections);

final fileContent = subtitles.export();
