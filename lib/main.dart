import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mygate_coepd/config/app_config.dart';
import 'package:mygate_coepd/theme/app_theme.dart';
import 'package:mygate_coepd/models/user.dart';
import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
import 'package:mygate_coepd/repositories/user_repository.dart';
import 'package:mygate_coepd/screens/splash_screen.dart';
import 'package:mygate_coepd/screens/onboarding_screen.dart';
import 'package:mygate_coepd/screens/role_selection_screen.dart';
import 'package:mygate_coepd/screens/auth_screen.dart';
import 'package:mygate_coepd/screens/resident/resident_main_screen.dart';
import 'package:mygate_coepd/screens/guard/guard_main_screen.dart';
import 'package:mygate_coepd/screens/admin/admin_main_screen.dart';
import 'package:mygate_coepd/screens/resident/visitor_management_screen.dart';
import 'package:mygate_coepd/screens/resident/announcements_screen.dart';
import 'package:mygate_coepd/screens/resident/service_requests_screen.dart';
import 'package:mygate_coepd/screens/resident/bills_payments_screen.dart';
import 'package:mygate_coepd/screens/resident/amenity_booking_screen.dart';
import 'package:mygate_coepd/screens/resident/community_screen.dart';
import 'package:mygate_coepd/screens/resident/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(FamilyMemberAdapter());
  
  // Initialize app configuration
  await AppConfig.init();
  
  runApp(const CommunityLinkApp());
}

class CommunityLinkApp extends StatelessWidget {
  const CommunityLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(userRepository: context.read<UserRepository>()),
        child: MaterialApp(
          title: 'CommunityLink',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/role-selection': (context) => const RoleSelectionScreen(),
            '/auth': (context) => const AuthScreen(),
            '/resident-main': (context) => const ResidentMainScreen(),
            '/guard-main': (context) => const GuardMainScreen(),
            '/admin-main': (context) => const AdminMainScreen(),
            '/visitors': (context) => const VisitorManagementScreen(),
            '/announcements': (context) => const AnnouncementsScreen(),
            '/services': (context) => const ServiceRequestsScreen(),
            '/bills': (context) => const BillsPaymentsScreen(),
            '/amenities': (context) => const AmenityBookingScreen(),
            '/community': (context) => const CommunityScreen(),
            '/profile': (context) => const ProfileScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
