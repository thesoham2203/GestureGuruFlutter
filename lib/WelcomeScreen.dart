import 'package:flutter/material.dart';
import 'package:gesture_guru/CameraScreen.dart';
import 'package:gesture_guru/TutorialScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  // Launch Sanket Guru App via Android Intent
  void _launchSpeechToSignApp(BuildContext context) async {
    final intent = AndroidIntent(
      action: 'com.example.sanketguru.OPEN',
      package: 'com.example.sanket_guru_new',
    );
    await intent.launch();
    try {
      await intent.launch();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open the Sanket Guru app."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff091e3a), Color(0xff2f80ed), Color(0xff2d9ee0)],
            stops: [0, 0.5, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200.0),
              child: Image(image: AssetImage('assets/logo.png')),
            ),
            const SizedBox(height: 100),
            const Text(
              'WELCOME BACK!',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // Button: Real-Time Translation
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                );
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'Real Time Translation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Button: Speech to Sign Translate
            GestureDetector(
              onTap: () {
                _launchSpeechToSignApp(context);
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'Speech to Sign Translate',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Button: Proceed with Tutorial (YouTube)
            GestureDetector(
              onTap: () async {
                final Uri appUrl = Uri.parse('youtube://www.youtube.com/@ISLRTC/playlists');
                final Uri webUrl = Uri.parse('https://www.youtube.com/@ISLRTC/playlists');

                if (await canLaunchUrl(appUrl)) {
                  await launchUrl(appUrl);
                } else if (await canLaunchUrl(webUrl)) {
                  await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open YouTube link.'),
                    ),
                  );
                }
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'Proceed with Tutorial',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
