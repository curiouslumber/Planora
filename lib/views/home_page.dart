import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planora/bloc/auth_bloc/auth_bloc.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/repository/auth_repository.dart';
import 'package:planora/views/pages/calendar.dart';
import 'package:planora/views/pages/guest.dart';
import 'package:planora/views/pages/home.dart';
import 'package:planora/views/pages/profile.dart';
import 'package:planora/views/pages/tools.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/views/pages/tools/events/add_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final UserModel? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;
  final PageController _pageController = PageController();

  // Flag to control whether the custom (direct) animation overlay is active.
  bool _isCustomTransitionActive = false;


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
    final List<Widget> pages = [
      Home(user: widget.user, pageController: _pageController),
      Calendar(pageController: _pageController),
      Tools(user: widget.user),
      widget.user != null ? Profile(user: widget.user!) : Guest(),
    ];

    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(context.read<AuthRepository>()),
        child: Scaffold(
          body: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: pages,
              ),
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
                  child: Container(
                    key: ValueKey<int>(_currentIndex),
                    child: pages[_currentIndex],
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEvent(user: widget.user),
                ),
              );
            },
            child: Icon(
              Ionicons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            height: kBottomNavigationBarHeight + 16,
            shape: CircularNotchedRectangle(),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    IconButton(
                      icon: Icon(
                        size: 24,
                        _currentIndex == 0
                            ? Ionicons.home
                            : Ionicons.home_outline,
                      ),
                      color:
                          _currentIndex == 0
                              ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.8)
                              : Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.8),
                      onPressed: () => _onBottomNavTap(0),
                    ),
                    IconButton(
                      icon: Icon(
                        size: 24,
                        _currentIndex == 1
                            ? Ionicons.today
                            : Ionicons.today_outline,
                      ),
                      color:
                          _currentIndex == 1
                              ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.8)
                              : Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.8),
                      onPressed: () => _onBottomNavTap(1),
                    ),
                    SizedBox(width: 24),
                    IconButton(
                      icon: Icon(
                        size: 24,
                        _currentIndex == 2
                            ? Ionicons.grid
                            : Ionicons.grid_outline,
                      ),
                      color:
                          _currentIndex == 2
                              ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.8)
                              : Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.8),
                      onPressed: () => _onBottomNavTap(2),
                    ),
                    IconButton(
                      icon: Icon(
                        size: 24,
                        _currentIndex == 3
                            ? Ionicons.person
                            : Ionicons.person_outline,
                  ),
                      color:
                          _currentIndex == 3
                              ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.8)
                              : Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.8),
                      onPressed: () => _onBottomNavTap(3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
