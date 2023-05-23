import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components/shared/bloc/cubit.dart';
import 'package:todo/components/shared/bloc/states.dart';
import 'package:todo/components/shared/constants.dart';
import 'package:todo/components/shared/shared_components.dart';

class DoneTasksScreen extends StatefulWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  State<DoneTasksScreen> createState() => _DoneTasksScreenState();
}

class _DoneTasksScreenState extends State<DoneTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        archivedIcon = Icons.archive_rounded;
        archivedText = 'Archive'.toUpperCase();
        checkDoneIcon = Icons.check_box_outlined;
        if (doneTasks.isEmpty) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: double.infinity,
            width: double.infinity,
            child: const Center(
              child: Text(
                "No Done Tasks",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          return ListView.separated(
            itemBuilder: (context, index) {
              return defaultTasks(doneTasks[index], context);
            },
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
            itemCount: doneTasks.length,
          );
        }
      },
    );
  }
}
