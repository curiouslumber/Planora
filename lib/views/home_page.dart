import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planora/bloc/auth_bloc/auth_bloc.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/repository/auth_repository.dart';
import 'package:planora/views/pages/calendar.dart';
import 'package:planora/views/pages/create/create_event.dart';
import 'package:planora/views/pages/create/create_todo.dart';
import 'package:planora/views/pages/guest.dart';
import 'package:planora/views/pages/home.dart';
import 'package:planora/views/pages/profile.dart';
import 'package:planora/views/pages/tools.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/widgets/custom_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final UserModel? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;
  late final PageController _pageController;
  late final List<Widget> _pages;
  final _homeKey = GlobalKey<HomeState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pages = [
      Home(key: _homeKey, user: widget.user, pageController: _pageController),
      Calendar(user: widget.user, pageController: _pageController),
      Tools(user: widget.user),
      widget.user != null ? Profile(user: widget.user!) : Guest(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
  if (index == _currentIndex) return;
  
  _previousIndex = _currentIndex;
  
  setState(() {
    _currentIndex = index;
  });

  if ((index - _previousIndex).abs() > 1) {
    // Jump immediately if more than 1 page away
    _pageController.jumpToPage(index);
  } else {
    // Smooth animation for adjacent pages
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(context.read<AuthRepository>()),
        child: Scaffold(
          body: PageView.builder(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _previousIndex = _currentIndex;
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
          floatingActionButton: CustomFab(
            onCreateEvent: () async {
              final result = await Navigator.of(context).push<EventModel>(
                MaterialPageRoute(
                  builder: (context) => CreateEvent(user: widget.user),
                ),
              );
              
              if (result != null && mounted) {
                // Refresh the events list
                if (_homeKey.currentState != null) {
                  _homeKey.currentState!.loadData();
                }
              }
            },
            onCreateTodo: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTodo(user: widget.user),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            height: kBottomNavigationBarHeight + 16,
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
                    GestureDetector(
                      onTap: () => _onBottomNavTap(0),
                      child: Icon(
                        size: 24,
                        _currentIndex == 0
                              ? Ionicons.home
                              : Ionicons.home_outline,
                        color:
                            _currentIndex == 0
                                ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.8)
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onBottomNavTap(1),
                      child: Icon(
                        size: 24,
                        _currentIndex == 1
                            ? Ionicons.today
                            : Ionicons.today_outline,
                        color:
                            _currentIndex == 1
                                ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.8)
                              : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(width: 24),
                    GestureDetector(
                      onTap: () => _onBottomNavTap(2),
                      child: Icon(
                        size: 24,
                        _currentIndex == 2
                            ? Ionicons.grid
                            : Ionicons.grid_outline,
                        color:
                            _currentIndex == 2
                                ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.8)
                              : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onBottomNavTap(3),
                      child: Icon(
                        size: 24,
                        _currentIndex == 3
                            ? Ionicons.person
                            : Ionicons.person_outline,
                        color:
                            _currentIndex == 3
                                ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.8)
                              : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
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
