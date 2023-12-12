import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/model/task.dart';

class HiveDB {
  static const boxname = 'taskbox';
  final Box<Task> box = Hive.box<Task>(boxname);

  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  Future<void> dalateTask({required Task task}) async {
    await task.delete();
  }

  ValueListenable<Box<Task>> listenTask() {
    return box.listenable();
  }
}
