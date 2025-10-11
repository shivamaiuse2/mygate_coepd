import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_bloc.dart';
import 'package:mygate_coepd/blocs/auth/auth_event.dart';

class ApprovalPendingScreen extends StatelessWidget {
  const ApprovalPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.access_time,
                  size: 60,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Approval Pending',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your registration is awaiting approval from the society administrator. You\'ll receive a notification once approved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildStatusItem(
                      context,
                      title: 'Registration Submitted',
                      subtitle: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} at ${DateTime.now().hour}:${DateTime.now().minute}',
                      completed: true,
                    ),
                    const SizedBox(height: 20),
                    _buildStatusItem(
                      context,
                      title: 'Approval Received',
                      subtitle: 'Pending',
                      completed: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Check status functionality
                  },
                  child: const Text('Check Status'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.of(context).pushReplacementNamed('/auth');
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool completed,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: completed
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            completed ? Icons.check_circle : Icons.circle,
            color: completed
                ? Theme.of(context).primaryColor
                : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: completed
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: completed ? Colors.grey : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}