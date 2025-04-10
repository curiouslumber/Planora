import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class UpdateSelectedDate extends CalendarEvent {
  final DateTime date;

  const UpdateSelectedDate(this.date);

  @override
  List<Object?> get props => [date];
}

class NavigateDate extends CalendarEvent {
  final int days;

  const NavigateDate(this.days);

  @override
  List<Object?> get props => [days];
}
