import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/task.dart';

import '../blocs/bloc_exports.dart';

class EditTaskScreen extends StatelessWidget {
  final Task oldTask;

  const EditTaskScreen({
    super.key,
    required this.oldTask,
  });

  static const id = 'edit_tasks_screen';

  @override
  Widget build(BuildContext context) {
    // Passar os parâmetro para a tela já carregar com os itens para editar;
    final titleController = TextEditingController(text: oldTask.title);
    final descriptionController =
        TextEditingController(text: oldTask.description);
    final formKey = GlobalKey<FormState>();

    void submit() {
      if (!formKey.currentState!.validate()) return;
      var editedtask = Task(
        id: oldTask.id,
        title: titleController.text,
        description: descriptionController.text,
        isFavorite: oldTask.isFavorite,
        isDone: false,
        date: DateTime.now(),
      );
      context
          .read<TasksBloc>()
          .add(EditTask(newTask: editedtask));
      context.read<TasksBloc>().add(GetAllTasks());
      Navigator.pop(context);
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Text('Editar Tarefa', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 25),
            TextFormField(
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              autofocus: true,
              decoration: const InputDecoration(
                label: Text('Título'),
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
                label: Text('Descrição'),
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
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
