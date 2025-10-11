import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _posts = [
    {
      'id': 1,
      'user': {
        'name': 'John Doe',
        'avatar':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=100&h=100',
        'unit': 'A-101',
      },
      'content':
          'Just moved to our new apartment! The community here is amazing. Looking forward to meeting everyone.',
      'image':
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&q=80&w=400&h=300',
      'time': '2 hours ago',
      'likes': 24,
      'comments': 8,
    },
    {
      'id': 2,
      'user': {
        'name': 'Sarah Johnson',
        'avatar':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100&h=100',
        'unit': 'B-203',
      },
      'content':
          'Lost my cat yesterday near the community garden. Respond if you see him!',
      'time': '5 hours ago',
      'likes': 15,
      'comments': 12,
    },
    {
      'id': 3,
      'user': {
        'name': 'Mike Williams',
        'avatar':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100&h=100',
        'unit': 'C-405',
      },
      'content':
          'Community garage sale this weekend! Come check out great deals on furniture, electronics, and more.',
      'image':
          'https://images.unsplash.com/photo-1521334884684-d80222895326?auto=format&fit=crop&q=80&w=400&h=300',
      'time': '1 day ago',
      'likes': 42,
      'comments': 18,
    },
  ];

  final List<Map<String, dynamic>> _marketplaceItems = [
    {
      'id': 1,
      'title': 'Sofa Set',
      'price': '₹15,000',
      'image':
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&q=80&w=200&h=200',
      'user': 'John Smith',
      'unit': 'A-101',
    },
    {
      'id': 2,
      'title': 'Bicycle',
      'price': '₹8,500',
      'image':
          'https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?auto=format&fit=crop&q=80&w=200&h=200',
      'user': 'Priya Sharma',
      'unit': 'B-203',
    },
    {
      'id': 3,
      'title': 'Kitchen Appliances',
      'price': '₹12,000',
      'image':
          'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&q=80&w=200&h=200',
      'user': 'Raj Patel',
      'unit': 'C-405',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _currentIndex = 0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentIndex == 0
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardTheme.color,
                      foregroundColor: _currentIndex == 0
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    child: const Text('Feed'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _currentIndex = 1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentIndex == 1
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardTheme.color,
                      foregroundColor: _currentIndex == 1
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    child: const Text('Marketplace'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Content based on selected tab
          Expanded(
            child: _currentIndex == 0 ? _buildFeed() : _buildMarketplace(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new post
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeed() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          CachedNetworkImageProvider(post['user']['avatar']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['user']['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            post['user']['unit'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      post['time'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Post content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  post['content'],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Post image
              if (post['image'] != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(post['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post['likes']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.comment,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post['comments']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.share,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarketplace() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _marketplaceItems.length,
      itemBuilder: (context, index) {
        final item = _marketplaceItems[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item image
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Item details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['price'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006D77),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item['user']} • ${item['unit']}',
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
        );
      },
    );
  }
}