import 'package:flutter/material.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/utils/constants.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentMinute; // minute of the day: 0-1439
  final Color progressColor;
  final Color trackColor;
  final Color checkpointColor;
  final double checkpointDiameter;
  final double height;
  final Set<TimeOfDay> checkpointTimes;
  final double? snappedProgress;

  static const int _totalMinutes = 24 * 60;

  const StepProgressIndicator({
    super.key,
    required this.currentMinute,
    this.progressColor = Colors.blue,
    this.trackColor = Colors.grey,
    this.checkpointColor = Colors.white,
    this.checkpointDiameter = 8.0,
    this.height = 10.0,
    this.checkpointTimes = const {},
    this.snappedProgress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth;

        return Container(
          height: height + checkpointDiameter / 2,
          alignment: Alignment.centerLeft,
          child: Stack(
            children: [
              // Background track
              Container(
                height: height,
                width: barWidth,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              // Filled progress
              Container(
                height: height,
                width:
                    barWidth *
                    (snappedProgress ?? (currentMinute / _totalMinutes)),
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              // Spots at event times (hours and minutes)
              ...checkpointTimes.map((time) {
                int minuteOfDay = time.hour * 60 + time.minute;
                double positionX;
                if (minuteOfDay == 0) {
                  // Place the first dot just inside the left border
                  positionX = checkpointDiameter / 2;
                } else if (minuteOfDay == _totalMinutes) {
                  // Place the last dot just inside the right border
                  positionX = barWidth - checkpointDiameter / 2;
                } else {
                  positionX = minuteOfDay * (barWidth / _totalMinutes);
                }
                return Positioned(
                  left: positionX - checkpointDiameter / 2,
                  top: (height / 2) - checkpointDiameter / 2,
                  child: Container(
                    width: checkpointDiameter,
                    height: checkpointDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: checkpointColor,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

double getSnappedDayProgress(List<EventModel> todayEvents) {
  final now = DateTime.now();
  double timeProgress = (now.hour + now.minute / 60) / 24;

  if (todayEvents.isEmpty) return timeProgress;

  // If all events are completed, fill the bar
  if (todayEvents.every((e) => e.eventStatus == Constants.eventStatus[2])) {
    return 1.0;
  }

  // Sort events by end time
  List<EventModel> sortedEvents = List.from(todayEvents)..sort(
    (a, b) => DateTime.parse(a.endTime).compareTo(DateTime.parse(b.endTime)),
  );

  DateTime? latestSnappableEnd;

  // Track if all previous events are completed
  bool allPrevCompleted = true;
  for (final event in sortedEvents) {
    final isCompleted = event.eventStatus == Constants.eventStatus[2];
    final eventEnd = DateTime.parse(event.endTime);

    if (isCompleted && allPrevCompleted && eventEnd.isAfter(now)) {
      latestSnappableEnd = eventEnd;
    }
    if (!isCompleted) {
      allPrevCompleted = false;
    }
  }

  if (latestSnappableEnd != null) {
    double snappedProgress =
        (latestSnappableEnd.hour + latestSnappableEnd.minute / 60) / 24;
    return snappedProgress > timeProgress ? snappedProgress : timeProgress;
  }

  return timeProgress;
}
