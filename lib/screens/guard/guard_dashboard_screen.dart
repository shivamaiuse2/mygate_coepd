import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_state.dart';
import 'package:mygate_coepd/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GuardDashboardScreen extends StatefulWidget {
  const GuardDashboardScreen({super.key});

  @override
  State<GuardDashboardScreen> createState() => _GuardDashboardScreenState();
}

class _GuardDashboardScreenState extends State<GuardDashboardScreen> {
  bool _isOffline = false;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pendingVisitors = [
    {
      'id': 1,
      'name': 'Rahul Kumar',
      'type': 'Delivery',
      'flat': 'A-101',
      'time': '10:15 AM',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=100&h=100',
    },
    {
      'id': 2,
      'name': 'Priya Sharma',
      'type': 'Guest',
      'flat': 'B-203',
      'time': '10:05 AM',
      'image':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100&h=100',
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.person_add,
      'label': 'Visitor Entry',
      'color': Colors.blue,
    },
    {
      'icon': Icons.directions_car,
      'label': 'Vehicle Log',
      'color': Colors.green,
    },
    {
      'icon': Icons.notifications,
      'label': 'Alert',
      'color': Colors.red,
    },
    {
      'icon': Icons.phone,
      'label': 'Call',
      'color': Colors.purple,
    },
    {
      'icon': Icons.checklist,
      'label': 'Attendance',
      'color': Colors.orange,
    },
    {
      'icon': Icons.inventory,
      'label': 'Delivery',
      'color': Colors.teal,
    },
  ];

  final List<Map<String, dynamic>> _recentActivity = [
    {
      'icon': Icons.person,
      'title': 'Visitor Entry',
      'description': 'Amit Patel for B-404',
      'time': '10:32 AM',
      'iconBg': Colors.blue,
      'iconColor': Colors.white,
    },
    {
      'icon': Icons.directions_car,
      'title': 'Vehicle Exit',
      'description': 'MH02 AB 1234',
      'time': '10:15 AM',
      'iconBg': Colors.green,
      'iconColor': Colors.white,
    },
    {
      'icon': Icons.inventory,
      'title': 'Delivery Accepted',
      'description': 'Amazon Package for A-101',
      'time': '9:45 AM',
      'iconBg': Colors.orange,
      'iconColor': Colors.white,
    },
  ];

  void _handleApprove(int id) {
    setState(() {
      // Remove the approved visitor from the list
    });
  }

  void _handleReject(int id) {
    setState(() {
      // Remove the rejected visitor from the list
    });
  }

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
          final user = state.user;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Guard Dashboard'),
              actions: [
                IconButton(
                  onPressed: () {
                    // Notification action
                  },
                  icon: const Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () {
                    // Menu action
                  },
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Offline Banner
                      if (_isOffline)
                        Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.wifi_off, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Offline Mode',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isOffline = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Welcome Card
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: user.profileImage != null
                                      ? CachedNetworkImageProvider(
                                          user.profileImage!)
                                      : null,
                                  child: user.profileImage == null
                                      ? Icon(
                                          Icons.person,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome, ${user.name.split(' ')[0]}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${DateTime.now().weekday}, ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Quick Actions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quick Actions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                              itemCount: _quickActions.length,
                              itemBuilder: (context, index) {
                                final action = _quickActions[index];
                                return Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: action['color'],
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: action['color']
                                                .withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        action['icon'],
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      action['label'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Pending Approvals
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Pending Approvals',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${_pendingVisitors.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            if (_pendingVisitors.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _pendingVisitors.length,
                                itemBuilder: (context, index) {
                                  final visitor = _pendingVisitors[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        visitor['image']),
                                              ),
                                              const SizedBox(width: 15),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      visitor['name'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      visitor['type'],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      'For: ${visitor['flat']} • ${visitor['time']}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    _handleReject(visitor['id']);
                                                  },
                                                  child: const Text('Reject'),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    _handleApprove(visitor['id']);
                                                  },
                                                  child: const Text('Approve'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            else
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'No pending approvals',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Recent Activity
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recent Activity',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // View all activity
                                  },
                                  child: const Text('View All'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: _recentActivity
                                    .map(
                                      (activity) => ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: activity['iconBg']
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            activity['icon'],
                                            color: activity['iconColor'],
                                          ),
                                        ),
                                        title: Text(activity['title']),
                                        subtitle: Text(activity['description']),
                                        trailing: Text(
                                          activity['time'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80), // Space for bottom bar
                    ],
                  ),
                ),
                // Search Bar at bottom
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText:
                                    'Search visitors, vehicles or flats...',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                // Handle search
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  icon: Icon(Icons.checklist),
                  label: 'Attendance',
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