import 'package:flutter/material.dart';

class ExamScreen extends StatelessWidget {
  final String role;

  const ExamScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upcoming Exams")),
      body: Center(
        child: Text("Exam Events (Role: $role)"),
      ),
    );
  }
}