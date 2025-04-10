import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planora/presentation/blocs/calendar/calendar_event.dart';
import 'package:planora/presentation/blocs/calendar/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarState(selectedDate: DateTime.now())) {
    on<UpdateSelectedDate>(_onUpdateSelectedDate);
    on<NavigateDate>(_onNavigateDate);
  }

  void _onUpdateSelectedDate(
    UpdateSelectedDate event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onNavigateDate(NavigateDate event, Emitter<CalendarState> emit) {
    final newDate = state.selectedDate.add(Duration(days: event.days));
    emit(state.copyWith(selectedDate: newDate));
  }
}
