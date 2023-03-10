import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lista_tarefas/screens/login_screen.dart';
import 'package:lista_tarefas/screens/recycle_bin.dart';
import 'package:lista_tarefas/screens/tabs_screen.dart';

import '../blocs/bloc_exports.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final GetStorage getStorage = GetStorage();

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              color: Colors.grey,
              child: const Text(
                'Tarefas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                final pTask = state.pendingTasks.length;
                final cTask = state.completedTasks.length;
                return GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(TabsScreen.id),
                  child: ListTile(
                    leading: const Icon(Icons.folder_special),
                    title: const Text('Minhas Tarefas'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pending_actions, size: 16),
                        const SizedBox(width: 2),
                        Text('$pTask'),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text('|'),
                        ),
                        const Icon(Icons.check_box_outlined, size: 16),
                        const SizedBox(width: 2),
                        Text('$cTask'),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(thickness: 0.8),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(RecycleBin.id),
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Lixeira'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.delete_sweep_outlined, size: 20),
                        const SizedBox(width: 2),
                        Text('${state.removedTasks.length}'),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(thickness: 0.8),
            ListTile(
              onTap: () {
                // Remover usuário logado;
                getStorage.remove('token');
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
            ),
            const Divider(thickness: 0.8),
            BlocBuilder<SwitchBloc, SwitchState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        state.switchValue
                            ? 'Ativar Modo Claro:'
                            : 'Ativar Modo Escuro:',
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    Switch(
                      value: state.switchValue,
                      onChanged: (newValue) {
                        newValue
                            ? context.read<SwitchBloc>().add(SwitchOnEvent())
                            : context.read<SwitchBloc>().add(SwitchOffEvent());
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
