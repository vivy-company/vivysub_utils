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
    // if (value is Map) {
    //   print('Map');
    //   print(value);
    // }

    return value;
  }
}

abstract class BaseEntity {
  Entity export() {
    return Entity(value: '');
  }
}
