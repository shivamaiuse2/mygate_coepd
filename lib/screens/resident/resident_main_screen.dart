import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_state.dart';
import 'package:mygate_coepd/screens/resident/dashboard_screen.dart';
import 'package:mygate_coepd/screens/resident/visitor_management_screen.dart';
import 'package:mygate_coepd/screens/resident/announcements_screen.dart';
import 'package:mygate_coepd/screens/resident/service_requests_screen.dart';
import 'package:mygate_coepd/screens/resident/bills_payments_screen.dart';
import 'package:mygate_coepd/screens/resident/amenity_booking_screen.dart';
import 'package:mygate_coepd/screens/resident/community_screen.dart';
import 'package:mygate_coepd/screens/resident/profile_screen.dart';

class ResidentMainScreen extends StatefulWidget {
  const ResidentMainScreen({super.key});

  @override
  State<ResidentMainScreen> createState() => _ResidentMainScreenState();
}

class _ResidentMainScreenState extends State<ResidentMainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  final List<Widget> _screens = [
    const ResidentDashboardScreen(),
    const VisitorManagementScreen(),
    const AnnouncementsScreen(),
    const ServiceRequestsScreen(),
    const ProfileScreen(),
  ];

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      badgeCount: 0,
    ),
    NavItem(
      icon: Icons.people_outlined,
      activeIcon: Icons.people_rounded,
      label: 'Visitors',
      badgeCount: 3,
    ),
    NavItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications_rounded,
      label: 'Updates',
      badgeCount: 7,
    ),
    NavItem(
      icon: Icons.checklist_outlined,
      activeIcon: Icons.checklist_rounded,
      label: 'Services',
      badgeCount: 2,
    ),
    NavItem(
      icon: Icons.person_outlined,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      badgeCount: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            body: _screens[_currentIndex],
            bottomNavigationBar: _buildPremiumNavigationBar(theme, primaryColor),
          );
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                        strokeWidth: 3,
                      ),
                      Center(
                        child: Icon(
                          Icons.security_rounded,
                          color: theme.primaryColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumNavigationBar(ThemeData theme, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          height: 80 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = _currentIndex == index;
              
              return Expanded(
                child: _BuildAnimatedNavItem(
                  animation: _animation,
                  isSelected: isSelected,
                  item: item,
                  primaryColor: primaryColor,
                  onTap: () => _onTabTapped(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badgeCount;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.badgeCount,
  });
}

class _BuildAnimatedNavItem extends StatelessWidget {
  final Animation<double> animation;
  final bool isSelected;
  final NavItem item;
  final Color primaryColor;
  final VoidCallback onTap;

  const _BuildAnimatedNavItem({
    required this.animation,
    required this.isSelected,
    required this.item,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: primaryColor.withOpacity(0.1),
        highlightColor: primaryColor.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animation
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background highlight for selected item
                  if (isSelected)
                    ScaleTransition(
                      scale: animation,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor.withOpacity(0.15),
                              primaryColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  
                  // Icon
                  Icon(
                    isSelected ? item.activeIcon : item.icon,
                    size: isSelected ? 26 : 24,
                    color: isSelected ? primaryColor : Colors.grey.shade600,
                  ),
                  
                  // Active indicator dot
                  if (isSelected)
                    Positioned(
                      top: -1,
                      child: ScaleTransition(
                        scale: animation,
                        child: Container(
                          width: 20,
                          height: 4,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            // shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 2),
              
              // Label with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(isSelected ? 1.0 : 0.9),
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? primaryColor : Colors.grey.shade600,
                    letterSpacing: isSelected ? 0.5 : 0.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
// import 'package:mygate_coepd/blocs/auth/auth_state.dart';
// import 'package:mygate_coepd/screens/resident/dashboard_screen.dart';
// import 'package:mygate_coepd/screens/resident/visitor_management_screen.dart';
// import 'package:mygate_coepd/screens/resident/announcements_screen.dart';
// import 'package:mygate_coepd/screens/resident/service_requests_screen.dart';
// import 'package:mygate_coepd/screens/resident/bills_payments_screen.dart';
// import 'package:mygate_coepd/screens/resident/amenity_booking_screen.dart';
// import 'package:mygate_coepd/screens/resident/community_screen.dart';
// import 'package:mygate_coepd/screens/resident/profile_screen.dart';

// class ResidentMainScreen extends StatefulWidget {
//   const ResidentMainScreen({super.key});

//   @override
//   State<ResidentMainScreen> createState() => _ResidentMainScreenState();
// }

// class _ResidentMainScreenState extends State<ResidentMainScreen> {
//   int _currentIndex = 0;
  
//   final List<Widget> _screens = [
//     const ResidentDashboardScreen(),
//     const VisitorManagementScreen(),
//     const AnnouncementsScreen(),
//     const ServiceRequestsScreen(),
//     const ProfileScreen(),
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is Authenticated) {
//           return Scaffold(
//             body: _screens[_currentIndex],
//             bottomNavigationBar: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               currentIndex: _currentIndex,
//               onTap: _onTabTapped,
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home),
//                   label: 'Home',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.people),
//                   label: 'Visitors',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.notifications),
//                   label: 'Updates',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.checklist),
//                   label: 'Services',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person),
//                   label: 'Profile',
//                 ),
//               ],
//             ),
//           );
//         }
//         return const Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
// }