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

  // Quando usuário remove tarefa da lixeira;
  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    await FirestoreRepository.deleteTask(task: event.task);
  }

  // Quando usuário remove tarefa da lista;
  Future<void> _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    Task removedTask = event.task.copyWith(isDeleted: true);
    await FirestoreRepository.update(task: removedTask);
  }

  // Quando usuário marca ou desmarca o como favorito;
  Future<void> _onMarkFavoriteOrUnfavoriteTask(
      MarkFavoriteOrUnfavoriteTask event, Emitter<TasksState> emit) async {
    Task updateTask = event.task.copyWith(isFavorite: !event.task.isFavorite!);
    await FirestoreRepository.update(task: updateTask);
  }

  // Quando usuário edita a tarefa;
  Future<void> _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    await FirestoreRepository.update(task: event.newTask); 
  }

  // Quando o usuário restora a tarefa que está na lixeira;
  Future<void> _onRestoreTask(
      RestoreTask event, Emitter<TasksState> emit) async {
    Task restoredTask = event.task.copyWith(
      isDeleted: false,
      isDone: false,
      isFavorite: false,
      date: DateTime.now(),
    );

    await FirestoreRepository.update(task: restoredTask);
  }

  // Quando usuário remove todas as tarefas da lixeira;
  Future<void> _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) async {
    await FirestoreRepository.deleteAllTask(taskList: state.removedTasks);
  }
}
