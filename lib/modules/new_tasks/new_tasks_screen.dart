import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components/shared/bloc/cubit.dart';
import 'package:todo/components/shared/bloc/states.dart';
import 'package:todo/components/shared/constants.dart';
import 'package:todo/components/shared/shared_components.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        archivedIcon = Icons.archive_rounded;
        archivedText = 'Archive'.toUpperCase();
        checkDoneIcon = Icons.check_box_outline_blank;
        if (newTasks.isEmpty) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: double.infinity,
            width: double.infinity,
            child: const Center(
              child: Text(
                "No Tasks",
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
              return defaultTasks(newTasks[index], context);
            },
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
            itemCount: newTasks.length,
          );
        }
      },
    );
  }
}
