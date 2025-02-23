import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.height / 2.8),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: AppBar(
              backgroundColor: context.theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(33.0)),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20,
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
              ],
              title: Text(
                'January',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: context.theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              bottom: Tab(
                height: context.height / 3.6,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 24.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16.0,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double totalWidth = constraints.maxWidth;
                              int itemCount = 5;
                              double spacing = 10.0;
                              double itemWidth =
                                  (totalWidth - (spacing * (itemCount - 1))) /
                                  itemCount;

                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (context, index) => Container(
                                      width: itemWidth,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            index == 2
                                                ? context
                                                    .theme
                                                    .colorScheme
                                                    .surface
                                                : null,
                                        borderRadius: BorderRadius.circular(
                                          16.0,
                                        ),
                                        border: Border.all(
                                          color:
                                              index == 2
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Mon',
                                            style: TextStyle(
                                              color:
                                                  index == 2
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
                                            '1',
                                            style: TextStyle(
                                              color:
                                                  index == 2
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
                                    ),
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
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Text(
                            'Add Schedule',
                            style: TextStyle(
                              color: context.theme.colorScheme.inverseSurface,
                              fontWeight: FontWeight.w600,
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
    );
  }
}
