import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lista_tarefas/models/task.dart';

// No firebase é organizado: A coleção que é o email do usuário. Dentro de cada coleção vai ter o Id da tarefa e depois os dados;

// Pega as coleçôes do usuário a partir da chave email que foi salvo na tela de login;
final data = FirebaseFirestore.instance.collection(GetStorage().read('email'));

class FirestoreRepository {
  // Criar tarefa no firebase;
  static Future<void> create({Task? task}) async {
    try {
      await FirebaseFirestore.instance
          .collection(GetStorage().read('email')) //obtém o email da tela login;
          .doc(task!.id) // Para cada email é pegado o id desse usuário
          .set(task.toMap()); // Define os valores do doc com base na task;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Obter Tarefa do firebase;
  static Future<List<Task>> get() async {
    List<Task> taskList = [];
    try {
      // Pega os dados do usuário a partir do email;
      final data = await FirebaseFirestore.instance
          .collection(GetStorage().read('email'))
          .get();
      // Para cada loop é adicionado os dados que vem do FB na taksList;
      for (var task in data.docs) {
        taskList.add(Task.fromMap(task.data()));
      }
      return taskList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Marcar checkbox como concluído ou não; Remover tarefa; Restaurar Tarefa; Marcar Favorito;
  static Future<void> update({Task? task}) async {
    try {
      //Atualiza a tarefa passada pelo id;
      data.doc(task!.id).update(task.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Remover tarefa permanentemente;
  static Future<void> deleteTask({Task? task}) async {
    try {
      data.doc(task!.id).delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Remover todas as tarefas;
  static Future<void> deleteAllTask({List<Task>? taskList}) async {
    try {
      for (var task in taskList!) {
        data.doc(task.id).delete();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
