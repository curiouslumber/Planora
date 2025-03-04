import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddSchedule extends StatelessWidget {
  const AddSchedule({super.key});

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
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
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
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: context.theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Add Schedule',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w700,
                  color: context.theme.colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: context.theme.colorScheme.surface,
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
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: context.theme.colorScheme.onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                    TextFormField(
                      cursorColor: context.theme.colorScheme.onSurface
                          .withOpacity(0.7),
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        color: context.theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 24.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.colorScheme.onSurface
                                .withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.colorScheme.onSurface
                                .withOpacity(0.5),
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
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: context.theme.colorScheme.onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: DateTimeFormField(
                        mode: DateTimeFieldPickerMode.date,
                        hideDefaultSuffixIcon: true,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: 24.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/calendar_add_schedule.svg',
                            ),
                          ),
                          suffixIconColor: context.theme.colorScheme.onSurface
                              .withOpacity(0.5),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 24.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        firstDate: DateTime.now().add(const Duration(days: 10)),
                        lastDate: DateTime.now().add(const Duration(days: 40)),
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        dateFormat: DateFormat("EEEE, d MMMM yyyy"),
                        initialPickerDateTime: DateTime.now().add(
                          const Duration(days: 20),
                        ),
                        onChanged: (DateTime? value) {},
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
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: context.theme.colorScheme.onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: DateTimeFormField(
                        mode: DateTimeFieldPickerMode.time,
                        hideDefaultSuffixIcon: true,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Icon(Icons.access_time_outlined),
                          ),
                          suffixIconColor: context.theme.colorScheme.onSurface
                              .withOpacity(0.5),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 24.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        dateFormat: DateFormat("HH.mm - hh.mm a"),
                        firstDate: DateTime.now().add(const Duration(days: 10)),
                        lastDate: DateTime.now().add(const Duration(days: 40)),
                        initialPickerDateTime: DateTime.now().add(
                          const Duration(days: 20),
                        ),
                        onChanged: (DateTime? value) {},
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
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: context.theme.colorScheme.onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: DateTimeFormField(
                        mode: DateTimeFieldPickerMode.time,
                        hideDefaultSuffixIcon: true,
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        dateFormat: DateFormat("HH.mm - hh.mm a"),
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Icon(Icons.access_time_outlined),
                          ),
                          suffixIconColor: context.theme.colorScheme.onSurface
                              .withOpacity(0.5),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 24.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.theme.colorScheme.onSurface
                                  .withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        firstDate: DateTime.now().add(const Duration(days: 10)),
                        lastDate: DateTime.now().add(const Duration(days: 40)),
                        initialPickerDateTime: DateTime.now().add(
                          const Duration(days: 20),
                        ),
                        onChanged: (DateTime? value) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            MaterialButton(
              onPressed: () => Get.back(),
              height: 64.0,
              color: context.theme.colorScheme.onSurface.withOpacity(0.9),
              minWidth: context.width,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                'Add Schedule',
                style: TextStyle(
                  color: context.theme.colorScheme.surface,
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
