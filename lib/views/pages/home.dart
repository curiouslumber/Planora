import 'package:ionicons/ionicons.dart';
import 'package:planora/widgets/home_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
              Icon(
                Ionicons.notifications_outline,
                color: context.theme.colorScheme.onSurface,
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
                'Good Morning,',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: context.theme.colorScheme.onSurface,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Noel Pinto!',
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 4),
                  height: context.height * 0.22,
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: context.theme.colorScheme.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Excellent! Your today’s plan is almost done',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: context.theme.colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 3,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                // ignore: deprecated_member_use
                                year2023: false,
                                strokeWidth: 6,
                                strokeAlign: 8,
                                value: 0.8,
                                color: context.theme.colorScheme.onPrimary,
                                backgroundColor: context
                                    .theme
                                    .colorScheme
                                    .surface
                                    // ignore: deprecated_member_use
                                    .withOpacity(0.4),
                              ),
                              Text(
                                '82%',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: context.theme.colorScheme.onPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24,
                  children: [
                    Text(
                      'Today\'s Schedule',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: context.theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(flex: 1, child: TwoColumnRandomGrid()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
