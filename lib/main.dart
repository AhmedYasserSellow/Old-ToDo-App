import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components/shared/bloc/states.dart';

import 'package:todo/layout/home_layout.dart';

import 'components/shared/bloc/bloc_observer.dart';
import 'components/shared/bloc/cubit.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit()..createDB(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              theme: ThemeData(
                brightness: AppCubit.get(context).brightness,
              ),
              debugShowCheckedModeBanner: false,
              home: const HomeLayout(),
            );
          },
        ));
  }
}
