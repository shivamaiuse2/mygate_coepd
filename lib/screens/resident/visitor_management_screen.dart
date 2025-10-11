import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VisitorManagementScreen extends StatefulWidget {
  const VisitorManagementScreen({super.key});

  @override
  State<VisitorManagementScreen> createState() => _VisitorManagementScreenState();
}

class _VisitorManagementScreenState extends State<VisitorManagementScreen> {
  String _visitorView = 'upcoming';
  bool _showAddVisitor = false;

  final List<Map<String, dynamic>> _upcomingVisitors = [
    {
      'id': 1,
      'name': 'John Smith',
      'purpose': 'Delivery',
      'date': 'Today, 2:00 PM',
      'status': 'approved',
      'photo':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=100&h=100'
    },
    {
      'id': 2,
      'name': 'Sarah Johnson',
      'purpose': 'Guest',
      'date': 'Today, 5:30 PM',
      'status': 'pending',
      'photo':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100&h=100'
    },
    {
      'id': 3,
      'name': 'Mike Williams',
      'purpose': 'Maintenance',
      'date': 'Tomorrow, 10:00 AM',
      'status': 'approved',
      'photo':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100&h=100'
    },
  ];

  final List<Map<String, dynamic>> _visitorHistory = [
    {
      'id': 4,
      'name': 'David Brown',
      'purpose': 'Guest',
      'date': 'Yesterday, 7:00 PM',
      'entryTime': '7:02 PM',
      'exitTime': '9:45 PM',
      'photo':
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=100&h=100'
    },
    {
      'id': 5,
      'name': 'Emma Davis',
      'purpose': 'Delivery',
      'date': 'May 10, 11:30 AM',
      'entryTime': '11:32 AM',
      'exitTime': '11:40 AM',
      'photo':
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&q=80&w=100&h=100'
    },
  ];

  Widget _renderVisitorStatus(String status) {
    switch (status) {
      case 'approved':
        return Row(
          children: [
            Icon(Icons.check_circle, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            const Text(
              'Approved',
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        );
      case 'pending':
        return Row(
          children: [
            Icon(Icons.access_time, size: 14, color: Colors.orange),
            const SizedBox(width: 4),
            const Text(
              'Pending',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        );
      case 'denied':
        return Row(
          children: [
            Icon(Icons.cancel, size: 14, color: Colors.red),
            const SizedBox(width: 4),
            const Text(
              'Denied',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search visitors...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _visitorView = 'upcoming'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _visitorView == 'upcoming'
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardTheme.color,
                    foregroundColor: _visitorView == 'upcoming'
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  child: const Text('Upcoming'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => _visitorView = 'history'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _visitorView == 'history'
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardTheme.color,
                    foregroundColor: _visitorView == 'history'
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  child: const Text('History'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _visitorView == 'upcoming'
                ? _upcomingVisitors.isEmpty
                    ? _buildEmptyState()
                    : _buildUpcomingVisitors()
                : _buildVisitorHistory(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _showAddVisitor = true),
        backgroundColor: const Color(0xFF006D77),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.people,
              size: 50,
              color: Color(0xFF006D77),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No upcoming visitors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'You don\'t have any visitors scheduled',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() => _showAddVisitor = true),
            child: const Text('Add Visitor'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingVisitors() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _upcomingVisitors.length,
      itemBuilder: (context, index) {
        final visitor = _upcomingVisitors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(visitor['photo']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitor['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        visitor['purpose'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        visitor['date'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _renderVisitorStatus(visitor['status']),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.qr_code),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisitorHistory() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _visitorHistory.length,
      itemBuilder: (context, index) {
        final visitor = _visitorHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(visitor['photo']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitor['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        visitor['purpose'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        visitor['date'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'In: ${visitor['entryTime']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Out: ${visitor['exitTime']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}