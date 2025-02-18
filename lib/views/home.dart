import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actionsPadding: EdgeInsets.only(right: 28),
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xffA9A9A9)),
                ),
              ),
              SvgPicture.asset('assets/icons/notification.svg'),
            ],
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Good Morning,',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Color(0xffA9A9A9),
                  fontSize: 14,
                ),
              ),
              Text(
                'Noel Pinto!',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff343434),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: context.theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 40,
            children: [
              Container(
                height: 166,
                width: 319,
                padding: EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Color(0xffF0857A),
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
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
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
                              year2023: false,
                              strokeWidth: 6,
                              strokeAlign: 8,
                              value: 0.8,
                              color: Colors.white,
                              backgroundColor: Colors.white.withOpacity(0.4),
                            ),
                            Text(
                              '82%',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: Colors.white,
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
              Column(
                children: [
                  Text(
                    'Today\'s Schedule',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xffF0857A),
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/home-2.svg'),
              activeIcon: SvgPicture.asset('assets/icons/home-2-selected.svg'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/calendar.svg'),
              activeIcon: SvgPicture.asset(
                'assets/icons/calendar-selected.svg',
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/chart-2.svg'),
              activeIcon: SvgPicture.asset(
                'assets/icons/calendar-selected.svg',
              ),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/profile.svg'),
              activeIcon: SvgPicture.asset(
                'assets/icons/calendar-selected.svg',
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
