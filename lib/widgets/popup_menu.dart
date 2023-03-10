import 'package:flutter/material.dart';

import 'package:lista_tarefas/models/task.dart';

class PopupMenu extends StatelessWidget {
  final Task task;
  final VoidCallback cancelOrDeleteCallBack;
  final VoidCallback likeOrDislikeCallBack;
  final VoidCallback editTaskCallback;
  final VoidCallback restoreTaskCallback;

  const PopupMenu({
    Key? key,
    required this.task,
    required this.cancelOrDeleteCallBack,
    required this.likeOrDislikeCallBack,
    required this.editTaskCallback,
    required this.restoreTaskCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'Abrir Menu',
      itemBuilder: task.isDeleted == false
          ? (context) => [
                PopupMenuItem(
                  onTap: likeOrDislikeCallBack,
                  child: TextButton.icon(
                    onPressed: null,
                    icon: task.isFavorite == false
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                    label: task.isFavorite == false
                        ? const Text('Adicionar aos Favoritos')
                        : const Text('Remover dos Favoritos'),
                  ),
                ),
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: editTaskCallback,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: TextButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                      ),
                    ),
                  ),
                ),
                PopupMenuItem(
                  onTap: cancelOrDeleteCallBack,
                  child: TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.auto_delete),
                    label: const Text('Remover da Lista'),
                  ),
                ),
              ]
          : (context) => [
                PopupMenuItem(
                  onTap: restoreTaskCallback,
                  child: TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.restore),
                    label: const Text('Restaurar'),
                  ),
                ),
                PopupMenuItem(
                  onTap: cancelOrDeleteCallBack,
                  child: TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Excluir Definitivamente'),
                  ),
                ),
              ],
    );
  }
}
