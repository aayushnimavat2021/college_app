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
  final deptController = TextEditingController(); // ✅ NEW

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref("events");

  bool isLoading = false;

  Future<void> addEvent() async {
    String title = titleController.text.trim();
    String date = dateController.text.trim();
    String desc = descController.text.trim();
    String dept = deptController.text.trim(); // ✅ NEW

    if (title.isEmpty || date.isEmpty || desc.isEmpty || dept.isEmpty) {
      _showSnack("Fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      await dbRef.push().set({
        "title": title,
        "date": date,
        "description": desc,
        "department": dept, // ✅ SAVE
        "time": DateTime.now().toString(),
      });

      titleController.clear();
      dateController.clear();
      descController.clear();
      deptController.clear(); // ✅ CLEAR

      _showSnack("✅ Event Added");

    } catch (e) {
      _showSnack("❌ Error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.role == "Admin";

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          children: [

            const SizedBox(height: 20),

            const Icon(
              Icons.event_note,
              size: 60,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            // 🔹 ADMIN FORM
            if (isAdmin) ...[
              _inputField(titleController, "Title"),
              const SizedBox(height: 15),

              _inputField(dateController, "Date (DD/MM/YYYY)"),
              const SizedBox(height: 15),

              _inputField(deptController, "Department"), // ✅ NEW
              const SizedBox(height: 15),

              _inputField(descController, "Description"),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Add Event",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],

            // 🔥 EVENT LIST
            Expanded(
              child: StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, snapshot) {

                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const Center(
                        child: Text("No events found"));
                  }

                  Map data =
                  snapshot.data!.snapshot.value as Map;

                  List items =
                  data.values.toList().reversed.toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {

                      final event = items[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),

                        child: Row(
                          children: [

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.event_note,
                                color: Colors.blue,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    event['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "📅 ${event['date'] ?? ''}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),

                                  // ✅ SHOW DEPARTMENT
                                  Text(
                                    "🏫 ${event['department'] ?? ''}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),

                                  Text(
                                    event['description'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  Widget _inputField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}