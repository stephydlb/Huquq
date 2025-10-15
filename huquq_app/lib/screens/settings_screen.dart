import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/notification_service.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dailyNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Notifications quotidiennes'),
              subtitle: const Text('Recevoir un rappel quotidien à 9h'),
              value: _dailyNotifications,
              onChanged: (value) async {
                setState(() {
                  _dailyNotifications = value;
                });
                if (value) {
                  await NotificationService.scheduleDailyNotification();
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await context.read<AppProvider>().refreshGoldPrice();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Prix mis à jour et notification envoyée'),
                ),
              );
            },
            child: const Text('Actualiser le prix de l\'or'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
            child: const Text('À propos'),
          ),
        ],
      ),
    );
  }
}
