import 'package:planora/views/pages/calendar.dart';
import 'package:planora/views/pages/home.dart';
import 'package:planora/views/pages/profile.dart';
import 'package:planora/views/pages/tools.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

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

  static const List<Widget> _pages = [Home(), Calendar(), Tools(), Profile()];

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
            iconSize: 20.0,
            selectedFontSize: 12.0,
            unselectedFontSize: 12.0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: context.theme.colorScheme.primary,
            unselectedItemColor: context.theme.colorScheme.onSurface.withAlpha(
              100,
            ),
            onTap: _onBottomNavTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Ionicons.home_outline),
                activeIcon: Icon(Ionicons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Ionicons.today_outline),
                activeIcon: Icon(Ionicons.today),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Ionicons.file_tray_outline),
                activeIcon: Icon(Ionicons.file_tray),
                label: 'Tools',
              ),
              BottomNavigationBarItem(
                icon: Icon(Ionicons.person_outline),
                activeIcon: Icon(Ionicons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
