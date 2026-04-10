import 'package:college_app/screens/college_event_screen.dart';
import 'package:flutter/material.dart';
import 'event_screen.dart';
import 'login_screen.dart';
import 'exam_screen.dart';
import 'department_screen.dart';
import 'festival_screen.dart';

class GoalSelectionScreen extends StatelessWidget {
  final String role;

  const GoalSelectionScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // 🔹 HEADER
      appBar: AppBar(
        title: const Text(
          "Events & Notice",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.black),
            onSelected: (value) {
              if (value == "logout") {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // 🔹 BODY
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👤 ROLE TEXT
            Text(
              "Logged in as: $role",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(context, "Upcoming Exams", Icons.school,ExamScreen(role: role,)),
                  _buildCard(context, "Department Event", Icons.apartment,EventScreen(role: role,)),
                  _buildCard(context, "Festival Event", Icons.celebration,FestivalScreen(role: role,)),
                  _buildCard(context, "College Event", Icons.event,CollegeEventScreen(role: role,)),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔹 ADMIN BUTTON
      // floatingActionButton: role == "Admin"
      //     ? FloatingActionButton(
      //   backgroundColor: Colors.deepPurple,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => EventScreen(role: role),
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // )
      //     : null,
    );
  }

  // 🔹 CARD
  Widget _buildCard(
      BuildContext context,
      String title,
      IconData icon,
      Widget screen,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.deepPurple),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}