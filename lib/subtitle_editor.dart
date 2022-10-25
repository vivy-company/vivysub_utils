import 'dart:collection';

import 'package:undo/undo.dart';
import 'package:uuid/uuid.dart';
import 'package:vivysub_utils/types.dart';
import 'package:vivysub_utils/vivysub_utils.dart';

var uuid = const Uuid();

class SubtitleEditor {
  final Map _state = {};
  final ChangeStack _history = ChangeStack(limit: 500);
  final ListQueue<ActionStack> _actionsStack = ListQueue();
  final int maxConcurrentTasks = 5;

  int runningTasks = 0;

  late Function(String subtitle)? _onChange;

  SubtitleEditor({required AssParser parser, onChange}) {
    _onChange = onChange;

    _objectify(ActionType.dialog, parser.getDialogs());
    _objectify(ActionType.metadata, parser.getMetadata());
    _objectify(ActionType.comments, parser.getComments());
    _objectify(ActionType.style, parser.getStyles());
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
          _startExecution();
        },
        (val) {
          // undo
        },
      ),
    );
  }

  update({
    required ActionType type,
    required dynamic value,
    required String id,
  }) {
    final Entity oldValue = _state[type][id].clone();

    _history.add(
      Change(
        oldValue,
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

          _startExecution();
        },
        (val) {
          _state[type][id] = val;
        },
      ),
    );
  }

  remove({required ActionType type, required String id}) {
    final Entity oldValue = _state[type][id].clone();

    _history.add(
      Change(
        oldValue,
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

          _startExecution();
        },
        (val) {
          _state[type][id] = val;
        },
      ),
    );
  }

  getDialogs() {
    return _state[ActionType.dialog];
  }

  getDialog(String id) {
    return _state[ActionType.dialog][id];
  }

  getStyles() {
    return _state[ActionType.style];
  }

  getStyle(String id) {
    return _state[ActionType.style][id];
  }

  getComments() {
    return _state[ActionType.comments];
  }

  getComment(String id) {
    return _state[ActionType.comments][id];
  }

  getMetadata() {
    return _state[ActionType.metadata];
  }

  getMetadataKey(String id) {
    return _state[ActionType.metadata][id];
  }

  getState() {
    return _state;
  }

  export() {
    return _export();
  }

  _export() {
    final Section metadata = _sectionize(
      '[Script Info]',
      Map.from(
        {
          ..._state[ActionType.comments],
          ..._state[ActionType.metadata],
        },
      ),
    );

    final styles = _sectionize(
      '[V4 Styles]',
      Map.from(
        _state[ActionType.style],
      ),
    );

    final dialogs = _sectionize(
      '[Events]',
      Map.from(
        _state[ActionType.dialog],
      ),
    );

    return AssStringify(sections: [metadata, styles, dialogs]).export();
  }

  _actionExecutor(ActionStack action) {
    final id = action.action.id;
    final type = action.action.type;
    BaseEntity? value = action.action.value;

    switch (action.type) {
      case ActionStackType.update:
        _state[type][id] = value!.export();

        break;
      case ActionStackType.remove:
        final Map entities = _state[type];
        entities.remove(id);

        break;
      default:
        throw Exception('Action is not supported');
    }
  }

  _objectify(ActionType type, List section) {
    for (var entity in section) {
      final id = uuid.v4();
      if (!_state.containsKey(type)) {
        _state[type] = {};
      }

      if (entity is Entity) {
        _state[type][id] = entity.clone();
      } else {
        _state[type][id] = Entity(value: entity).clone();
      }
    }
  }

  _sectionize(String name, Map<String, Entity> entities) {
    final List<Entity> result = entities.entries
        .map(
          (entry) => entry.value,
        )
        .toList();

    var section = Section(body: result, name: name);

    return section;
  }

  void _startExecution() async {
    if (runningTasks == maxConcurrentTasks || _actionsStack.isEmpty) {
      return;
    }

    while (_actionsStack.isNotEmpty && runningTasks < maxConcurrentTasks) {
      runningTasks++;

      await _actionExecutor(_actionsStack.removeFirst());

      if (_onChange != null) {
        _onChange!(_export());
      }

      runningTasks--;
    }
  }
}
