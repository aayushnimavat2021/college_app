import 'package:flutter/material.dart';
import 'package:college_app/screens/home_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, String>> notices = [
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
    {
      "title": "Workshop on AI",
      "date": "20 March 2026",
      "description": "Join AI workshop in seminar hall at 10 AM."
    },
  ];

  // 🔥 Modern Notice Card
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.notifications, color: Colors.blue, size: 26),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice['title'] ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  notice['description'] ?? "",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      notice['date'] ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("College Notices"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),

      body: notices.isEmpty
          ? const Center(
        child: Text(
          "No notices available",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          return buildNoticeCard(notices[index]);
        },
      ),

      // 🔥 Role-Based FAB
      floatingActionButton: widget.role == "Admin"
          ? FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          // Next step: navigate to Add Notice Screen
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}