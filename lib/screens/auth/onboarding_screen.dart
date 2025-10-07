import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mygate_coepd/screens/auth/enter_email_mobile_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late AnimationController _textAnimationController;
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      // 'image': 'https://picsum.photos/seed/onboard1/600/800',
      'image': 'assets/images/onboarding1.jpg',
      'title': 'Welcome to smarter living',
      'description':
          'Your home, your people, your peace of mind — all in one app.',
    },
    {
      'image': 'assets/images/onboarding2.jpg',
      'title': 'Who’s there?',
      'description':
          'Real-time updates for visitors and deliveries — stay in the know.',
    },
    {
      'image': 'assets/images/onboarding3.jpg',
      'title': 'Need a hand?',
      'description':
          'Book trusted local help — from electricians to dog walkers.',
    },
    {
      'image': 'assets/images/onboarding4.jpg',
      'title': 'Bills, sorted.',
      'description': 'Pay rent, maintenance, and more — easily and on time.',
    },
    {
      'image': 'assets/images/onboarding5.jpg',
      'title': 'Your circle, closer.',
      'description': 'Join events, make friends, and grow your community.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _nextPage();
            }
          });

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
        _animationController.reset();
        _animationController.forward();
        _textAnimationController.reset();
        _textAnimationController.forward();
      }
    });

    _animationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        _pages.length - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  // Image section with left/right tap gestures and rounded bottom
                  SizedBox(
                    height: size.height * 0.72,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          // child: Image.network(
                          //   _pages[index]['image']!,
                          //   fit: BoxFit.cover,
                          //   width: double.infinity,
                          //   height: double.infinity,
                          //   loadingBuilder: (context, child, loadingProgress) {
                          //     if (loadingProgress == null) return child;
                          //     return Container(
                          //       decoration: BoxDecoration(
                          //         color: Colors.grey.shade200,
                          //         borderRadius: const BorderRadius.only(
                          //           bottomLeft: Radius.circular(24),
                          //           bottomRight: Radius.circular(24),
                          //         ),
                          //       ),
                          //       child: const Center(child: CircularProgressIndicator()),
                          //     );
                          //   },
                          // ),
                          child: Image.asset(
                            _pages[index]['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        // Left half tap for previous
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: size.width * 0.5,
                          child: GestureDetector(
                            onTap: _previousPage,
                            behavior: HitTestBehavior.opaque,
                            // child: Container(color: Colors.transparent),
                            child: SizedBox(),
                          ),
                        ),
                        // Right half tap for next
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          width: size.width * 0.5,
                          child: GestureDetector(
                            onTap: _nextPage,
                            behavior: HitTestBehavior.opaque,
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Enhanced title with slide-up animation
                          FadeTransition(
                            opacity: _textAnimationController,
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _textAnimationController,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                              child: Text(
                                _pages[index]['title']!,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Enhanced description with fade animation
                          FadeTransition(
                            opacity: _textAnimationController,
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _textAnimationController,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                              child: Text(
                                _pages[index]['description']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  height: 1.5,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          if (index == _pages.length - 1) ...[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            // Enhanced Get Started button
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EnterEmailMobileScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 8,
                                    shadowColor: Colors.blueAccent.withOpacity(
                                      0.4,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_forward, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Get Started',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Enhanced progress indicators
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildProgressIndicator(index),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int index) {
    double progress = 0.0;
    if (index < _currentPage) {
      progress = 1.0;
    } else if (index == _currentPage) {
      progress = _animationController.value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: index == _currentPage ? 68 : 40,
        height: 6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            minHeight: 4.0,
          ),
        ),
      ),
    );
  }
}
