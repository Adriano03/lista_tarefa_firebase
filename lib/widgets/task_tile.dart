import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/screens/edit_task_screen.dart';
import 'package:lista_tarefas/widgets/popup_menu.dart';

import '../blocs/bloc_exports.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({
    super.key,
    required this.task,
  });

  void _removeOrDeleteTask(BuildContext context, Task task) {
    if (task.isDeleted!) {
      // Se marcado (isDeleted == true) é deletado permanentemente da lixeira de reciclagem;
      context.read<TasksBloc>().add(DeleteTask(task: task));
    } else {
      // Se não estiver marcado (isDeleted == false) é adicionado a lixeira;
      context.read<TasksBloc>().add(RemoveTask(task: task));
    }
  }

  void _likeOrDislike(BuildContext context, Task task) {
    context.read<TasksBloc>().add(MarkFavoriteOrUnfavoriteTask(task: task));

    context.read<TasksBloc>().add(GetAllTasks());
  }

  void _editTask(BuildContext context) {
    Navigator.pop(context);

    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditTaskScreen(oldTask: task),
        ),
      ),
    );
  }

  void _restoreTask(BuildContext context) {
    context.read<TasksBloc>().add(RestoreTask(task: task));
    context.read<TasksBloc>().add(GetAllTasks());
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd/MM/yyyy - HH:mm:ss').format(task.date);

    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                task.isFavorite == false
                    ? const Icon(Icons.favorite_border)
                    : const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          decoration:
                              task.isDone! ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(formattedDate),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: task.isDone,
                onChanged: task.isDeleted == false
                    ? (_) {
                        context.read<TasksBloc>().add(UpdateTask(task: task));
                        context.read<TasksBloc>().add(GetAllTasks());
                      }
                    : null,
              ),
              PopupMenu(
                task: task,
                cancelOrDeleteCallBack: () {
                  _removeOrDeleteTask(context, task);
                  context.read<TasksBloc>().add(GetAllTasks());
                },
                likeOrDislikeCallBack: () => _likeOrDislike(context, task),
                editTaskCallback: () => _editTask(context),
                restoreTaskCallback: () => _restoreTask(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
