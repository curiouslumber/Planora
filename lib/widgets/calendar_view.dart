import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    return DayView(
      scrollOffset: DateTime.now().hour * 60,
      pageViewPhysics: const NeverScrollableScrollPhysics(),
      scrollPhysics: RangeMaintainingScrollPhysics(),
      backgroundColor: context.theme.colorScheme.surface,
      timeLineOffset: 19,
      initialDay: DateTime.now(),
      showVerticalLine: false,
      dayTitleBuilder:
          (date) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              DateFormat('EEEE, d MMM').format(date),
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          ),
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: context.theme.colorScheme.primary,
        offset: 10,
      ),
      timeLineBuilder:
          (date) => Container(
            alignment: Alignment.center,
            child: Text(
              DateFormat('HH.mm').format(date),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                // ignore: deprecated_member_use
                color: context.theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
      hourLinePainter:
          (
            lineColor,
            lineHeight,
            offset,
            minuteHeight,
            showVerticalLine,
            verticalLineOffset,
            lineStyle,
            dashWidth,
            dashSpaceWidth,
            emulateVerticalOffsetBy,
            startHour,
            endHour,
          ) => HourLinePainter(
            // ignore: deprecated_member_use
            lineColor: context.theme.colorScheme.onSurface.withOpacity(0.2),
            lineHeight: lineHeight,
            offset: offset,
            minuteHeight: minuteHeight,
            showVerticalLine: showVerticalLine,
            verticalLineOffset: verticalLineOffset,
          ),
      headerStyle: HeaderStyle(
        decoration: BoxDecoration(color: Colors.transparent),
        titleAlign: TextAlign.left,
        leftIconConfig: null,
        rightIconConfig: null,
        headerTextStyle: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class HourLinePainter extends CustomPainter {
  final Color lineColor;
  final double lineHeight;
  final double offset;
  final double minuteHeight;
  final bool showVerticalLine;
  final double verticalLineOffset;
  final Paint linePaint;

  HourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.offset,
    required this.minuteHeight,
    required this.showVerticalLine,
    required this.verticalLineOffset,
  }) : linePaint =
           Paint()
             ..color = lineColor
             ..strokeWidth = lineHeight
             ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final double startX = 60;
    final double endX = size.width;
    final double startY = offset;

    // Draw horizontal hour lines
    for (double i = startY; i < size.height; i += minuteHeight * 60) {
      canvas.drawLine(Offset(startX, i), Offset(endX, i), linePaint);
    }

    // Draw vertical line if enabled
    if (showVerticalLine) {
      canvas.drawLine(
        Offset(verticalLineOffset, 0),
        Offset(verticalLineOffset, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(HourLinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.lineHeight != lineHeight ||
        oldDelegate.offset != offset ||
        oldDelegate.minuteHeight != minuteHeight ||
        oldDelegate.showVerticalLine != showVerticalLine ||
        oldDelegate.verticalLineOffset != verticalLineOffset;
  }
}
