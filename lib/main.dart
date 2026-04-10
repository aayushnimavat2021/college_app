import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:college_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAyYgXeBJ1jKjoYwmUd_aeDTb7NSPOmGs0",
      appId: "1:705826828670:android:b9c692a82f9ecfdc41432f",
      messagingSenderId: "705826828670",
      projectId: "college-app-4e37b",
      databaseURL: "https://college-app-4e37b-default-rtdb.firebaseio.com",
    ),
  );
  print("Firebase Initialized");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}