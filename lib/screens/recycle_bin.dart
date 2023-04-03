import 'package:flutter/material.dart';
import 'package:lista_tarefas/screens/my_drawer.dart';
import 'package:lista_tarefas/services/visibility_widget.dart';
import 'package:lista_tarefas/widgets/tasks_list.dart';

import '../blocs/bloc_exports.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({super.key});

  static const id = 'recycle_bin_screen';

  _deleteAllTasksRemoved(BuildContext context) {
    context.read<TasksBloc>().add(DeleteAllTasks());
    context.read<TasksBloc>().add(GetAllTasks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Lixeira de Reciclagem'),
            actions: [
              state.removedTasks.isNotEmpty
                  ? PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: TextButton.icon(
                              onPressed: null,
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              label: const Text('Excluir Todas as Tarefas')),
                          onTap: () => _deleteAllTasksRemoved(context),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          drawer: const MyDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Chip(
                  label: Text(
                    'Tarefas Removidas: ${state.removedTasks.length}',
                  ),
                ),
              ),
              VisibilityWidget(
                visibility: state.removedTasks.isEmpty,
                text: 'Removidas',
                icon: Icons.cancel_outlined,
                iconColor: Theme.of(context).colorScheme.error,
              ),
              TasksList(taskList: state.removedTasks),
            ],
          ),
        );
      },
    );
  }
}
