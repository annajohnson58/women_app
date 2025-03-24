import 'package:flutter/material.dart';
import 'package:women_app/services/supabase_service.dart';
import 'package:women_app/widgets/EmergencyButton.dart';

class UserProfileScreen extends StatefulWidget {
  final SupabaseService supabaseService;

  const UserProfileScreen({super.key, required this.supabaseService});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = "Jane Doe";
  String email = "jane.doe@example.com";
  String phoneNumber = "+123 456 7890";

  void _showEditProfileModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildTextField("Name", userName, (val) => setState(() => userName = val)),
              _buildTextField("Email", email, (val) => setState(() => email = val)),
              _buildTextField("Phone", phoneNumber, (val) => setState(() => phoneNumber = val)),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                onPressed: () => Navigator.pop(context),
                child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      onChanged: onChanged,
      controller: TextEditingController(text: value),
    );
  }

  void _logout() {
    widget.supabaseService.logout();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.shade400, Colors.pink.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Profile Content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/images/profile_placeholder.png"),
                ),
                SizedBox(height: 10),

                // User Info Card
                Card(
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _profileRow("Name", userName, Icons.person),
                        _profileRow("Email", email, Icons.email),
                        _profileRow("Phone", phoneNumber, Icons.phone),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _actionButton("Edit Profile", Icons.edit, _showEditProfileModal),
                      _actionButton("Logout", Icons.logout, _logout),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // 🚨 Emergency Quick Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: EmergencyButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.pink.shade800)),
      subtitle: Text(value, style: TextStyle(fontSize: 16)),
    );
  }

  Widget _actionButton(String text, IconData icon, Function onTap) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
      ),
      onPressed: () => onTap(),
      icon: Icon(icon),
      label: Text(text),
    );
  }
}
