// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/utility/colors.dart';
import 'package:task_app/utility/strings.dart';

///
import '../../main.dart';
import '../utility/constant.dart';

// ignore: must_be_immutable
class TaskView extends StatefulWidget {
  TaskView({
    super.key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  });

  TextEditingController? taskControllerForTitle;
  TextEditingController? taskControllerForSubtitle;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  /// Show Selected Time As String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  /// Show Selected Time As DateTime Format
  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdAtTime;
    }
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// If any Task Already exist return TRUE otherWise FALSE
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle?.text == null &&
        widget.taskControllerForSubtitle?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// If any task already exist app will update it otherwise the app will add a new task
  dynamic isTaskAlreadyExistUpdateTask() {
    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        widget.taskControllerForTitle?.text = title;
        widget.taskControllerForSubtitle?.text = subtitle;

        // widget.task?.createdAtDate = date!;
        // widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        nothingEnterOnUpdateTaskMode(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title,
          createdAtTime: time,
          createdAtDate: date,
          subtitle: subtitle,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Delete Selected Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                /// new / update Task Text
                _buildTopText(textTheme),

                /// Middle Two TextFileds, Time And Date Selection Box
                _buildMiddleTextFieldsANDTimeAndDateSelection(
                    context, textTheme),

                /// All Bottom Buttons
                _buildBottomButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// All Bottom Buttons
  Padding _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExistBool()
              ? Container()
              : Container(
                  width: 150,
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.primerColor, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: 150,
                    height: 55,
                    onPressed: () {
                      deleteTask();
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: MyColors.primerColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          MyString.deleteTask,
                          style: TextStyle(
                            color: MyColors.primerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minWidth: 150,
            height: 55,
            onPressed: () {
              isTaskAlreadyExistUpdateTask();
            },
            color: MyColors.primerColor,
            child: Text(
              isTaskAlreadyExistBool()
                  ? MyString.addTaskString
                  : MyString.updateTaskString,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Middle Two TextFileds And Time And Date Selection Box
  Column _buildMiddleTextFieldsANDTimeAndDateSelection(
      BuildContext context, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Add Titile'),

        /// Note TextField
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black)),
            child: Column(
              children: [
                ListTile(
                  title: TextFormField(
                    controller: widget.taskControllerForSubtitle,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counter: Container(),
                      hintText: MyString.addNote,
                    ),
                    onFieldSubmitted: (value) {
                      title = value;
                    },
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const Text(
          'Add Description',
        ),

        /// Title TextField
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black)),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForTitle,
                maxLines: 2,
                cursorHeight: 20,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onFieldSubmitted: (value) {
                  subtitle = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  subtitle = value;
                },
              ),
            ),
          ),
        ),

        /// Time Picker
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child:
                      Text(MyString.timeString, style: textTheme.headlineSmall),
                ),
                Expanded(child: Container()),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 80,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100),
                  child: Center(
                    child: Text(
                      showTime(time),
                      style: textTheme.titleSmall,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        /// Date Picker
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child:
                      Text(MyString.dateString, style: textTheme.headlineSmall),
                ),
                Expanded(child: Container()),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 140,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100),
                  child: Center(
                    child: Text(
                      showDate(date),
                      style: textTheme.titleSmall,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  /// new / update Task Text
  Row _buildTopText(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
              text: isTaskAlreadyExistBool()
                  ? MyString.addNewTask
                  : MyString.updateCurrentTask,
              style: textTheme.titleLarge,
              children: const [
                TextSpan(
                  text: MyString.taskStrnig,
                )
              ]),
        ),
      ],
    );
  }
}
