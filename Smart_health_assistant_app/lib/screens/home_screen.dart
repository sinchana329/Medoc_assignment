import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/health_provider.dart';
import 'add_record_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Health Assistant"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddRecordScreen(),
                ),
              );
            },
            child: const Text("Add Record"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
            child: const Text("Profile"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.records.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provider.records[index].title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}