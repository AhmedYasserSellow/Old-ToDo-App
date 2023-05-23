import 'package:flutter/material.dart';
import 'package:todo/components/shared/bloc/cubit.dart';

import 'constants.dart';

//Text Form Field
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required validate,
  required String label,
  required IconData prefix,
  required onTap,
}) =>
    TextFormField(
      onTap: onTap,
      validator: validate,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        border: const OutlineInputBorder(),
      ),
    );

//Item Builder
Widget defaultTasks(
  Map model,
  context,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 7.0),
    child: Dismissible(
      background: Container(
        color: Colors.green,
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  archivedIcon,
                  size: 30,
                  color: Colors.white,
                ),
                Text(
                  archivedText.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_forever,
                  size: 30,
                  color: Colors.white,
                ),
                Text(
                  "DELETE",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          AppCubit.get(context).deleteData(
            id: model['id'],
          );
        } else {
          if (model['status'] == 'archived') {
            AppCubit.get(context).updateData(status: "new", id: model['id']);
          } else {
            AppCubit.get(context)
                .updateData(status: "archived", id: model['id']);
          }
        }
      },
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
        ),
        child: Row(
          children: [
            // CircleAvatar(
            //   backgroundColor: Colors.blue.withOpacity(0.5),
            //   radius: 40.0,
            //   child: Text(
            //     "${model["time"]}",
            //     style: TextStyle(
            //       color: AppCubit.get(context).isLightMode
            //           ? Colors.black
            //           : Colors.white,
            //     ),
            //   ),
            // ),
            const SizedBox(
              width: 8,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/clock.png"),
                ),
                SizedBox(
                  width: 60,
                  child: Center(
                    child: Text(
                      "${model["time"]}",
                      style: TextStyle(
                        color: AppCubit.get(context).isLightMode
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model["tittle"]}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model["date"]}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(),
            model['status'] == 'archived'
                ? Container()
                : GestureDetector(
                    onLongPress: () {},
                    onTap: () {
                      if (model['status'] == 'done') {
                        AppCubit.get(context)
                            .updateData(status: "new", id: model['id']);
                      } else {
                        AppCubit.get(context)
                            .updateData(status: "done", id: model['id']);
                      }
                    },
                    child: Icon(checkDoneIcon),
                  ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    ),
  );
}
