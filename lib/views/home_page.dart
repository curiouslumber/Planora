import 'package:easy_scheduler/views/pages/calendar.dart';
import 'package:easy_scheduler/views/pages/home.dart';
import 'package:easy_scheduler/views/pages/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _currentIndex = 0;
  int _previousIndex = 0;
  final PageController _pageController = PageController();

  // Flag to control whether the custom (direct) animation overlay is active.
  bool _isCustomTransitionActive = false;

  final List<Widget> _pages = [
    Center(child: const Home()),
    Center(child: const Calendar()),
    Center(child: const Tools()),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  // Called when a bottom nav item is tapped.
  void _onBottomNavTap(int index) {
    // If the difference is greater than 1, use a direct custom transition.
    if ((index - _currentIndex).abs() > 1) {
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = index;
        _isCustomTransitionActive = true;
      });
      // Jump immediately without animating through intermediate pages.
      _pageController.jumpToPage(index);
      // Disable the custom overlay after the transition duration.
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isCustomTransitionActive = false;
          });
        }
      });
    } else {
      // For adjacent pages, animate normally.
      setState(() {
        _previousIndex = _currentIndex;
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Stack to overlay the custom transition animation when needed.
      body: Stack(
        children: [
          // The PageView supports swipe gestures.
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _pages,
          ),
          // When a non-adjacent bottom nav tap occurs,
          // overlay an AnimatedSwitcher that directly transitions between pages.
          if (_isCustomTransitionActive)
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                // Determine slide direction based on page order.
                final isForward = _currentIndex > _previousIndex;
                final offsetTween = Tween<Offset>(
                  begin: Offset(isForward ? 1.0 : -1.0, 0.0),
                  end: Offset(0.0, 0.0),
                );
                return SlideTransition(
                  position: offsetTween.animate(animation),
                  child: child,
                );
              },
              // Use a key based on _currentIndex to trigger the switch.
              child: Container(
                key: ValueKey<int>(_currentIndex),
                child: _pages[_currentIndex],
              ),
            ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: BottomNavigationBar(
            elevation: 0,
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xffF0857A),
            unselectedItemColor: Colors.grey,
            onTap: _onBottomNavTap,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/home-2.svg'),
                activeIcon: SvgPicture.asset(
                  'assets/icons/home-2-selected.svg',
                ),
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
                icon: Icon(Icons.toll_outlined),
                activeIcon: Icon(Icons.toll_outlined),
                label: 'Activity',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/profile.svg'),
                activeIcon: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  color: context.theme.colorScheme.primary,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
