import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EventScreen extends StatefulWidget {
  final String role;

  const EventScreen({super.key, required this.role});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final descController = TextEditingController();

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref("events");

  // 🔥 ADD EVENT TO REALTIME DATABASE
  Future<void> addEvent() async {
    String title = titleController.text.trim();
    String date = dateController.text.trim();
    String desc = descController.text.trim();

    if (title.isEmpty || date.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    try {
      await dbRef.push().set({
        "title": title,
        "date": date,
        "description": desc,
        "time": DateTime.now().toString(),
      });

      titleController.clear();
      dateController.clear();
      descController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Event Added")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.role == "Admin";

    return Scaffold(
      appBar: AppBar(title: const Text("Events")),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [

            // 🔹 ADMIN PANEL
            if (isAdmin) ...[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addEvent,
                  child: const Text("Add Event"),
                ),
              ),

              const SizedBox(height: 15),
            ],

            // 🔥 REALTIME LIST
            Expanded(
              child: StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, snapshot) {

                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(child: Text("No events found"));
                  }

                  Map data =
                  snapshot.data!.snapshot.value as Map;

                  List items = data.values.toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {

                      final event = items[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(event['title'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("📅 ${event['date'] ?? ''}"),
                              Text(event['description'] ?? ''),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}