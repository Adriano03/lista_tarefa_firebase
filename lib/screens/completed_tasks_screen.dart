import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/services/visibility_widget.dart';
import 'package:lista_tarefas/widgets/tasks_list.dart';

import '../blocs/bloc_exports.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  static const id = 'completed_task_screen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> tasksList = state.completedTasks;
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Chip(
                  label: Text(
                    'Tarefas - Completadas: ${tasksList.length} | Pendentes: ${state.pendingTasks.length}',
                  ),
                ),
              ),
              VisibilityWidget(
                visibility: state.completedTasks.isEmpty,
                text: 'Concluídas',
                icon: Icons.check_box_outlined,
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
