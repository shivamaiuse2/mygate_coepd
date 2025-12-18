import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_state.dart';
import 'package:mygate_coepd/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResidentDashboardScreen extends StatefulWidget {
  const ResidentDashboardScreen({super.key});

  @override
  State<ResidentDashboardScreen> createState() =>
      _ResidentDashboardScreenState();
}

class _ResidentDashboardScreenState extends State<ResidentDashboardScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _quickStats = [
    {
      'label': 'Visitors',
      'value': 3,
      'icon': Icons.people,
      'color': Colors.blue,
    },
    {
      'label': 'Bills Due',
      'value': 2,
      'icon': Icons.credit_card,
      'color': Colors.orange,
    },
    {
      'label': 'Updates',
      'value': 4,
      'icon': Icons.notifications,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> _announcements = [
    {
      'title': 'Water Supply Interruption',
      'date': 'Today, 10:00 AM - 2:00 PM',
      'description':
          'Due to maintenance work, there will be a water supply interruption.',
      'image':
          'https://images.unsplash.com/photo-1536566482680-fca31930a0bd?auto=format&fit=crop&q=80&w=400&h=300',
      'tag': 'Important',
      'tagColor': Colors.red,
    },
    {
      'title': 'Annual General Meeting',
      'date': 'May 15, 6:00 PM',
      'description':
          'All residents are requested to attend the Annual General Meeting.',
      'image':
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&q=80&w=400&h=300',
      'tag': 'Event',
      'tagColor': Colors.blue,
    },
    {
      'title': 'New Gym Equipment',
      'date': 'Starting Next Week',
      'description': 'We have installed new equipment in the community gym.',
      'image':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=400&h=300',
      'tag': 'Amenity',
      'tagColor': Colors.green,
    },
  ];

  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'Weekend Pool Party',
      'date': 'Saturday, 4:00 PM',
      'attendees': 24,
      'image':
          'https://plus.unsplash.com/premium_photo-1682681906293-2113d2e6cc82?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8cG9vbCUyMHBhcnR5fGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=600',
    },
    {
      'title': 'Yoga in the Park',
      'date': 'Sunday, 7:00 AM',
      'attendees': 12,
      'image':
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&q=80&w=400&h=300',
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.people,
      'label': 'Visitors',
      'color': Colors.blue,
      'screen': 'visitors',
    },
    {
      'icon': Icons.checklist,
      'label': 'Services',
      'color': Colors.green,
      'screen': 'services',
    },
    {
      'icon': Icons.credit_card,
      'label': 'Bills',
      'color': Colors.orange,
      'screen': 'bills',
    },
    {
      'icon': Icons.calendar_today,
      'label': 'Amenities',
      'color': Colors.purple,
      'screen': 'amenities',
    },
    {
      'icon': Icons.chat,
      'label': 'Community',
      'color': Colors.indigo,
      'screen': 'community',
    },
    {
      'icon': Icons.notifications,
      'label': 'Alerts',
      'color': Colors.red,
      'screen': 'announcements',
    },
    {
      'icon': Icons.person,
      'label': 'Profile',
      'color': Colors.grey,
      'screen': 'profile',
    },
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start animations after a small delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            body: Column(
              children: <Widget>[
                // getAppBarUI(user),
                Expanded(
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate((
                                BuildContext context,
                                int index,
                              ) {
                                return Column(
                                  children: <Widget>[getQuickStatsUI()],
                                );
                              }, childCount: 1),
                            ),
                          ];
                        },
                    body: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          getAnnouncementsSection(),
                          getQuickActionsSection(),
                          getUpcomingEventsSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: ScaleTransition(
              scale: _fadeAnimation,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/services');
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.add, 
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget getAppBarUI(User user) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.2),
            offset: Offset(0, 2.h),
            blurRadius: 4.w,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      user.name,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/announcements');
                },
                icon: Icon(Icons.notifications, size: 24.sp),
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            SizedBox(width: 12.w),
            FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundImage: user.profileImage != null
                      ? CachedNetworkImageProvider(user.profileImage!)
                      : null,
                  child: user.profileImage == null
                      ? Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                          size: 24.sp,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getQuickStatsUI() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 6.w,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _quickStats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
    
          return Expanded(
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    0.1 * index,
                    0.5 + (0.1 * index),
                    curve: Curves.elasticOut,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigate to respective screens based on stat type
                  switch (stat['label']) {
                    case 'Visitors':
                      Navigator.pushNamed(context, '/visitors');
                      break;
                    case 'Bills Due':
                      Navigator.pushNamed(context, '/bills');
                      break;
                    case 'Updates':
                      Navigator.pushNamed(context, '/announcements');
                      break;
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).cardTheme.color!,
                          Theme.of(context).cardTheme.color!.withValues(alpha: 0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: stat['color'].withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Icon(
                              stat['icon'] as IconData,
                              color: stat['color'],
                              size: 28.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            stat['label'] as String,
                            style: TextStyle(
                              color: stat['color'],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${stat['value']}',
                            style: TextStyle(
                              color: stat['color'],
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).primaryColor,
      ),
      labelColor: Theme.of(context).colorScheme.onPrimary,
      unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
      tabs: [
        Tab(
          child: Text(
            'Dashboard', 
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
        Tab(
          child: Text(
            'Activity', 
            style: TextStyle(
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget getAnnouncementsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Updates',
                style: TextStyle(
                  fontSize: 18.sp, 
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/announcements');
                },
                child: Text(
                  'View All', 
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                final int count = _announcements.length;
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (1 / count) * index,
                          1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                      ),
                    );

                final announcement = _announcements[index];
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Opacity(
                      opacity: animation.value,
                      child: Transform(
                        transform: Matrix4.translationValues(
                          0.0,
                          50 * (1.0 - animation.value),
                          0.0,
                        ),
                        child: Container(
                          width: 280.w,
                          margin: EdgeInsets.only(right: 15.w),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: announcement['image'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Theme.of(context).brightness == Brightness.dark
                                              ? Colors.black.withValues(alpha: 0.7)
                                              : Colors.black.withValues(alpha: 0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 15.h,
                                    left: 15.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: announcement['tagColor'],
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: Text(
                                        announcement['tag'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15.h,
                                    left: 15.w,
                                    right: 15.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          announcement['title'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          announcement['date'],
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getQuickActionsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18.sp, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate optimal cross axis count based on screen width
              final double itemWidth = 80.w; // Base width for each item
              final int crossAxisCount = (constraints.maxWidth / itemWidth)
                  .floor()
                  .clamp(3, 5);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.9,
                ),
                itemCount: _quickActions.length,
                itemBuilder: (context, index) {
                  final int count = _quickActions.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            (1 / count) * index,
                            1.0,
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      );

                  final action = _quickActions[index];
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) {
                      return Opacity(
                        opacity: animation.value,
                        child: Transform(
                          transform: Matrix4.translationValues(
                            0.0,
                            30 * (1.0 - animation.value),
                            0.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate within the ResidentMainScreen instead of pushing new screens
                              switch (action['screen']) {
                                case 'visitors':
                                  // We need to access the parent ResidentMainScreen to change tabs
                                  Navigator.pushNamed(
                                    context,
                                    '/resident-main/visitors',
                                  );
                                  break;
                                case 'services':
                                  Navigator.pushNamed(
                                    context,
                                    '/resident-main/services',
                                  );
                                  break;
                                case 'bills':
                                  Navigator.pushNamed(
                                    context,
                                    '/resident-main/bills',
                                  );
                                  break;
                                case 'amenities':
                                  Navigator.pushNamed(context, '/amenities');
                                  break;
                                case 'community':
                                  Navigator.pushNamed(
                                    context,
                                    '/resident-main/community',
                                  );
                                  break;
                                case 'announcements':
                                  Navigator.pushNamed(
                                    context,
                                    '/announcements',
                                  );
                                  break;
                                case 'profile':
                                  Navigator.pushNamed(context, '/profile');
                                  break;
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15.w),
                                  decoration: BoxDecoration(
                                    color: action['color'].withValues(
                                      alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Icon(
                                    action['icon'],
                                    color: action['color'],
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  action['label'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getUpcomingEventsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18.sp, 
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/announcements');
                },
                child: Text(
                  'View All', 
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _upcomingEvents.length,
            itemBuilder: (context, index) {
              final int count = _upcomingEvents.length;
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        (1 / count) * index,
                        1.0,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  );

              final event = _upcomingEvents[index];
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  return Opacity(
                    opacity: animation.value,
                    child: Transform(
                      transform: Matrix4.translationValues(
                        0.0,
                        30 * (1.0 - animation.value),
                        0.0,
                      ),
                      child: Card(
                        margin: EdgeInsets.only(bottom: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 15.w),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                bottomLeft: Radius.circular(16.r),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: event['image'],
                                width: 100.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(15.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event['title'],
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).textTheme.titleMedium?.color,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 14.sp,
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          event['date'],
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Theme.of(context).textTheme.bodySmall?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 10.r,
                                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.grey[600]
                                                  : Colors.grey[300],
                                            ),
                                            SizedBox(width: 3.w),
                                            CircleAvatar(
                                              radius: 10.r,
                                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.grey[600]
                                                  : Colors.grey[300],
                                            ),
                                            SizedBox(width: 3.w),
                                            CircleAvatar(
                                              radius: 10.r,
                                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.grey[600]
                                                  : Colors.grey[300],
                                            ),
                                            SizedBox(width: 5.w),
                                            Container(
                                              padding: EdgeInsets.all(3.w),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Text(
                                                '+${event['attendees']}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          child: Text(
                                            'RSVP',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
