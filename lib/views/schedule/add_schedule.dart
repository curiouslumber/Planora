import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    );
  }
}
