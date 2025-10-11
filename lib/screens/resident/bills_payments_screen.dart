import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BillsPaymentsScreen extends StatefulWidget {
  const BillsPaymentsScreen({super.key});

  @override
  State<BillsPaymentsScreen> createState() => _BillsPaymentsScreenState();
}

class _BillsPaymentsScreenState extends State<BillsPaymentsScreen> {
  String _selectedTab = 'bills';
  bool _showPaymentMethods = false;

  final List<Map<String, dynamic>> _bills = [
    {
      'id': 1,
      'title': 'Maintenance Charges',
      'amount': '₹2,500',
      'dueDate': 'May 25, 2023',
      'status': 'Due',
      'period': 'April 2023',
      'category': 'Maintenance',
    },
    {
      'id': 2,
      'title': 'Water Charges',
      'amount': '₹800',
      'dueDate': 'May 30, 2023',
      'status': 'Due',
      'period': 'April 2023',
      'category': 'Utilities',
    },
    {
      'id': 3,
      'title': 'Parking Fees',
      'amount': '₹1,200',
      'dueDate': 'Jun 5, 2023',
      'status': 'Upcoming',
      'period': 'May 2023',
      'category': 'Facility',
    },
  ];

  final List<Map<String, dynamic>> _paymentHistory = [
    {
      'id': 1,
      'title': 'Maintenance Charges',
      'amount': '₹2,500',
      'date': 'Apr 15, 2023',
      'status': 'Paid',
      'method': 'UPI',
      'receipt': 'REC001234',
    },
    {
      'id': 2,
      'title': 'Water Charges',
      'amount': '₹750',
      'date': 'Mar 20, 2023',
      'status': 'Paid',
      'method': 'Credit Card',
      'receipt': 'REC001233',
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 1,
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'color': Colors.blue,
    },
    {
      'id': 2,
      'name': 'UPI',
      'icon': Icons.account_balance_wallet,
      'color': Colors.purple,
    },
    {
      'id': 3,
      'name': 'Net Banking',
      'icon': Icons.account_balance,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills & Payments'),
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
                    onPressed: () => setState(() => _selectedTab = 'bills'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTab == 'bills'
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardTheme.color,
                      foregroundColor: _selectedTab == 'bills'
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    child: const Text('Bills'),
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
                    child: const Text('Payment History'),
                  ),
                ),
              ],
            ),
          ),
          // Content based on selected tab
          Expanded(
            child: _selectedTab == 'bills'
                ? _buildBillsContent()
                : _buildPaymentHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsContent() {
    return Column(
      children: [
        // Summary Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Due',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '₹3,300',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Upcoming',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '₹1,200',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Bills List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _bills.length,
            itemBuilder: (context, index) {
              final bill = _bills[index];
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bill['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            bill['amount'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bill['period'],
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: bill['status'] == 'Due'
                                  ? Colors.red.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              bill['status'],
                              style: TextStyle(
                                color: bill['status'] == 'Due'
                                    ? Colors.red
                                    : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Due: ${bill['dueDate']}',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showPaymentOptions(bill),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006D77),
                          ),
                          child: const Text('Pay Now'),
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
    );
  }

  Widget _buildPaymentHistory() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _paymentHistory.length,
      itemBuilder: (context, index) {
        final payment = _paymentHistory[index];
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      payment['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      payment['amount'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      payment['date'],
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Paid',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.payment,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Method: ${payment['method']}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.receipt,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Receipt: ${payment['receipt']}',
                      style: const TextStyle(
                        color: Colors.grey,
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

  void _showPaymentOptions(Map<String, dynamic> bill) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ..._paymentMethods.map((method) {
                return GestureDetector(
                  onTap: () => _processPayment(bill, method),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: method['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              method['icon'],
                              color: method['color'],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            method['name'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _processPayment(Map<String, dynamic> bill, Map<String, dynamic> method) {
    Navigator.of(context).pop(); // Close payment methods sheet
    
    // Show payment processing
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006D77)),
              ),
              const SizedBox(height: 30),
              const Text(
                'Processing Payment...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Paying ${bill['amount']} via ${method['name']}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
    
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close processing sheet
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Update bill status
      setState(() {
        // In a real app, you would update the backend and refresh the data
      });
    });
  }
}