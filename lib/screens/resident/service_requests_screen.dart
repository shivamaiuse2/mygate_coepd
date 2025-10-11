import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServiceRequestsScreen extends StatefulWidget {
  const ServiceRequestsScreen({super.key});

  @override
  State<ServiceRequestsScreen> createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends State<ServiceRequestsScreen> {
  String _selectedTab = 'requests';
  bool _showNewRequest = false;

  final List<Map<String, dynamic>> _serviceCategories = [
    {
      'id': 1,
      'name': 'Plumbing',
      'icon': Icons.water_damage,
      'color': Colors.blue,
    },
    {
      'id': 2,
      'name': 'Electrical',
      'icon': Icons.electrical_services,
      'color': Colors.orange,
    },
    {
      'id': 3,
      'name': 'Carpentry',
      'icon': Icons.construction,
      'color': Colors.brown,
    },
    {
      'id': 4,
      'name': 'Cleaning',
      'icon': Icons.cleaning_services,
      'color': Colors.green,
    },
    {
      'id': 5,
      'name': 'Security',
      'icon': Icons.security,
      'color': Colors.red,
    },
    {
      'id': 6,
      'name': 'Other',
      'icon': Icons.miscellaneous_services,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> _activeRequests = [
    {
      'id': 1,
      'title': 'Leaking Tap in Kitchen',
      'category': 'Plumbing',
      'status': 'In Progress',
      'date': 'May 10, 2023',
      'assignedTo': 'Raj Kumar',
      'image':
          'https://images.unsplash.com/photo-1584432411103-09445f0b0d7d?auto=format&fit=crop&q=80&w=100&h=100',
    },
    {
      'id': 2,
      'title': 'Faulty Light Switch',
      'category': 'Electrical',
      'status': 'Pending',
      'date': 'May 12, 2023',
      'assignedTo': 'Not Assigned',
      'image':
          'https://images.unsplash.com/photo-1594787311429-9f55e88945b3?auto=format&fit=crop&q=80&w=100&h=100',
    },
  ];

  final List<Map<String, dynamic>> _requestHistory = [
    {
      'id': 3,
      'title': 'Broken Door Handle',
      'category': 'Carpentry',
      'status': 'Completed',
      'date': 'May 5, 2023',
      'assignedTo': 'Amit Sharma',
      'image':
          'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&q=80&w=100&h=100',
    },
    {
      'id': 4,
      'title': 'Monthly Cleaning',
      'category': 'Cleaning',
      'status': 'Completed',
      'date': 'April 28, 2023',
      'assignedTo': 'CleanCo Services',
      'image':
          'https://images.unsplash.com/photo-1581578021424-ebdc007b8d4d?auto=format&fit=crop&q=80&w=100&h=100',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Requests'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Tab Selection
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedTab = 'requests'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTab == 'requests'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardTheme.color,
                      foregroundColor: _selectedTab == 'requests'
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    child: const Text('Active Requests'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedTab = 'history'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTab == 'history'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardTheme.color,
                      foregroundColor: _selectedTab == 'history'
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    child: const Text('History'),
                  ),
                ),
              ],
            ),
          ),
          // Content based on selected tab
          Expanded(
            child: _selectedTab == 'requests'
                ? _buildActiveRequests()
                : _buildRequestHistory(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _showNewRequest = true),
        backgroundColor: const Color(0xFF006D77),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActiveRequests() {
    return _activeRequests.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _activeRequests.length,
            itemBuilder: (context, index) {
              final request = _activeRequests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _getServiceColor(request['category'])
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getServiceIcon(request['category']),
                              color: _getServiceColor(request['category']),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  request['category'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(request['status']),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              request['status'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            request['date'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            request['assignedTo'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildRequestHistory() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _requestHistory.length,
      itemBuilder: (context, index) {
        final request = _requestHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getServiceColor(request['category'])
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getServiceIcon(request['category']),
                        color: _getServiceColor(request['category']),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            request['category'],
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      request['date'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      request['assignedTo'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
              Icons.checklist,
              size: 50,
              color: Color(0xFF006D77),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Active Requests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'You don\'t have any active service requests',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() => _showNewRequest = true),
            child: const Text('Create New Request'),
          ),
        ],
      ),
    );
  }

  Color _getServiceColor(String category) {
    for (var service in _serviceCategories) {
      if (service['name'] == category) {
        return service['color'];
      }
    }
    return Colors.grey;
  }

  IconData _getServiceIcon(String category) {
    for (var service in _serviceCategories) {
      if (service['name'] == category) {
        return service['icon'];
      }
    }
    return Icons.help;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}