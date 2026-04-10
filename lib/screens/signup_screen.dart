import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = "Student";
  bool isLoading = false;

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(email);
  }

  Future<void> signup() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // 🔒 Validation
    if (email.isEmpty) {
      _showSnack("Please enter email");
      return;
    }

    if (!isValidEmail(email)) {
      _showSnack("Enter valid email");
      return;
    }

    if (password.isEmpty) {
      _showSnack("Please enter password");
      return;
    }

    setState(() => isLoading = true);

    try {
      // 🔥 Create user
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCred.user!.uid;

      // 🔥 Save role
      await FirebaseDatabase.instance.ref("users/$uid").set({
        "email": email,
        "role": role,
      });

      _showSnack("✅ Account Created");

      Navigator.pop(context);

    } catch (e) {
      _showSnack("❌ Signup Failed");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // 🔷 Logo
                const Icon(
                  Icons.flutter_dash,
                  size: 80,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                // 🔤 Title
                const Text(
                  "Signup",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // 📧 Email
                _inputField(emailController, "Email"),

                const SizedBox(height: 15),

                // 🔒 Password
                _inputField(passwordController, "Password",
                    isPassword: true),

                const SizedBox(height: 15),

                // 🎭 Role Dropdown (Styled like login)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: role,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ["Student", "Admin"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        role = val!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // 🔘 Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Signup",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🔙 Back to Login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Input Field
  Widget _inputField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}