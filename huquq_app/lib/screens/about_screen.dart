import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchWhatsApp() async {
    final Uri uri = Uri.parse('https://wa.me/24174740882');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch WhatsApp');
    }
  }

  Future<void> _launchEmail() async {
    final Uri uri = Uri.parse('mailto:stephkalubiaka@gmail.com');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            CircleAvatar(
              radius: 80,
              backgroundImage: const NetworkImage(
                'https://avatars.githubusercontent.com/u/123456789?v=4', // Replace with actual GitHub avatar URL
              ),
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Name
            const Text(
              'Steph Kalubiaka',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Title/Role
            const Text(
              'Développeur DevOps',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Location
            const Text(
              'Lubumbashi, RDC',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Développeur passionné spécialisé en DevOps, originaire de la République Démocratique du Congo. '
                'Je suis membre de la communauté bahá\'íe et je m\'efforce de créer des solutions technologiques '
                'qui apportent de la valeur à la société.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 30),
            // Contact Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _launchUrl('https://github.com/stephydlb'),
                  icon: const Icon(Icons.code),
                  label: const Text('GitHub'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _launchEmail,
                  icon: const Icon(Icons.email),
                  label: const Text('Email'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _launchWhatsApp,
              icon: const Icon(Icons.message),
              label: const Text('WhatsApp'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Support Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Soutenez-moi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Si vous appréciez mon travail et souhaitez me soutenir, '
                      'vous pouvez m\'envoyer un petit don via Western Union.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Informations de transfert:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nom: Steph Kalubiaka\n'
                      'Pays: République Démocratique du Congo\n'
                      'Ville: Lubumbashi\n'
                      'Téléphone: +241 74 74 08 82\n'
                      'Email: stephkalubiaka@gmail.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _launchWhatsApp,
                      icon: const Icon(Icons.support),
                      label: const Text('Contacter pour soutenir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // App Info
            const Text(
              'Huququ\'llah Calculator v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
