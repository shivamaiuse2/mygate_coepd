import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  String _selectedCategory = 'All';
  int _selectedAnnouncement = -1;

  final List<String> _categories = ['All', 'Important', 'Event', 'Amenity', 'Maintenance'];

  final List<Map<String, dynamic>> _announcements = [
    {
      'id': 1,
      'title': 'Water Supply Interruption',
      'date': 'Today, 10:00 AM - 2:00 PM',
      'description':
          'Due to maintenance work, there will be a water supply interruption from 10:00 AM to 2:00 PM today. We apologize for any inconvenience caused.',
      'image':
          'https://images.unsplash.com/photo-1536566482680-fca31930a0bd?auto=format&fit=crop&q=80&w=400&h=300',
      'tag': 'Important',
      'tagColor': Colors.red,
    },
    {
      'id': 2,
      'title': 'Annual General Meeting',
      'date': 'May 15, 6:00 PM',
      'description':
          'All residents are requested to attend the Annual General Meeting on May 15th at 6:00 PM in the community hall. Please bring your ID cards.',
      'image':
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&q=80&w=400&h=300',
      'tag': 'Event',
      'tagColor': Colors.blue,
    },
    {
      'id': 3,
      'title': 'New Gym Equipment',
      'date': 'Starting Next Week',
      'description':
          'We have installed new equipment in the community gym. The gym will be closed for one day for final setup and testing.',
      'image':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=400&h=300',
      'tag': 'Amenity',
      'tagColor': Colors.green,
    },
    {
      'id': 4,
      'title': 'Elevator Maintenance',
      'date': 'May 20, 9:00 AM - 5:00 PM',
      'description':
          'Elevator maintenance will be performed on May 20th from 9:00 AM to 5:00 PM. During this time, the elevator will be out of service.',
      'image':
          'https://images.unsplash.com/photo-1581091226033-d5c48150dbaa?auto=format&fit=crop&q=80&w=400&h=300',
      'tag': 'Maintenance',
      'tagColor': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAnnouncements = _selectedCategory == 'All'
        ? _announcements
        : _announcements
            .where((announcement) => announcement['tag'] == _selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Announcements List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredAnnouncements.length,
              itemBuilder: (context, index) {
                final announcement = filteredAnnouncements[index];
                final isSelected = _selectedAnnouncement == announcement['id'];
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedAnnouncement = 
                    _selectedAnnouncement == announcement['id'] ? -1 : announcement['id']),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: announcement['image'],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: announcement['tagColor'],
                                      borderRadius: BorderRadius.circular(12),
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
                                  Text(
                                    announcement['date'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                announcement['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (isSelected)
                                Text(
                                  announcement['description'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}