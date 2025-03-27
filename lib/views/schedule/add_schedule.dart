// ignore_for_file: deprecated_member_use

import 'package:date_field/date_field.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/controllers/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddSchedule extends StatelessWidget {
  const AddSchedule({super.key});

  static final eventController = Get.put(EventController());

  static final TextEditingController _titleController = TextEditingController();
  static final TextEditingController _dateController = TextEditingController();
  static final TextEditingController _startTimeController =
      TextEditingController();
  static final TextEditingController _endTimeController =
      TextEditingController();

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
                      controller: _titleController,
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
                        onChanged: (value) {
                          if (value == null) {
                            _startTimeController.text = "";
                            return;
                          }
                          _startTimeController.text = value.toIso8601String();
                        },
                        mode: DateTimeFieldPickerMode.time,
                        hideDefaultSuffixIcon: true,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: Icon(Ionicons.time_outline),
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
                        initialPickerDateTime:
                            _startTimeController.text.isNotEmpty
                                ? (_dateController.text.isEmpty
                                    ? DateTime.now()
                                    : DateTime.parse(_dateController.text))
                                : DateTime.now(),
                        onChanged: (newValue) {
                          if (newValue == null) {
                            _endTimeController.text = "";
                            return;
                          }
                          _endTimeController.text = newValue.toIso8601String();
                        },
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
                            child: Icon(Ionicons.time_outline),
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
            MaterialButton(
              onPressed: () {
                if (_dateController.text.isEmpty ||
                    _titleController.text.isEmpty ||
                    _startTimeController.text.isEmpty ||
                    _endTimeController.text.isEmpty) {
                  return;
                }
                eventController.addEvent(
                  _titleController.text,
                  DateTime.parse(_dateController.text),
                  DateTime.parse(_startTimeController.text),
                  DateTime.parse(_endTimeController.text),
                  context,
                );
                Get.back();
              },
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
