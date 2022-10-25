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
  final dynamic value;

  const Entity({required this.value});

  clone() {
    return Entity(value: toJson());
  }

  Map toJson() {
    return Map.from(value);
  }
}

abstract class BaseEntity {
  Entity export() {
    return const Entity(value: '');
  }
}
