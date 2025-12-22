import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_event.dart';
import 'package:mygate_coepd/blocs/auth/auth_state.dart';
import 'package:mygate_coepd/models/user.dart';
import 'package:mygate_coepd/screens/resident/dashboard_screen.dart';
import 'package:mygate_coepd/screens/resident/visitor_management_new.dart';
import 'package:mygate_coepd/screens/resident/visitor_management_screen.dart';
import 'package:mygate_coepd/screens/resident/service_requests_screen.dart';
import 'package:mygate_coepd/screens/resident/bills_payments_screen.dart';
import 'package:mygate_coepd/screens/resident/community_screen.dart';
import 'package:mygate_coepd/screens/society/events_and_community_screen.dart';
import 'package:mygate_coepd/theme/app_theme.dart';

class ResidentMainScreen extends StatefulWidget {
  final int initialTabIndex;

  const ResidentMainScreen({super.key, this.initialTabIndex = 0});

  @override
  State<ResidentMainScreen> createState() => _ResidentMainScreenState();
}

class _ResidentMainScreenState extends State<ResidentMainScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Add the missing variables for visitor management functionality
  bool _isBulkMode = false;
  final Set<int> _selectedVisitors = {};

  final List<Widget> _screens = [
    const ResidentDashboardScreen(),
    // const VisitorManagementScreen(),
    const VisitorManagementScreenNew(),
    const ServiceRequestsScreen(),
    const BillsPaymentsScreen(),
    // const CommunityScreen(),
    const EventsAndCommunityScreen(),
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
      icon: Icons.checklist_outlined,
      activeIcon: Icons.checklist_rounded,
      label: 'Services',
      badgeCount: 2,
    ),
    NavItem(
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
      label: 'Bills',
      badgeCount: 1,
    ),
    NavItem(
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups,
      label: 'Community',
      badgeCount: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
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

    if (_currentIndex >= _screens.length) {
      _currentIndex = _screens.length - 1;
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(_navItems[_currentIndex].label),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              actions: _buildAppBarActions(user),
            ),
            drawer: _buildDrawer(context, user),
            body: _screens[_currentIndex],
            bottomNavigationBar: _buildPremiumNavigationBar(
              theme,
              primaryColor,
            ),
          );
        }

        // Loading State
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60.w,
                  height: 60.w,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                        strokeWidth: 4.w,
                      ),
                      Center(
                        child: Icon(
                          Icons.security_rounded,
                          color: theme.primaryColor,
                          size: 28.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Loading...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, User user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppTheme.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : null,
                  child: user.profileImage == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                SizedBox(height: 10.h),
                Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Resident',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          _drawerTile(Icons.home, 'Home', 0),
          _drawerTile(Icons.people, 'Visitors', 1),
          _drawerTile(Icons.checklist, 'Services', 2),
          _drawerTile(Icons.account_balance_wallet, 'Bills & Payments', 3),
          _drawerTile(Icons.groups, 'Community & Events', 4),
          const Divider(),
          _drawerTile(
            Icons.settings,
            'Settings',
            null,
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings screen will be implemented'),
                ),
              );
            },
          ),
          _drawerTile(
            Icons.help,
            'Help & Support',
            null,
            onTap: () {
              Navigator.pop(context);
              _showHelpDialog(context);
            },
          ),
          _drawerTile(
            Icons.logout,
            'Logout',
            null,
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  ListTile _drawerTile(
    IconData icon,
    String title,
    int? index, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 26.sp),
      title: Text(title, style: TextStyle(fontSize: 15.sp)),
      selected: index != null && _currentIndex == index,
      selectedTileColor: Colors.grey.withValues(alpha: 0.1),
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
            if (index != null) _onTabTapped(index);
          },
    );
  }

  Widget _buildPremiumNavigationBar(ThemeData theme, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20.r,
            offset: Offset(0, -5.h),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: Container(
          height: 80.h + MediaQuery.of(context).padding.bottom,
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

  List<Widget> _buildAppBarActions(User user) {
    switch (_currentIndex) {
      case 0:
        return [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/announcements'),
            icon: Icon(Icons.notifications, size: 26.sp),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: CircleAvatar(
              radius: 18.r,
              backgroundImage: user.profileImage != null
                  ? NetworkImage(user.profileImage!)
                  : null,
              child: user.profileImage == null
                  ? Icon(
                      Icons.person,
                      size: 20.sp,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 16.w),
        ];
      case 1:
        return [
          IconButton(
            icon: Icon(
              _isBulkMode ? Icons.close : Icons.checklist,
              color: Colors.white,
              size: 24,
            ),
            onPressed: _toggleBulkMode,
          ),
          if (_isBulkMode && _selectedVisitors.isNotEmpty)
            IconButton(
              icon: Icon(Icons.check_circle, color: Colors.white, size: 24),
              onPressed: _bulkApprove,
            ),
        ];
      case 2:
      case 3:
        return [
          IconButton(
            icon: Icon(Icons.search, size: 26.sp),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality would open here'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, size: 26.sp),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter functionality would open here'),
                ),
              );
            },
          ),
        ];
      case 4:
        return [
          IconButton(
            icon: Icon(Icons.search, size: 26.sp),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality would open here'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add, size: 28.sp),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Create post functionality would open here'),
                ),
              );
            },
          ),
        ];
      default:
        return [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/announcements'),
            icon: Icon(Icons.notifications, size: 26.sp),
          ),
        ];
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Help & Support', style: TextStyle(fontSize: 18.sp)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MyGateBell App Help', style: TextStyle(fontSize: 15.sp)),
              SizedBox(height: 12.h),
              Text(
                'For technical support, please contact:',
                style: TextStyle(fontSize: 14.sp),
              ),
              Text('support@mygatebell.com', style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 12.h),
              Text(
                'For general inquiries, please contact:',
                style: TextStyle(fontSize: 14.sp),
              ),
              Text('info@mygatebell.com', style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 12.h),
              Text('Phone: +91 9876543210', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('OK', style: TextStyle(fontSize: 15.sp)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Logout', style: TextStyle(fontSize: 18.sp)),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 15.sp),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(fontSize: 15.sp)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 15.sp, color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/auth', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  // Add the missing methods for visitor management functionality
  void _toggleBulkMode() {
    setState(() {
      _isBulkMode = !_isBulkMode;
      if (!_isBulkMode) {
        _selectedVisitors.clear();
      }
    });
  }

  void _bulkApprove() {
    // Placeholder implementation - in a real app this would communicate with the visitor screen
    setState(() {
      _selectedVisitors.clear();
      _isBulkMode = false;
    });
    
    // Show a snackbar to indicate the action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bulk approve functionality would be implemented here'),
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
        splashColor: primaryColor.withValues(alpha: 0.1),
        highlightColor: primaryColor.withValues(alpha: 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  ScaleTransition(
                    scale: animation,
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withValues(alpha: 0.15),
                            primaryColor.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: isSelected ? 28.sp : 26.sp,
                  color: isSelected ? primaryColor : Colors.grey.shade600,
                ),
                if (item.badgeCount > 0)
                  Positioned(
                    right: -2.w,
                    top: -4.h,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18.w,
                        minHeight: 18.w,
                      ),
                      child: Text(
                        item.badgeCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (isSelected)
                  Positioned(
                    top: -2.h,
                    child: ScaleTransition(
                      scale: animation,
                      child: Container(
                        width: 24.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()..scale(isSelected ? 1.0 : 0.9),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 12.sp,
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
    );
  }
}
