import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget child;
  final Duration duration;
  
  const SplashScreen({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _displayText = '';
  final String _fullText = 'Planora';
  int _charIndex = 0;
  Timer? _typingTimer;
  bool _showCursor = true;
  bool _isInitialized = false;
  bool _isTypingComplete = false;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
    
    // Blinking cursor effect
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() => _showCursor = !_showCursor);
      }
    });
  }

  void _startTypingAnimation() {
    // Start typing animation
    _typingTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _displayText = _fullText.substring(0, _charIndex + 1);
          _charIndex++;
        });
      } else {
        _typingTimer?.cancel();
        _isTypingComplete = true;
        _checkAndNavigate();
      }
    });
  }

  void _checkAndNavigate() async {
    if (!_isTypingComplete) return;
    
    await Future.delayed(Duration(milliseconds: 500));
  
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        if (!_isInitialized)
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _displayText,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Fredoka',
                          letterSpacing: 1.2,
                        ),
                  ),
                  if (_showCursor)
                    Container(
                      width: 2,
                      height: 40,
                      margin: const EdgeInsets.only(left: 2),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}