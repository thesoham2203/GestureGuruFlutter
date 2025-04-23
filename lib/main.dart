import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'CameraScreen.dart';
import 'WelcomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyDb3_qZUBNFkpwqkQa_IjAaKi1Fav0vvSU',
          appId: '1:227346529613:android:53fe954ffb921e48d88b04',
          messagingSenderId: '227346529613',
          projectId: 'gestureguru-3bf71')
  ); // Initialize Firebase
  cameras = await availableCameras();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home:const WelcomeScreen(),
    );
  }
}