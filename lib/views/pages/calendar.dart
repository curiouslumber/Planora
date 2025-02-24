import 'package:calendar_view/calendar_view.dart';
import 'package:easy_scheduler/views/schedule/add_schedule.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();

  List<DateTime> getFiveDayView() {
    return List.generate(
      5,
      (index) => selectedDate.add(Duration(days: index - 2)),
    );
  }

  void updateDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> fiveDayView = getFiveDayView();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.height / 2.7),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            child: AppBar(
              backgroundColor: context.theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(33.0)),
              ),
              centerTitle: true,
              titleSpacing: 0, // Ensures proper spacing
              automaticallyImplyLeading: false, // Prevents default back button
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0), // Adjust this value for top spacing
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => updateDate(-5),
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 20,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          DateFormat('MMMM').format(selectedDate),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: context.theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () => updateDate(5),
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottom: Tab(
                height: context.height / 3.5,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8.0,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double totalWidth = constraints.maxWidth;
                              int itemCount = 5;
                              double spacing = 12.0;
                              double itemWidth =
                                  (totalWidth - (spacing * (itemCount - 1))) /
                                  itemCount;

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  DateTime day = fiveDayView[index];
                                  bool isToday =
                                      day.day == DateTime.now().day &&
                                      day.month == DateTime.now().month &&
                                      day.year == DateTime.now().year;

                                  return Container(
                                    width: itemWidth,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          isToday
                                              ? context
                                                  .theme
                                                  .colorScheme
                                                  .surface
                                              : null,
                                      borderRadius: BorderRadius.circular(18.0),
                                      border: Border.all(
                                        color:
                                            isToday
                                                ? Colors.transparent
                                                : context
                                                    .theme
                                                    .colorScheme
                                                    .inversePrimary,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('E').format(day),
                                          style: TextStyle(
                                            color:
                                                isToday
                                                    ? context
                                                        .theme
                                                        .colorScheme
                                                        .onSurface
                                                    : context
                                                        .theme
                                                        .colorScheme
                                                        .onPrimary
                                                        .withOpacity(0.8),
                                          ),
                                        ),
                                        Text(
                                          '${day.day}',
                                          style: TextStyle(
                                            color:
                                                isToday
                                                    ? context
                                                        .theme
                                                        .colorScheme
                                                        .onSurface
                                                    : context
                                                        .theme
                                                        .colorScheme
                                                        .onPrimary
                                                        .withOpacity(0.9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (context, index) =>
                                        SizedBox(width: spacing),
                                itemCount: itemCount,
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: MaterialButton(
                          onPressed: () => Get.to(() => const AddSchedule()),
                          color: context.theme.colorScheme.onPrimary,
                          minWidth: context.width,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 0,
                          child: Text(
                            'Add Schedule',
                            style: TextStyle(
                              color: context.theme.colorScheme.inverseSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: DayView(
                  backgroundColor: context.theme.colorScheme.surface,
                  initialDay: DateTime.now(),
                  showVerticalLine: false,
                  dayTitleBuilder:
                      (date) => Text(
                        DateFormat('EEEE, d MMM').format(date),
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                  liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
                    color: context.theme.colorScheme.primary,
                  ),
                  timeLineBuilder:
                      (date) => Container(
                        alignment: Alignment.center,
                        child: Text(
                          DateFormat('HH:mm').format(date),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: context.theme.colorScheme.onSurface
                                .withOpacity(0.5),
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
                        lineColor: context.theme.colorScheme.onSurface
                            .withOpacity(0.2),
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
                ),
              ),
            ),
          ],
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
