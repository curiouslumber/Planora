// ignore_for_file: use_build_context_synchronously

import 'package:calendar_view/calendar_view.dart';
import 'package:easy_scheduler/databases/hive_events.dart';
import 'package:easy_scheduler/views/schedule/add_schedule.dart';
import 'package:easy_scheduler/widgets/calendar_view.dart';
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

  void getEvents() {
    void fetchEvents() async {
      var events = await HiveEvents.getEventsFromHive();
      for (var event in events) {
        CalendarEventData calendarEventData = CalendarEventData(
          title: event.title,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          color: context.theme.colorScheme.primaryFixed,
          titleStyle: TextStyle(
            fontSize: 12,
            color: context.theme.colorScheme.onPrimaryFixed,
          ),
          descriptionStyle: TextStyle(
            fontSize: 12,
            color: context.theme.colorScheme.onPrimaryFixed,
          ),
        );
        CalendarControllerProvider.of(
          context,
        ).controller.add(calendarEventData);
      }
    }

    fetchEvents();
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

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
    getEvents();
    List<DateTime> fiveDayView = getFiveDayView();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.height / 2.7),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: AppBar(
              // ignore: deprecated_member_use
              backgroundColor: context.theme.colorScheme.primary.withOpacity(
                0.9,
              ),
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
                                                        // ignore: deprecated_member_use
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
                                                        // ignore: deprecated_member_use
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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CalendarView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
