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

class _ResidentMainScreenState extends State<ResidentMainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const ResidentDashboardScreen(),
    const VisitorManagementScreen(),
    const AnnouncementsScreen(),
    const ServiceRequestsScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            body: _screens[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Visitors',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Updates',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.checklist),
                  label: 'Services',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}