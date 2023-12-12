import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/src/task_view.dart';
import 'package:task_app/utility/colors.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key, required this.task});

  final Task task;

  @override
  // ignore: library_private_types_in_public_api
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController taskControllerForTitle = TextEditingController();
  TextEditingController taskControllerForSubtitle = TextEditingController();
  @override
  void initState() {
    super.initState();
    taskControllerForTitle.text = widget.task.title;
    taskControllerForSubtitle.text = widget.task.subtitle;
  }

  @override
  void dispose() {
    taskControllerForTitle.dispose();
    taskControllerForSubtitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (ctx) => TaskView(
              taskControllerForTitle: taskControllerForTitle,
              taskControllerForSubtitle: taskControllerForSubtitle,
              task: widget.task,
            ),
          ),
        );
      },

      /// Main Card
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: widget.task.isCompleated ? Colors.lightBlue : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(0, 4),
                  blurRadius: 10)
            ]),
        child: ListTile(
            leading: GestureDetector(
              onTap: () {
                widget.task.isCompleated = !widget.task.isCompleated;
                widget.task.save();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                decoration: BoxDecoration(
                    color: widget.task.isCompleated
                        ? MyColors.primerColor
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: .8)),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 3),
              child: Text(
                taskControllerForTitle.text,
                style: TextStyle(
                    color: widget.task.isCompleated
                        ? MyColors.primerColor
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    decoration: widget.task.isCompleated
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskControllerForSubtitle.text,
                  style: TextStyle(
                    color: widget.task.isCompleated
                        ? MyColors.primerColor
                        : const Color.fromARGB(255, 164, 164, 164),
                    fontWeight: FontWeight.w300,
                    decoration: widget.task.isCompleated
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      top: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('           hh:mm a')
                              .format(widget.task.createdAtTime),
                          style: TextStyle(
                              fontSize: 14,
                              color: widget.task.isCompleated
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                        Text(
                          DateFormat.yMMMEd().format(widget.task.createdAtDate),
                          style: TextStyle(
                              fontSize: 12,
                              color: widget.task.isCompleated
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
