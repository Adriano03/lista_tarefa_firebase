import 'package:equatable/equatable.dart';
import 'package:lista_tarefas/blocs/bloc_exports.dart';
import 'package:lista_tarefas/models/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTasks);
  }

  // É chamado sempre que um evento AddTask é adicionado;
  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    // Obtém o estado atual do bloco;
    final state = this.state;
    // Emite um novo estado de tarefas com uma lista atualizada incluindo alguma nova tarefa adicionada;
    // Os .. encadeia as chamadas dos métodos List.from e add na mesma linha;
    emit(
      TasksState(
        pendingTasks: List.from(state.pendingTasks)..add(event.task),
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );
  }

  // Chamado quando o checkbox é clicado;
  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completedTasks = state.completedTasks;
    List<Task> favoriteTasks = state.favoriteTasks;

    if (task.isDone == false) {
      if (task.isFavorite == false) {
        // Se não é favorito e não está completo, remove tarefa da lista de pendentes;
        pendingTasks = List.from(pendingTasks)..remove(task);
        // Tarefa inserida na lista de tarefas completas;
        completedTasks.insert(0, task.copyWith(isDone: true));
      } else {
        // Entra no else se for favorito e não concluído;
        var taskIndex = favoriteTasks.indexOf(task);
        // Remove tarefa da lista de pendentes;
        pendingTasks = List.from(pendingTasks)..remove(task);
        // Insere tarefa na lista de tarefas completadas;
        completedTasks.insert(0, task.copyWith(isDone: true));
        // Remove tarefa da lista de favorito, depois insere a mesma como concluída;
        favoriteTasks = List.from(favoriteTasks)
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: true));
      }
      // Entra no else se a tarefa está concluída;
    } else {
      // Entra no if se a tarefa concluída não é favorita;
      if (task.isFavorite == false) {
        // Remove a tarefa da lista de concluídas;
        completedTasks = List.from(completedTasks)..remove(task);
        // Remove a tarefa da lista de pendente, e adiciona a mesma como concluída;
        pendingTasks = List.from(pendingTasks)
          ..remove(task)
          ..insert(0, task.copyWith(isDone: false));
        // Entra no else se a tarefa está concluída e está favorita;
      } else {
        var taskIndex = favoriteTasks.indexOf(task);
        // Remove a tarefa da lista de concluídas;
        completedTasks = List.from(completedTasks)..remove(task);
        // Remove a tarefa da lista de pendente, e adiciona a mesma como inconcluída;
        pendingTasks = List.from(pendingTasks)
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: false));
        // Remove a tarefa da lista de favoritas, e adiciona a mesma como inconcluída;
        favoriteTasks = List.from(favoriteTasks)
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: false));
      }
    }

    // Emitir lista atualizada para cada tela, menos para a tela de tarefas removidas;
    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: state.removedTasks,
    ));
  }

  // Se estiver com o isDeleted == true deleta permanente;
  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    // Remove a tarefa da lixeira;
    final List<Task> removedTasks = List.from(state.removedTasks)
      ..remove(event.task);
    // Emitir lista atualizada para cada tela;
    emit(TasksState(
      pendingTasks: state.pendingTasks,
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
      removedTasks: removedTasks,
    ));
  }

  // Se estiver com o isDeleted == false deleta e adiciona a lixeira;
  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final List<Task> pendingTasks = List.from(state.pendingTasks)
      ..remove(event.task);

    final List<Task> completedTasks = List.from(state.completedTasks)
      ..remove(event.task);

    final List<Task> favoriteTasks = List.from(state.favoriteTasks)
      ..remove(event.task);

    // Adiciona as tarefas na lixeira e seta como deletado 'isDeleted: true';
    final List<Task> removedTask = List.from(state.removedTasks)
      ..add(event.task.copyWith(isDeleted: true));
    // Emite um novo estado com a lista atualizada e a lista de tarefas removidas;
    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: removedTask,
    ));
  }

  // Função para identificar se a tarefa é favorita ou não;
  void _onMarkFavoriteOrUnfavoriteTask(
      MarkFavoriteOrUnfavoriteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    // Obtém o estado atual de todas as tarefas;
    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completedTasks = state.completedTasks;
    List<Task> favoriteTasks = state.favoriteTasks;
    // Se não for favorito e não for concluído entra nos dois Ifs;
    if (event.task.isDone == false) {
      if (event.task.isFavorite == false) {
        // Se não for favorito, obtém o indice de tarefa pendente, remove todas tarefas e o torna favorito (true);
        var taskIndex = pendingTasks.indexOf(event.task);
        // Remove a tarefa da lista tarefas pendentes e adiciona como isFavorite = true;
        pendingTasks = List.from(pendingTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: true));
        // Adiciona a tarefa favorita na primeira posição da lista;
        favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
      } else {
        var taskIndex = pendingTasks.indexOf(event.task);
        // Remove a tarefa da lista tarefas pendentes e adiciona como isFavorite = false;
        pendingTasks = List.from(pendingTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: false));
        // Remove a tarefa da lista de tarefas favoritas;
        favoriteTasks.remove(event.task);
      }
    } else {
      // Se a tarefa está concluida;
      if (event.task.isFavorite == false) {
        var taskIndex = completedTasks.indexOf(event.task);
        // Repete o procedimento removendo as tarefas da lista de tarefas completadas e coloca o isFavorite = true;
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: true));
        // Adiciona a tarefa favorita na primeira posição da lista;
        favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
      } else {
        // Se a tarefa está concluída e favorita remove a marcação;
        var taskIndex = completedTasks.indexOf(event.task);
        // Remove a tarefa concluída da lista de tarefas concluídas e adiciona-a novamente com isFavorite = false;
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: false));
        // Remove a tarefa da lista de tarefas favoritas
        favoriteTasks.remove(event.task);
      }
    }
    // Emite um novo estado com todas as listas atualizadas
    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: state.removedTasks,
    ));
  }

  // Editar tarfa;
  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    final state = this.state; // Pega o estado atual do app;
    List<Task> favouriteTasks =
        state.favoriteTasks; // Pega apenas a lista de tarefas favoritas;
    if (event.oldTask.isFavorite == true) {
      favouriteTasks
        ..remove(event.oldTask) // Remove a tarefa antiga da lista de favoritos;
        ..insert(
            0,
            event
                .newTask); // Insere a nova tarefa na primeira posição da lista de favoritos;
    }
    emit(
      TasksState(
        pendingTasks: List.from(state.pendingTasks)
          ..remove(
              event.oldTask) // Remove a tarefa antiga da lista de pendentes;
          ..insert(
              0,
              event
                  .newTask), // Insere a nova tarefa na primeira posição da lista de pendentes;
        completedTasks: state.completedTasks..remove(event.oldTask),
        favoriteTasks: favouriteTasks,
        removedTasks: state.removedTasks,
      ),
    );
  }

  // Restaurar tarefa;
  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final List<Task> removedTask = List.from(state.removedTasks)
      ..remove(event.task); // Remover tarefa da lista da lixeira;

    // Adiciona a tarefa na lista de pendentes com valores para false;
    List<Task> pendingTask = List.from(state.pendingTasks)
      ..insert(
        0,
        event.task.copyWith(
          isDeleted: false,
          isDone: false,
          isFavorite: false,
        ),
      );
    // Emite estado com alterações nas tarefas removidas e pendentes, outras apenas mantém;
    emit(
      TasksState(
        removedTasks: removedTask,
        pendingTasks: pendingTask,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
      ),
    );
  }

  //Excluir todas as tarefas;
  void _onDeleteAllTasks(DeleteAllTasks event, Emitter<TasksState> emit) {
    final state = this.state;
    // Remover todas as tarefas da lista da lixeira;
    final List<Task> removedAllTasks = List.from(state.removedTasks)..clear();
    // Emitir estado com as tarefas removidas, e os demais permanecem iguais;
    emit(TasksState(
      removedTasks: removedAllTasks,
      pendingTasks: state.pendingTasks,
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
    ));
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}
