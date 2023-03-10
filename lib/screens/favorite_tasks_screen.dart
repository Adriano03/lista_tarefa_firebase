import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/services/visibility_widget.dart';
import 'package:lista_tarefas/widgets/tasks_list.dart';

import '../blocs/bloc_exports.dart';

class FavoriteTasksScreen extends StatelessWidget {
  const FavoriteTasksScreen({super.key});

  static const id = 'favorite_tasks_screen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> tasksList = state.favoriteTasks;
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Chip(
                  label: Text(
                    'Tarefas Favoritas: ${tasksList.length}',
                  ),
                ),
              ),
              VisibilityWidget(
                visibility: state.favoriteTasks.isEmpty,
                text: 'Favoritas',
                icon: Icons.favorite,
                iconColor: Theme.of(context).colorScheme.error
              ),
              TasksList(taskList: tasksList),
            ],
          ),
        );
      },
    );
  }
}
