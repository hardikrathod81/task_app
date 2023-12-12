// ignore_for_file: must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/src/task_view.dart';
import 'package:task_app/src/widget/task_widget.dart';
import 'package:task_app/utility/colors.dart';
import 'package:task_app/utility/constant.dart';
import 'package:task_app/utility/strings.dart';

///
import '../../main.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  /// Checking Done Tasks
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleated) {
        i++;
      }
    }
    return i;
  }

  /// Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenTask(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          /// Sort Task List
          tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));

          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              floatingActionButton: const FAB(),
              body: Column(
                children: [
                  const MyAppBar(),
                  _buildBody(
                    tasks,
                    base,
                    textTheme,
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Main Body
  Column _buildBody(
    List<Task> tasks,
    BaseWidget base,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Top Section Of Home page : Text, Progrss Indicator
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// CircularProgressIndicator
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  valueColor:
                      const AlwaysStoppedAnimation(MyColors.primerColor),
                  backgroundColor: Colors.grey,
                  value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                ),
              ),
            ),

            /// Texts
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(MyString.mainTitle, style: textTheme.headlineMedium),
                  Text("${checkDoneTask(tasks)} of ${tasks.length} task",
                      style: textTheme.headlineMedium),
                ],
              ),
            )
          ],
        ),

        /// Divider
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Divider(
            thickness: 2,
            indent: 16,
            endIndent: 16,
          ),
        ),

        /// Bottom ListView : Tasks
        SingleChildScrollView(
          child: tasks.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: tasks.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var task = tasks[index];

                          return Dismissible(
                            direction: DismissDirection.horizontal,
                            background: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(MyString.deletedTask,
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ))
                              ],
                            ),
                            onDismissed: (direction) {
                              base.dataStore.dalateTask(task: task);
                            },
                            key: Key(task.id),
                            child: TaskWidget(
                              task: tasks[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )

              /// if All Tasks Done Show this Widgets
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Lottie

                    /// Bottom Texts
                    FadeInDown(
                      from: 30,
                      child: const Text(MyString.doneAllTask),
                    ),
                  ],
                ),
        )
      ],
    );
  }
}

/// My Drawer Slider
class MySlider extends StatelessWidget {
  MySlider({
    super.key,
  });

  /// Icons
  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: MyColors.primergrident,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
          ),
          const SizedBox(
            height: 8,
          ),
          Text("AmirHossein Bayat", style: textTheme.displayMedium),
          Text("junior flutter dev", style: textTheme.displaySmall),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            width: double.infinity,
            height: 300,
            child: SizedBox(
              child: ListView.builder(
                  itemCount: icons.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, i) {
                    return InkWell(
                      // ignore: avoid_print
                      onTap: () => print("$i Selected"),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                            leading: Icon(
                              icons[i],
                              color: Colors.white,
                              size: 30,
                            ),
                            title: Text(
                              texts[i],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            )),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

/// My App Bar
class MyAppBar extends StatefulWidget {
  const MyAppBar({
    super.key,
    // required this.drawerKey,
  });
  // GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  Size get preferredSize => const Size.fromHeight(100);
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  // @override
  // void initState() {
  //   super.initState();

  //   controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 1000),
  //   );
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  // /// toggle for drawer and icon aniamtion
  // void toggle() {
  //   setState(() {
  //     isDrawerOpen = !isDrawerOpen;
  //     if (isDrawerOpen) {
  //       controller.forward();
  //       widget.drawerKey.currentState!.openSlider();
  //     } else {
  //       controller.reverse();
  //       widget.drawerKey.currentState!.closeSlider();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Animated Icon - Menu & Close
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: IconButton(
          //       splashColor: Colors.transparent,
          //       highlightColor: Colors.transparent,
          //       icon: AnimatedIcon(
          //         icon: AnimatedIcons.menu_close,
          //         progress: controller,
          //         size: 30,
          //       ),
          //       onPressed: toggle),
          // ),

          /// Delete Icon
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                base.isEmpty ? warningNoTask(context) : deleteAllTask(context);
              },
              child: const Icon(
                CupertinoIcons.trash,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating Action Button
class FAB extends StatelessWidget {
  const FAB({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TaskView(
              taskControllerForSubtitle: null,
              taskControllerForTitle: null,
              task: null,
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 10,
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.14,
          height: MediaQuery.sizeOf(context).height * 0.06,
          decoration: BoxDecoration(
            color: MyColors.primerColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
              child: Icon(
            Icons.add,
            color: Colors.white,
          )),
        ),
      ),
    );
  }
}
