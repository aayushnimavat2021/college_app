import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CollegeEventScreen extends StatefulWidget {
  final String role;

  const CollegeEventScreen({super.key, required this.role});

  @override
  State<CollegeEventScreen> createState() => _CollegeEventScreenState();
}

class _CollegeEventScreenState extends State<CollegeEventScreen> {

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final venueController = TextEditingController();
  final descController = TextEditingController();

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref("college_events");

  bool isLoading = false;

  Future<void> addEvent() async {
    String name = nameController.text.trim();
    String date = dateController.text.trim();
    String time = timeController.text.trim();
    String venue = venueController.text.trim();
    String desc = descController.text.trim();

    if (name.isEmpty || date.isEmpty || time.isEmpty || venue.isEmpty) {
      _showSnack("Fill required fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      await dbRef.push().set({
        "name": name,
        "date": date,
        "time": time,
        "venue": venue,
        "description": desc,
        "createdAt": DateTime.now().toString(),
      });

      nameController.clear();
      dateController.clear();
      timeController.clear();
      venueController.clear();
      descController.clear();

      _showSnack("🎓 Event Added");
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
        title: const Text("College Events"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          children: [

            const SizedBox(height: 20),

            // 🔷 HEADER ICON
            const Icon(
              Icons.event,
              size: 60,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            // 🔹 ADMIN FORM
            if (isAdmin) ...[
              _inputField(nameController, "Event Name"),
              const SizedBox(height: 15),

              _inputField(dateController, "Date (DD/MM/YYYY)"),
              const SizedBox(height: 15),

              _inputField(timeController, "Time (10:00 AM)"),
              const SizedBox(height: 15),

              _inputField(venueController, "Venue"),
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
                      ? const CircularProgressIndicator(
                      color: Colors.white)
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

                  List events =
                  data.values.toList().reversed.toList();

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {

                      final event = events[index];

                      return Container(
                        margin:
                        const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),

                        child: Row(
                          children: [

                            // 🎓 ICON
                            Container(
                              padding:
                              const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                Colors.blue.withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.event,
                                color: Colors.blue,
                              ),
                            ),

                            const SizedBox(width: 16),

                            // 📄 DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    event['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "📅 ${event['date'] ?? ''}",
                                    style: TextStyle(
                                      color:
                                      Colors.grey[700],
                                    ),
                                  ),

                                  Text(
                                    "⏰ ${event['time'] ?? ''}",
                                    style: TextStyle(
                                      color:
                                      Colors.grey[700],
                                    ),
                                  ),

                                  Text(
                                    "📍 ${event['venue'] ?? ''}",
                                    style: TextStyle(
                                      color:
                                      Colors.grey[700],
                                    ),
                                  ),

                                  if ((event['description'] ?? '')
                                      .isNotEmpty)
                                    Text(
                                      event['description'],
                                      style: TextStyle(
                                        color:
                                        Colors.grey[600],
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

  // 🔹 MATCHED INPUT STYLE
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