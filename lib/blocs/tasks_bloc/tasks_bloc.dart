import 'package:equatable/equatable.dart';
import 'package:lista_tarefas/blocs/bloc_exports.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/repository/firestore_repository.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<GetAllTasks>(_onGetAllTasks);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTask);
  }

  // Quando usuário clica uma tarefa;
  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    // Adicionar tarefas no firebase;
    await FirestoreRepository.create(task: event.task);
  }

  Future<void> _onGetAllTasks(
      GetAllTasks event, Emitter<TasksState> emit) async {
    List<Task> pendingTasks = [];
    List<Task> completedTasks = [];
    List<Task> favoriteTasks = [];
    List<Task> removedTasks = [];

    // Buscar tarefas do firebase;
    await FirestoreRepository.get().then((value) {
      // Adicionar cada tarefa em sua respectiva lista;
      for (var task in value) {
        if (task.isDeleted == true) {
          removedTasks.add(task);
        } else {
          if (task.isFavorite == true) {
            favoriteTasks.add(task);
          }
          if (task.isDone == true) {
            completedTasks.add(task);
          } else {
            pendingTasks.add(task);
          }
        }
      }

      emit(TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: removedTasks,
      ));
    });
  }

  /// Quando usuário clica no checkbox;
  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    // Se for true muda para false e vice versa;
    Task updateTask = event.task.copyWith(isDone: !event.task.isDone!);
    // Passa a tarefa com o checkbox atualizado;
    await FirestoreRepository.update(task: updateTask);
  }

  // Quando usuário remove tarefa da lista;
  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    print('Delete task');
  }

  // Quando usuário remove tarefa da lixeira;
  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) {
    print('Remove task');
  }

  // Quando usuário marca ou desmarca o como favorito;
  void _onMarkFavoriteOrUnfavoriteTask(
      MarkFavoriteOrUnfavoriteTask event, Emitter<TasksState> emit) {
    print('Favorite task');
  }

  // Quando usuário edita a tarefa;
  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    print('Edit task');
  }

  // Quando o usuário restora a tarefa que está na lixeira;
  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) {
    print('Restore task');
  }

  // Quando usuário remove todas as tarefas da lixeira;
  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) {
    print('Delete All task');
  }
}
