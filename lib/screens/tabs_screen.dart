import 'package:flutter/material.dart';
import 'package:lista_tarefas/blocs/bloc_exports.dart';
import 'package:lista_tarefas/screens/add_task_screen.dart';
import 'package:lista_tarefas/screens/completed_tasks_screen.dart';
import 'package:lista_tarefas/screens/favorite_tasks_screen.dart';
import 'package:lista_tarefas/screens/my_drawer.dart';
import 'package:lista_tarefas/screens/pending_tasks_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  static const id = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _pageDetails = [
    {'pageName': const PendingTasksScreen(), 'title': 'Tarefas Pendentes'},
    {'pageName': const CompletedTasksScreen(), 'title': 'Tarefas Completas'},
    {'pageName': const FavoriteTasksScreen(), 'title': 'Tarefas Favoritas'},
  ];

  // Sempre na chamada da página é chamado o método GetAllTasks() para atualizar página;
  @override
  void initState() {
    context.read<TasksBloc>().add(GetAllTasks());
    super.initState();
  }

  int _selectedPageIndex = 0;

  void _addTask(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const AddTaskScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_pageDetails[_selectedPageIndex]['title']),
        actions: [
          IconButton(
            onPressed: () => _addTask(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: _pageDetails[_selectedPageIndex]['pageName'],
      floatingActionButton: _selectedPageIndex == 0
          ? FloatingActionButton(
              onPressed: () => _addTask(context),
              tooltip: 'Adicionar Tarefas',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle_sharp),
            label: 'Tarefas Pendentes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Tarefas Completas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Tarefas Favoritas',
          ),
        ],
      ),
    );
  }
}
