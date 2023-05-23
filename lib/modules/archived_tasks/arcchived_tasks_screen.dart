import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components/shared/bloc/cubit.dart';
import 'package:todo/components/shared/bloc/states.dart';
import 'package:todo/components/shared/constants.dart';
import 'package:todo/components/shared/shared_components.dart';

class ArchivedTasksScreen extends StatefulWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  State<ArchivedTasksScreen> createState() => _ArchivedTasksScreenState();
}

class _ArchivedTasksScreenState extends State<ArchivedTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        archivedIcon = Icons.unarchive_rounded;
        archivedText = 'Unarchive'.toUpperCase();
        if (archivedTasks.isEmpty) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: double.infinity,
            width: double.infinity,
            child: const Center(
              child: Text(
                "No Archived Tasks",
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
              return defaultTasks(archivedTasks[index], context);
            },
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
            itemCount: archivedTasks.length,
          );
        }
      },
    );
  }
}
