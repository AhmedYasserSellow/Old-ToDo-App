import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/components/shared/bloc/cubit.dart';
import 'package:todo/components/shared/bloc/states.dart';
import 'package:todo/components/shared/shared_components.dart';

// ignore: must_be_immutable
class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  TextEditingController datecontroller = TextEditingController();

  int finalyear = DateTime.now().year + 25;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsetDataBaseState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        if (cubit.isBottomSheetShown == true) {
          cubit.addIcon = Icons.arrow_circle_down_rounded;
          cubit.addText = "Close";
        } else {
          cubit.addIcon = Icons.add_circle_outline_rounded;
          cubit.addText = "Add";
        }

        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              leading: Container(),
              title: const Text("ToDo App"),
            ),
            body: cubit.isBottomSheetShown == true
                ? GestureDetector(
                    onTap: () {
                      cubit.changeSceensIndex(cubit.screensIndex);
                      Navigator.pop(context);
                    },
                    child: cubit.screens[cubit.screensIndex],
                  )
                : cubit.screens[cubit.screensIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: cubit.isLightMode ? Colors.white : Colors.black,
              iconSize: 27.5,
              showUnselectedLabels: false,
              currentIndex: AppCubit.get(context).bottomNavCurrentIndex,
              onTap: (index) {
                if (index == 4) {
                  index = cubit.screensIndex;
                  cubit.themechanger();
                } else if (index == 0 || index == 1) {
                  cubit.changeBottomNavIndex(index);
                  cubit.changeSceensIndex(index);
                } else if (index == 2) {
                  if (cubit.isBottomSheetShown == true) {
                    cubit.bottomSheetStateChanger(
                      icon: Icons.add,
                      isShown: false,
                    );
                    Navigator.pop(context);
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(elevation: 40.0, (context) {
                          return Container(
                            color: cubit.isLightMode
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "title must not be empty";
                                        }
                                        return null;
                                      },
                                      onTap: () {},
                                      label: "Task Title",
                                      controller: titleController,
                                      type: TextInputType.text,
                                      prefix: Icons.title),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  defaultFormField(
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "time must not be empty";
                                        }
                                        return null;
                                      },
                                      controller: timeController,
                                      type: TextInputType.none,
                                      label: "Task Time",
                                      prefix: Icons.watch_later_outlined,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          if (value == null) {
                                            timeController.clear();
                                          } else {
                                            timeController.text =
                                                value.format(context);
                                          }
                                        });
                                      }),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  defaultFormField(
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return "date must not be empty";
                                        }
                                        return null;
                                      },
                                      controller: datecontroller,
                                      type: TextInputType.none,
                                      label: "Task Date",
                                      prefix: Icons.calendar_month,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.utc(
                                              finalyear,
                                              DateTime.now().month,
                                              DateTime.now().day),
                                        ).then((value) {
                                          if (value == null) {
                                            datecontroller.clear();
                                          } else {
                                            datecontroller.text =
                                                DateFormat.yMMMd()
                                                    .format(value);
                                          }
                                        });
                                      }),
                                ],
                              ),
                            ),
                          );
                        })
                        .closed
                        .then((value) {
                          cubit.bottomSheetStateChanger(
                            icon: Icons.edit,
                            isShown: false,
                          );
                        });
                    cubit.bottomSheetStateChanger(
                      icon: Icons.add,
                      isShown: true,
                    );
                  }
                } else if (index == 3) {
                  cubit.changeBottomNavIndex(index);
                  cubit.changeSceensIndex(2);
                }
              },
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Recent",
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(cubit.addIcon),
                  label: cubit.addText,
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
                BottomNavigationBarItem(
                    icon: Icon(cubit.themeIcon), label: cubit.themeText),
              ],
            ),
            floatingActionButton: cubit.isBottomSheetShown == true
                ? FloatingActionButton(
                    onPressed: () {
                      if (cubit.isBottomSheetShown == true) {
                        if (formKey.currentState!.validate()) {
                          cubit.insertToDB(
                            tittle: titleController.text,
                            time: timeController.text,
                            date: datecontroller.text,
                          );
                          titleController.clear();
                          timeController.clear();
                          datecontroller.clear();
                        }
                      }
                    },
                    child: Icon(cubit.fabIcon),
                  )
                : null);
      },
    );
  }
}
