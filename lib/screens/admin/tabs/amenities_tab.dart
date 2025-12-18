import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AmenitiesTab extends StatelessWidget {
  const AmenitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> amenitiesStats = [
      {
        'title': 'Total Amenities',
        'value': '12',
        'icon': Icons.pool,
        'color': Colors.blue,
      },
      {
        'title': 'Booked Today',
        'value': '8',
        'icon': Icons.event_available,
        'color': Colors.green,
      },
      {
        'title': 'Pending Requests',
        'value': '3',
        'icon': Icons.pending_actions,
        'color': Colors.orange,
      },
      {
        'title': 'Maintenance',
        'value': '2',
        'icon': Icons.build,
        'color': Colors.red,
      },
    ];

    final List<Map<String, dynamic>> amenitiesList = [
      {
        'id': 1,
        'name': 'Swimming Pool',
        'icon': Icons.pool,
        'bookings': '24',
        'status': 'Available',
        'statusColor': Colors.green,
      },
      {
        'id': 2,
        'name': 'Gym',
        'icon': Icons.fitness_center,
        'bookings': '18',
        'status': 'Available',
        'statusColor': Colors.green,
      },
      {
        'id': 3,
        'name': 'Club House',
        'icon': Icons.house,
        'bookings': '12',
        'status': 'Maintenance',
        'statusColor': Colors.red,
      },
      {
        'id': 4,
        'name': 'Tennis Court',
        'icon': Icons.sports_tennis,
        'bookings': '9',
        'status': 'Available',
        'statusColor': Colors.green,
      },
      {
        'id': 5,
        'name': 'Play Area',
        'icon': Icons.child_friendly,
        'bookings': '15',
        'status': 'Available',
        'statusColor': Colors.green,
      },
    ];

    final List<Map<String, dynamic>> quickActions = [
      {'icon': Icons.add, 'label': 'Add Amenity', 'route': '/add-amenity'},
      {'icon': Icons.search, 'label': 'Search', 'route': '/search-amenities'},
      {'icon': Icons.event, 'label': 'Bookings', 'route': '/amenity-bookings'},
      {'icon': Icons.bar_chart, 'label': 'Reports', 'route': '/amenity-reports'},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // Stats Cards
          Padding(
            padding: EdgeInsets.all(20.r),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
              ),
              itemCount: amenitiesStats.length,
              itemBuilder: (context, index) {
                final stat = amenitiesStats[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: stat['color'].withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                stat['icon'],
                                color: stat['color'],
                                size: 24.r,
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          stat['title'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          stat['value'],
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Quick Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: quickActions.length,
                  itemBuilder: (context, index) {
                    final action = quickActions[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate to the respective action
                            if (action['route'] != null) {
                              Navigator.pushNamed(context, action['route']);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(15.r),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 5.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                            child: Icon(
                              action['icon'],
                              color: Theme.of(context).primaryColor,
                              size: 28.r,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          action['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          // Amenities List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amenities List',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${amenitiesList.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: amenitiesList.length,
                  itemBuilder: (context, index) {
                    final amenity = amenitiesList[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(15.r),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15.r),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                amenity['icon'],
                                color: Theme.of(context).primaryColor,
                                size: 32.r,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    amenity['name'],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    '${amenity['bookings']} bookings this week',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: amenity['statusColor']
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    amenity['status'],
                                    style: TextStyle(
                                      color: amenity['statusColor'],
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // Edit amenity
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20.r,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // View details
                                      },
                                      icon: Icon(
                                        Icons.visibility,
                                        size: 20.r,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 80.h), // Space for bottom bar
        ],
      ),
    );
  }
}