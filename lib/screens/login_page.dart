import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women_app/services/supabase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SupabaseService _supabaseService = SupabaseService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return; // Validate form

    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final response = await _supabaseService.loginUser(email, password);
      
      // Check if response contains an error
      if (response!.error != null) {
        throw Exception(response.error!.message);
      }

      if (!mounted) return; // Ensure widget is still active

      Navigator.pushReplacementNamed(context, '/home'); 
    } catch (e) {
      // Show specific error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey, // Wrap the column in a Form widget
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/illustration.png", height: 180),
                SizedBox(height: 20),
                Text("Welcome Back!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink.shade800)),
                SizedBox(height: 10),
                Text("Log in to continue", style: TextStyle(fontSize: 16, color: Colors.grey)),
                SizedBox(height: 30),
                _buildTextField(emailController, "Email", Icons.email, TextInputType.emailAddress),
                SizedBox(height: 15),
                _buildTextField(passwordController, "Password", Icons.lock, TextInputType.visiblePassword, obscureText: true),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: _login,
                        child: Text("Log In", style: TextStyle(fontSize: 16)),
                      ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(fontSize: 16, color: Colors.pink, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon, TextInputType keyboardType,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value!.isEmpty ? "This field cannot be empty" : null,
    );
  }
}

extension on User {
  get error => null;
}