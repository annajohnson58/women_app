import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildTextField(controller: usernameController, label: 'Username'),
              const SizedBox(height: 20),
              _buildTextField(controller: emailController, label: 'Email'),
              const SizedBox(height: 20),
              _buildTextField(controller: passwordController, label: 'Password', obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Future<void> _registerUser() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  String username = usernameController.text.trim();

  // Validate inputs
  if (username.isEmpty || email.isEmpty || password.isEmpty) {
    _showMessage("Please fill in all fields.");
    return;
  }

  try {
    // Attempt to register the user with Supabase
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    // Check if the user is null, indicating a failure
    if (response.user == null) {
      _showMessage("Registration failed: ${response.message ?? 'Unknown error'}");
      return;
    }

    // If the user is created successfully, insert user details into the 'users' table
    final userId = response.user!.id;

    // Inserting user details into the 'users' table
    final insertResponse = await Supabase.instance.client
        .from('users')
        .insert([
          {
            'id': userId,
            'username': username,
            'email': email,
          }
        ]);

    if (insertResponse.error != null) {
      _showMessage("Error inserting user details: ${insertResponse.error!.message}");
    } else {
      _showMessage("Registration successful! Welcome!");
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home after successful registration
    }
  } catch (e) {
    _showMessage('An unexpected error occurred: ${e.toString()}');
  }
}

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ));
    }
  }
}

extension on AuthResponse {
  get message => null;
}