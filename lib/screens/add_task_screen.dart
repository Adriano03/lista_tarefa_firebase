import 'package:flutter/material.dart';
import 'package:lista_tarefas/blocs/bloc_exports.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/services/guid_gen.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    void submit() {
      if (!formKey.currentState!.validate()) return;
      var task = Task(
        id: GUIDGen.generate(),
        title: titleController.text,
        description: descriptionController.text,
        date: DateTime.now(),
      );
      context.read<TasksBloc>().add(AddTask(task: task));
      Navigator.pop(context);
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Text('Adicionar Tarefa', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 25),
            TextFormField(
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              autofocus: true,
              decoration: const InputDecoration(
                label: Text('Título*'),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Campo título é obrigatório!';
                } else if (value.length < 4) {
                  return 'Campo título mínimo 4 caracteres!';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: descriptionController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              maxLength: 300,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                label: Text('Descrição*'),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Campo descrição é obrigatório!';
                } else if (value.length < 8) {
                  return 'Campo descrição mínimo 8 caracteres!';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: submit,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
