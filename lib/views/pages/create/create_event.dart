import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/services/common/event_task_image_service.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/widgets/common_snackbar.dart';
import 'package:uuid/uuid.dart';
class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key, this.user});

  final UserModel? user;

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  String taskOrEvent = "event";
  String repeatOption = "never";
  List<String> selectedDays = [];
  List<String> recurringEventDays = ["M", "Tu", "W", "Th", "F", "Sa", "Su"];

  Future<void> addEvent(EventModel event) async {
    try {
      // First try to save to Firestore if online
      bool isOnline = await _checkInternetConnection();
      
      if (isOnline) {
        await FirebaseFirestoreService().createEventDocument(event: event);
      } else {
        // If offline, just save to local storage
        event = event.copyWith(isSynced: false);
      }
      
      // Always save to local Hive storage
      await HiveEvents.addEventToHive(event);
      
      // Handle image processing if needed
      if (event.eventTileImage.isNotEmpty) {
        EventTaskImageService.handleImageTileForEvent(event);
      }
      
      if (!mounted) return;
      
      // Show success message based on connectivity
      if (isOnline) {
        CommonSnackbar.showSnackbar(
          context, 
          'Event created successfully!', 
          Theme.of(context).colorScheme.primary
        );
      } else {
        CommonSnackbar.showSnackbar(
          context, 
          'Event saved offline and will sync when online', 
          Colors.orange
        );
      }
      
    } catch (e) {
      // If there's an error with Firestore, save to local storage
      if (e.toString().contains('Exception') && !e.toString().contains('permission')) {
        await HiveEvents.addEventToHive(event.copyWith(isSynced: false));
        
        if (mounted) {
          CommonSnackbar.showSnackbar(
            context, 
            'Event saved offline due to network issues', 
            Colors.orange
          );
        }
      } else {
        // Re-throw if it's a permission error or other critical error
        if (mounted) {
          CommonSnackbar.showSnackbar(
            context, 
            'Error: ${e.toString()}', 
            Theme.of(context).colorScheme.error
          );
        }
        rethrow;
      }
    }
  }
  
  Future<bool> _checkInternetConnection() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false; // Assume offline if there's an error
    }
  }

  void _clearAllFields() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      startDate = null;
      endDate = null;
      startTime = null;
      endTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        centerTitle: true,
        actionsPadding: const EdgeInsets.only(right: 8.0),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Clear all fields',
            onPressed: () {
              if (_nameController.text.isNotEmpty ||
                  _descriptionController.text.isNotEmpty ||
                  startDate != null ||
                  endDate != null ||
                  startTime != null ||
                  endTime != null) {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('Clear all fields?'),
                        content: Text('This will remove all entered data.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          ),
                          TextButton(
                            onPressed: () {
                              _clearAllFields();
                              CommonSnackbar.showSnackbar(context, 'All fields cleared', Theme.of(context).colorScheme.primary);
                              Navigator.pop(context);
                            },
                            child: Text('Clear', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          ),
                        ],
                      ),
                );
              } else {
                _clearAllFields();
                CommonSnackbar.showSnackbar(context, 'All fields cleared', Theme.of(context).colorScheme.primary);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16.0,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeights.regular,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeights.regular,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeights.regular,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(100),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeights.regular,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: true,
                    maxLines: null,
                    minLines: 3,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeights.regular,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeights.regular,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(100),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                spacing: 24.0,
                children: [
                  Row(
                    spacing: 16.0,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.0,
                          children: [
                            Text(
                              'Start Date',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeights.regular,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            DateTimeField(
                              dateFormat: DateFormat('dd/MM/yyyy'),
                              firstDate: DateTime.now(),
                              value: startDate,
                              onChanged: (value) {
                                setState(() {
                                  startDate = value;
                                });
                              },
                              mode: DateTimeFieldPickerMode.date,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeights.regular,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.0,
                          children: [
                            Text(
                              'End Date (Optional)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeights.regular,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            DateTimeField(
                              value: endDate,
                              onChanged: (value) {
                                setState(() {
                                  endDate = value;
                                });
                              },
                              dateFormat: DateFormat('dd/MM/yyyy'),
                              mode: DateTimeFieldPickerMode.date,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeights.regular,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 16.0,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.0,
                          children: [
                            Text(
                              'Start Time',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeights.regular,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            DateTimeField(
                              value: startTime,
                              onChanged: (value) {
                                setState(() {
                                  startTime = value;
                                });
                              },
                              mode: DateTimeFieldPickerMode.time,
                              initialPickerDateTime: getNextHalfHour(),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeights.regular,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.0,
                          children: [
                            Text(
                              'End Time',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeights.regular,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            DateTimeField(
                              value: endTime,
                              initialPickerDateTime: getDefaultEndTime(
                                startTime,
                              ),
                              firstDate: (startTime ?? getNextHalfHour()).add(
                                const Duration(minutes: 5),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  endTime = value;
                                });
                              },
                              mode: DateTimeFieldPickerMode.time,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeights.regular,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(100),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Repeat",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeights.regular,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    DropdownButton<String>(
                      value: repeatOption,
                      items:
                          Constants.repeatOptions
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value == "never" || value == "daily") {
                          selectedDays = [];
                        }
                        setState(() {
                          repeatOption = value!;
                          selectedDays = [];
                        });
                      },
                    ),
                  ],
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final chipWidth =
                        (constraints.maxWidth / recurringEventDays.length) - 4;
                    return Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: List.generate(
                        recurringEventDays.length,
                        (index) => SizedBox(
                          width: chipWidth,
                          child: FilterChip(
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            selected: selectedDays.contains(
                              recurringEventDays[index],
                            ),
                            onSelected: (value) {
                              if (repeatOption == "never" ||
                                  repeatOption == "daily") {
                                selectedDays = [];
                                return;
                              }
                              setState(() {
                                if (value) {
                                  selectedDays.add(recurringEventDays[index]);
                                } else {
                                  selectedDays.remove(
                                    recurringEventDays[index],
                                  );
                                }
                              });
                            },
                            label: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(recurringEventDays[index]),
                            ),
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        onPressed: () async {
          if (_nameController.text.isEmpty || widget.user == null || widget.user!.uid.isEmpty || startDate == null || startTime == null) {
            return;
          }

          EventModel event = EventModel(
            id: Uuid().v4(),
            userId: widget.user!.uid,
            name: _nameController.text,
            description: _descriptionController.text,
            eventTileImage: '',
            eventTileImageLocalUrl: '',
            isImageProcessing: false,
            startDate: startDate!.toString(),
            endDate: endDate?.toString(),
            startTime: startTime!.toString(),
            endTime:
                endTime != null ? endTime!.toString() : startTime!.toString(),
            eventStatus: Constants.eventStatus[0],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await addEvent(event);
          
          if (mounted) {
            Navigator.of(context).pop(event);
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        label: Text(
          "Create",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeights.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  DateTime getNextHalfHour() {
    final now = DateTime.now();
    int minute = now.minute;
    int addMinutes;
    if (minute == 0) {
      addMinutes = 30;
    } else if (minute <= 30) {
      addMinutes = 30 - minute;
    } else {
      addMinutes = 60 - minute;
    }
    DateTime next = now.add(Duration(minutes: addMinutes));
    // Remove seconds and microseconds for cleanliness
    return DateTime(next.year, next.month, next.day, next.hour, next.minute);
  }

  DateTime getDefaultEndTime(DateTime? start) {
    final base = start ?? getNextHalfHour();
    return base.add(const Duration(hours: 1));
  }
}
