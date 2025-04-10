import 'package:date_field/date_field.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/core/di/service_locator.dart';
import 'package:planora/domain/services/database_service.dart';
import 'package:planora/core/utilities/font_weights.dart';

class AddSchedule extends StatefulWidget {
  final String date;
  final String? startTime;

  const AddSchedule({super.key, required this.date, this.startTime});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _dateController;
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize the date controller with the passed date
    _dateController = TextEditingController(text: widget.date);

    // Initialize time controllers
    if (widget.startTime != null) {
      final startDateTime = _parseTimeToDateTime(
        widget.date,
        widget.startTime!,
      );
      _startTimeController = TextEditingController(
        text: startDateTime.toIso8601String(),
      );

      // Set end time 1 hour ahead of start time
      final endDateTime = startDateTime.add(const Duration(hours: 1));
      _endTimeController = TextEditingController(
        text: endDateTime.toIso8601String(),
      );
    } else {
      _startTimeController = TextEditingController();
      _endTimeController = TextEditingController();
    }
  }

  // Helper method to parse time string to DateTime
  DateTime _parseTimeToDateTime(String dateStr, String timeStr) {
    final date = DateTime.parse(dateStr);
    final timeParts = timeStr.split(':');

    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  // Save the event to the database
  Future<void> _saveEvent() async {
    // Validate inputs
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_startTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a start time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an end time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Format the date string (yyyy-MM-dd)
      final date = DateTime.parse(_dateController.text);
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      // Format the time strings (HH:mm)
      final startTime = DateTime.parse(_startTimeController.text);
      final formattedStartTime = DateFormat('HH:mm').format(startTime);

      final endTime = DateTime.parse(_endTimeController.text);
      final formattedEndTime = DateFormat('HH:mm').format(endTime);

      // Get database service instance from dependency injection
      final dbService = getIt<DatabaseService>();

      // Save the event
      final result = await dbService.addEvent(
        title: _titleController.text,
        date: formattedDate,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
      );

      // Handle the result
      result.fold(
        (failure) {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isSaving = false;
            });
          }
        },
        (event) {
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Event added successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Return true to indicate success
          }
        },
      );
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding event: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actionsPadding: EdgeInsets.only(right: 32),
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
            ],
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Text(
                'Be Productive',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(230),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Add Schedule',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              spacing: 18.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  spacing: 12.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(230),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _titleController,
                      cursorColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(230),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeights.regular,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 24.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(230),
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(230),
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 12.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(230),
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: DateTimeFormField(
                        initialValue:
                            widget.date.isNotEmpty
                                ? DateTime.parse(widget.date)
                                : null,
                        onChanged: (newValue) {
                          if (newValue == null) {
                            _dateController.text = "";
                            return;
                          }
                          _dateController.text = newValue.toIso8601String();
                        },
                        mode: DateTimeFieldPickerMode.date,
                        hideDefaultSuffixIcon: true,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: 24.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Icon(Ionicons.calendar_outline),
                          ),
                          suffixIconColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(230),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 24.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(230),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(230),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeights.regular,
                        ),
                        dateFormat: DateFormat("EEEE, d MMMM yyyy"),
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 12.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Start Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(230),
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: DateTimeFormField(
                        onChanged: (value) {
                          if (value == null) {
                            _startTimeController.text = "";
                            return;
                          }
                          _startTimeController.text = value.toIso8601String();

                          // Update end time to be 1 hour ahead when start time changes
                          final endTime = value.add(const Duration(hours: 1));
                          _endTimeController.text = endTime.toIso8601String();
                        },
                        initialValue:
                            _startTimeController.text.isNotEmpty
                                ? DateTime.parse(_startTimeController.text)
                                : null,
                        mode: DateTimeFieldPickerMode.time,
                        hideDefaultSuffixIcon: true,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Icon(Ionicons.time_outline),
                          ),
                          suffixIconColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(230),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 24.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(230),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(230),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeights.regular,
                        ),
                        dateFormat: DateFormat("HH.mm - hh.mm a"),
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 12.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'End Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(230),
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: DateTimeFormField(
                        initialValue:
                            _endTimeController.text.isNotEmpty
                                ? DateTime.parse(_endTimeController.text)
                                : null,
                        onChanged: (newValue) {
                          if (newValue == null) {
                            _endTimeController.text = "";
                            return;
                          }
                          _endTimeController.text = newValue.toIso8601String();
                        },
                        mode: DateTimeFieldPickerMode.time,
                        hideDefaultSuffixIcon: true,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Icon(Ionicons.time_outline),
                          ),
                          suffixIconColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(230),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 24.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(230),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(230),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeights.regular,
                        ),
                        dateFormat: DateFormat("HH.mm - hh.mm a"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            MaterialButton(
              onPressed: _isSaving ? null : _saveEvent,
              height: 64.0,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(230),
              minWidth: MediaQuery.of(context).size.width,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child:
                  _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'Add Schedule',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
