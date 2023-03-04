import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/services/visibility_widget.dart';
import 'package:lista_tarefas/widgets/tasks_list.dart';

import '../blocs/bloc_exports.dart';

class PendingTasksScreen extends StatelessWidget {
  const PendingTasksScreen({super.key});

  static const id = 'tasks_screen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> tasksList = state.pendingTasks;
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Chip(
                  label: Text(
                    'Tarefas - Pendentes: ${tasksList.length} | Completadas: ${state.completedTasks.length}',
                  ),
                ),
              ),
              VisibilityWidget(
                visibility: state.pendingTasks.isEmpty,
                text: 'Pendentes',
                icon: Icons.pending_actions,
                iconColor: Theme.of(context).colorScheme.primary,
              ),
              TasksList(taskList: tasksList),
            ],
          ),
        );
      },
    );
  }
}
