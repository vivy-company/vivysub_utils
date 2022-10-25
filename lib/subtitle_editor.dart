import 'dart:collection';

import 'package:undo/undo.dart';
import 'package:uuid/uuid.dart';
import 'package:vivysub_utils/ass_parser.dart';

enum ActionType {
  style,
  dialog,
  metadata,
  comments,
}

enum ActionStackType {
  add,
  update,
  remove,
}

class Action {
  late ActionType type;
  late dynamic value;
  late String? id;

  Action({required this.type, this.value, this.id});

  Map toJson() {
    return {
      'type': type,
      'value': value,
      'id': id,
    };
  }
}

class ActionStack {
  late ActionStackType type;
  late Action action;

  ActionStack({required this.type, required this.action});

  Map toJson() {
    return {
      'type': type,
      'action': action,
    };
  }
}

class Entity {
  late dynamic value;

  Entity({required this.value});

  Map toJson() {
    return value;
  }
}

class SubtitleEditor {
  final Map _state = {};
  final ChangeStack _history = ChangeStack();
  final ListQueue<ActionStack> _actionsStack = ListQueue();
  final int maxConcurrentTasks = 5;

  int runningTasks = 0;

  late Function(String subtitle) _onChange;

  SubtitleEditor({required AssParser parser, required onChange}) {
    _onChange = onChange;

    _objectify(ActionType.dialog, parser.getDialogs());
    _objectify(ActionType.metadata, parser.getMetadata());
    _objectify(ActionType.comments, parser.getComments());
    _objectify(ActionType.style, parser.getSections());
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

  stack() {
    return _actionsStack;
  }

  add({
    required ActionType type,
    required dynamic value,
  }) {
    _history.add(
      Change(
        _state,
        () {
          _actionsStack.add(
            ActionStack(
              type: ActionStackType.add,
              action: Action(type: type, value: value),
            ),
          );
        },
        (val) {
          // undo
        },
      ),
    );

    _startExecution();
  }

  update({
    required ActionType type,
    required dynamic value,
    required String id,
  }) {
    _history.add(
      Change(
        _state,
        () {
          _actionsStack.add(
            ActionStack(
              type: ActionStackType.update,
              action: Action(
                type: type,
                value: value,
                id: id,
              ),
            ),
          );
        },
        (val) {
          // undo
        },
      ),
    );

    _startExecution();
  }

  remove({required ActionType type, required String id}) {
    _history.add(
      Change(
        _state,
        () {
          _actionsStack.add(
            ActionStack(
              type: ActionStackType.remove,
              action: Action(
                type: type,
                id: id,
              ),
            ),
          );
        },
        (val) {
          // undo
        },
      ),
    );

    _startExecution();
  }

  getDialogs() {
    return _state[ActionType.dialog];
  }

  getStyles() {
    return _state[ActionType.style];
  }

  getComments() {
    return _state[ActionType.comments];
  }

  getMetadata() {
    return _state[ActionType.metadata];
  }

  getState() {
    return _state;
  }

  _export() {
    return 'test';
  }

  _actionExecutor(ActionStack action) {}

  _objectify(ActionType type, List section) {
    var uuid = const Uuid();

    for (var entity in section) {
      final id = uuid.v4();
      if (!_state.containsKey(type)) {
        _state[type] = {};
      }

      _state[type][id] = Entity(value: entity);
    }
  }

  void _startExecution() async {
    if (runningTasks == maxConcurrentTasks || _actionsStack.isEmpty) {
      return;
    }

    while (_actionsStack.isNotEmpty && runningTasks < maxConcurrentTasks) {
      runningTasks++;

      await _actionExecutor(_actionsStack.removeFirst());

      _onChange(_export());

      runningTasks--;
    }
  }
}
