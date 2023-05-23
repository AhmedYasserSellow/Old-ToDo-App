import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/components/shared/bloc/states.dart';
import 'package:todo/components/shared/constants.dart';
import 'package:todo/modules/archived_tasks/arcchived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  Brightness brightness = Brightness.light;

  late Database todoDatabase;

  int bottomNavCurrentIndex = 0;
  int screensIndex = 0;

  String addText = "Add";
  String themeText = "Light Mode";

  bool isLightMode = true;
  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;
  IconData themeIcon = Icons.light_mode_outlined;
  IconData addIcon = Icons.add_circle_outline_rounded;

  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  // DataBase Methods

//Create Database
  void createDB() async {
    todoDatabase = await openDatabase(
      "todo.db",
      version: 1,
      onCreate: (db, version) {
        db
            .execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY, tittle TEXT, date TEXT, time TEXT, status TEXT)")
            .then(
              (value) {},
            )
            .catchError((error) {});
      },
      onOpen: (db) {
        getFromDB(db).then((value) {
          emit(AppGetDataBase());
        });
      },
    );
    emit(AppCreateDateBaseState());
  }

//Insert To Database
  insertToDB({
    required String tittle,
    required String time,
    required String date,
  }) async {
    await todoDatabase.transaction((txn) async {
      txn
          .rawInsert(
              "INSERT INTO tasks(tittle, date, time ,status) VALUES ('$tittle', '$date', '$time', 'new')")
          .then((value) {
        emit(AppInsetDataBaseState());
        getFromDB(todoDatabase).then((value) {
          emit(AppGetDataBase());
        });
      }).catchError((error) {});
    });
  }

//Get From DataBase
  Future<List<Map>> getFromDB(todoDatabase) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    List<Map> table = await todoDatabase.rawQuery("SELECT * FROM tasks");
    for (var element in table) {
      if (element['status'] == 'new') {
        newTasks.add(element);
      } else if (element['status'] == 'done') {
        doneTasks.add(element);
      } else {
        archivedTasks.add(element);
      }
    }
    return table;
  }

//UpdateData
  void updateData({
    required String status,
    required int id,
  }) async {
    await todoDatabase
        .rawUpdate("UPDATE tasks SET status = ? WHERE id = ?", [status, '$id']);

    getFromDB(todoDatabase);
    emit(AppUpdateDataBaseState());
  }

//Delete Data
  void deleteData({
    required int id,
  }) async {
    await todoDatabase.rawDelete("DELETE FROM tasks  WHERE id = ?", ['$id']);

    getFromDB(todoDatabase);
    emit(AppDeleteDataBaseState());
  }

//BottomSheet State
  void bottomSheetStateChanger({
    required IconData icon,
    required bool isShown,
  }) {
    fabIcon = icon;
    isBottomSheetShown = isShown;
    emit(AppChangeBottomSheetState());
  }

//Theme Changer
  void themechanger() {
    if (isLightMode) {
      isLightMode = !isLightMode;
      themeIcon = Icons.dark_mode_outlined;
      brightness = Brightness.dark;
      themeText = "Dark Mode";
    } else {
      isLightMode = !isLightMode;
      themeIcon = Icons.light_mode_outlined;
      brightness = Brightness.light;
      themeText = "Light Mode";
    }
    emit(AppThemeChanger());
  }

// BottomNavigatorBarState
  void changeBottomNavIndex(int index) {
    bottomNavCurrentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

//Screens State
  void changeSceensIndex(int index) {
    screensIndex = index;
    emit(AppChangeScreensState());
  }
}
