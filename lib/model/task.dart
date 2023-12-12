// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String subtitle;
  @HiveField(3)
  DateTime createdAtDate;
  @HiveField(4)
  DateTime createdAtTime;
  @HiveField(5)
  bool isCompleated;
  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdAtDate,
    required this.createdAtTime,
    required this.isCompleated,
  });

  factory Task.create(
          {required String? title,
          required String? subtitle,
          DateTime? createdAtTime,
          DateTime? createdAtDate}) =>
      Task(
          id: const Uuid().v1(),
          title: title ?? '',
          subtitle: subtitle ?? '',
          createdAtDate: createdAtDate ?? DateTime.now(),
          createdAtTime: createdAtTime ?? DateTime.now(),
          isCompleated: false);
}
