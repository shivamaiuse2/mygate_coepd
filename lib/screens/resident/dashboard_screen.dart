import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_state.dart';
import 'package:mygate_coepd/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ResidentDashboardScreen extends StatefulWidget {
  const ResidentDashboardScreen({super.key});

  @override
  State<ResidentDashboardScreen> createState() =>
      _ResidentDashboardScreenState();
}

class _ResidentDashboardScreenState extends State<ResidentDashboardScreen> {
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
          'https://images.unsplash.com/photo-1536745511380-1e5b5a1f8c5e?auto=format&fit=crop&q=80&w=400&h=300',
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
      'label': 'Chat',
      'color': Colors.indigo,
      'screen': 'community',
    },
    {
      'icon': Icons.shopping_cart,
      'label': 'Marketplace',
      'color': Colors.pink,
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              actions: [
                IconButton(
                  onPressed: () {
                    // Notification action
                  },
                  icon: const Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () {
                    // Profile action
                  },
                  icon: CircleAvatar(
                    backgroundImage: user.profileImage != null
                        ? CachedNetworkImageProvider(user.profileImage!)
                        : null,
                    child: user.profileImage == null
                        ? Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Welcome section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome back',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  user.name.split(' ')[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Notification action
                                  },
                                  icon: const Icon(Icons.notifications),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Profile action
                                  },
                                  icon: CircleAvatar(
                                    backgroundImage: user.profileImage != null
                                        ? CachedNetworkImageProvider(
                                            user.profileImage!,
                                          )
                                        : null,
                                    child: user.profileImage == null
                                        ? Icon(
                                            Icons.person,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        // Quick stats
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _quickStats.length,
                            itemBuilder: (context, index) {
                              final stat = _quickStats[index];
                              return Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(stat['icon'], color: Colors.white),
                                    const SizedBox(height: 5),
                                    Text(
                                      stat['label'],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${stat['value']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Announcements
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Latest Updates',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to announcements screen
                                Navigator.pushNamed(context, '/announcements');
                              },
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _announcements.length,
                            itemBuilder: (context, index) {
                              final announcement = _announcements[index];
                              return Container(
                                width: 280,
                                margin: const EdgeInsets.only(right: 15),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: announcement['image'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black54,
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 15,
                                          left: 15,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: announcement['tagColor'],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              announcement['tag'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 15,
                                          left: 15,
                                          right: 15,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                announcement['title'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                announcement['date'],
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                crossAxisCount: 4,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                          itemCount: _quickActions.length,
                          itemBuilder: (context, index) {
                            final action = _quickActions[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the appropriate screen
                                switch (action['screen']) {
                                  case 'visitors':
                                    Navigator.pushNamed(context, '/visitors');
                                    break;
                                  case 'services':
                                    Navigator.pushNamed(context, '/services');
                                    break;
                                  case 'bills':
                                    Navigator.pushNamed(context, '/bills');
                                    break;
                                  case 'amenities':
                                    Navigator.pushNamed(context, '/amenities');
                                    break;
                                  case 'community':
                                    Navigator.pushNamed(context, '/community');
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
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: action['color'].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      action['icon'],
                                      color: action['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    action['label'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Upcoming Events
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Upcoming Events',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to announcements screen
                                Navigator.pushNamed(context, '/announcements');
                              },
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _upcomingEvents.length,
                          itemBuilder: (context, index) {
                            final event = _upcomingEvents[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: event['image'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['title'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                event['date'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  const CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  const CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '+${event['attendees']}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  // RSVP action
                                                },
                                                child: const Text('RSVP'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Navigate to service requests screen
                Navigator.pushNamed(context, '/services');
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
