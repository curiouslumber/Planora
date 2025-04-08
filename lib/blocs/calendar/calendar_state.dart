import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  final DateTime selectedDate;
  final bool isLoading;
  final String? error;

  const CalendarState({
    required this.selectedDate,
    this.isLoading = false,
    this.error,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [selectedDate, isLoading, error];
}
