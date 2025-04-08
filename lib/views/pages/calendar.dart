import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planora/blocs/calendar/calendar_bloc.dart';
import 'package:planora/blocs/calendar/calendar_event.dart';
import 'package:planora/blocs/calendar/calendar_state.dart';
import 'package:planora/views/schedule/add_schedule.dart';
import 'package:planora/widgets/calendar_view.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc(),
      child: const CalendarView(),
    );
  }
}

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  List<DateTime> getFiveDayView(DateTime selectedDate) {
    final baseDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    return List.generate(5, (index) => baseDate.add(Duration(days: index - 2)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        final fiveDayView = getFiveDayView(state.selectedDate);

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height / 2.7,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(33.0),
                  ),
                  centerTitle: true,
                  titleSpacing: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed:
                                  () => context.read<CalendarBloc>().add(
                                    const NavigateDate(-5),
                                  ),
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM').format(state.selectedDate),
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  () => context.read<CalendarBloc>().add(
                                    const NavigateDate(5),
                                  ),
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottom: Tab(
                    height: MediaQuery.of(context).size.height / 3.5,
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double totalWidth = constraints.maxWidth;
                                  int itemCount = 5;
                                  double spacing = 12.0;
                                  double itemWidth =
                                      (totalWidth -
                                          (spacing * (itemCount - 1))) /
                                      itemCount;

                                  return ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      DateTime day = fiveDayView[index];
                                      bool isSelected =
                                          day.day == state.selectedDate.day &&
                                          day.month ==
                                              state.selectedDate.month &&
                                          day.year == state.selectedDate.year;

                                      return GestureDetector(
                                        onTap:
                                            () => context
                                                .read<CalendarBloc>()
                                                .add(UpdateSelectedDate(day)),
                                        child: Container(
                                          width: itemWidth,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.surface
                                                    : null,
                                            borderRadius: BorderRadius.circular(
                                              18.0,
                                            ),
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? Colors.transparent
                                                      : Theme.of(
                                                        context,
                                                      ).colorScheme.onPrimary,
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
                                                      isSelected
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .onSurface
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                ),
                                              ),
                                              Text(
                                                '${day.day}',
                                                style: TextStyle(
                                                  color:
                                                      isSelected
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .onSurface
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
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
                              onPressed:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => AddSchedule(
                                            date: DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(state.selectedDate),
                                          ),
                                    ),
                                  ),
                              color: Theme.of(context).colorScheme.surface,
                              minWidth: MediaQuery.of(context).size.width,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainer,
                                ),
                              ),
                              elevation: 0,
                              child: Text(
                                'Add Schedule',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: CalendarViewWidget(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
