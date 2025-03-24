import 'package:flutter/material.dart';
import 'package:women_app/services/supabase_service.dart';

class AddContactScreen extends StatefulWidget {
  final SupabaseService supabaseService;

  const AddContactScreen({super.key, required this.supabaseService});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController relationController = TextEditingController();

  bool _isSaving = false; // Loading indicator

  Future<void> _addContact() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      String userId = widget.supabaseService.getCurrentUserId();
      try {
        await widget.supabaseService.addEmergencyContact(
          userId,
          nameController.text,
          phoneController.text,
          relationController.text,
        );
        Navigator.pop(context); // Close screen after saving
      } catch (e) {
        print("Error adding contact: $e");
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Add Emergency Contact'),
        backgroundColor: Colors.pink.shade400,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 👩‍💼 Name Field
              _buildTextField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
                validator: (value) => value!.isEmpty ? "Name is required" : null,
              ),
              SizedBox(height: 15),

              // 📞 Phone Field
              _buildTextField(
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.length < 10 ? "Enter a valid phone number" : null,
              ),
              SizedBox(height: 15),

              // 🤝 Relationship Field
              _buildTextField(
                controller: relationController,
                label: "Relationship",
                icon: Icons.family_restroom,
                validator: (value) => value!.isEmpty ? "Enter a relationship" : null,
              ),
              SizedBox(height: 30),

              // 🆘 Emergency Save Button
              _isSaving
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: Icon(Icons.save),
                      label: Text("Save Contact", style: TextStyle(fontSize: 16)),
                      onPressed: _addContact,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
