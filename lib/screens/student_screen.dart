import 'package:flutter/material.dart';
import 'package:college_app/screens/login_screen.dart';

class StudentScreen extends StatelessWidget {
  StudentScreen({super.key});

  final List<Map<String, String>> notices = [
    {
      "title": "Exam Schedule Released",
      "date": "28 March 2026",
      "description": "Final exams will start from April 10. Check timetable."
    },
    {
      "title": "Holiday Notice",
      "date": "25 March 2026",
      "description": "College will remain closed on account of festival."
    },
  ];

  Widget buildNoticeCard(Map<String, String> notice) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.blue),
        title: Text(notice['title']!),
        subtitle: Text(notice['description']!),
        trailing: Text(
          notice['date']!,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Student Notices"),
        centerTitle: true,

        // 🔙 Back Button
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),

        // 🚪 Logout Button
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          return buildNoticeCard(notices[index]);
        },
      ),
    );
  }
}