import 'package:equatable/equatable.dart';

import '../bloc_exports.dart';

part 'switch_event.dart';
part 'switch_state.dart';

class SwitchBloc extends HydratedBloc<SwitchEvent, SwitchState> {
  // Estado inicial do switch setado para falso;
  SwitchBloc() : super(const SwitchInitial(switchValue: false)) {
    // Emite o estado do interruptor para true;
    on<SwitchOnEvent>((event, emit) {
      emit(const SwitchState(switchValue: true));
    });

    // Emite o estado do interruptor para false;
    on<SwitchOffEvent>((event, emit) {
      emit(const SwitchState(switchValue: false));
    });
  }

  @override
  SwitchState? fromJson(Map<String, dynamic> json) {
    return SwitchState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SwitchState state) {
    return state.toMap();
  }
}
