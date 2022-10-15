import 'package:undo/undo.dart';
import 'package:vivysub_utils/ass_parser.dart';

enum ActionType {
  style,
  dialog,
  metadata,
  comments,
}

class SubtitleEditor {
  AssParser parser;
  late ChangeStack _history;

  SubtitleEditor(
      {required this.parser, required Function(String subtitle) onChange}) {
    _history = ChangeStack();
  }

  undo() {
    _history.undo();
  }

  redo() {
    _history.redo();
  }

  copy(dynamic entries) {}

  cut(dynamic entries) {}

  paste(int position) {}

  history() {
    return _history;
  }

  update({required ActionType type, required dynamic value}) {}
  remove({required ActionType type, required String id}) {}
}
