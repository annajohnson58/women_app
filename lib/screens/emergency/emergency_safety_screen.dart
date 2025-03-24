import 'package:flutter/material.dart';
import 'package:women_app/services/supabase_service.dart';

class EmergencySafetyScreen extends StatefulWidget {
  final SupabaseService supabaseService;

  const EmergencySafetyScreen({super.key, required this.supabaseService});

  @override
  _EmergencySafetyScreenState createState() => _EmergencySafetyScreenState();
}

class _EmergencySafetyScreenState extends State<EmergencySafetyScreen> {
  List<dynamic> contacts = [];
  List<dynamic> safetyTips = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String userId = widget.supabaseService.getCurrentUserId(); // ✅ Ensure user is authenticated
    if (userId.isEmpty) return;

    try {
      final fetchedContacts = await widget.supabaseService.getEmergencyContacts(userId);
      final fetchedTips = await widget.supabaseService.getSafetyTips();
      setState(() {
        contacts = fetchedContacts;
        safetyTips = fetchedTips;
      });
    } catch (e) {
      print("Error loading emergency data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Emergency Safety'),
        backgroundColor: Colors.pink.shade400,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚨 Emergency Contacts Section
            Text("Emergency Contacts", style: _sectionTitleStyle()),
            SizedBox(height: 10),
            _buildContactList(),

            SizedBox(height: 20),

            // 📌 Safety Tips Section
            Text("Safety Tips", style: _sectionTitleStyle()),
            SizedBox(height: 10),
            _buildSafetyTipsList(),
          ],
        ),
      ),

      // ➕ Floating Action Button to Add Contacts
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Add Contact", style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.pushNamed(context, '/add_contact', arguments: widget.supabaseService);
        },
      ),
    );
  }

  Widget _buildContactList() {
    if (contacts.isEmpty) {
      return Center(
        child: Text("No emergency contacts added yet.", style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      children: contacts.map((contact) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            leading: Icon(Icons.contact_phone, color: Colors.pink),
            title: Text(contact['name'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${contact['relation']} - ${contact['phone']}"),
            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed: () {
                    _makePhoneCall(contact['phone']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message, color: Colors.blue),
                  onPressed: () {
                    _sendEmergencySMS(contact['phone']);
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSafetyTipsList() {
    if (safetyTips.isEmpty) {
      return Center(
        child: Text("No safety tips available.", style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      children: safetyTips.map((tip) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.pink.shade100,
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.pink.shade800),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tip['tip'],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Function to Make a Call
  void _makePhoneCall(String phoneNumber) async {
    final url = "tel:$phoneNumber";
    print("Calling: $phoneNumber");
    // TODO: Use url_launcher package to make a call
  }

  // Function to Send an Emergency SMS
  void _sendEmergencySMS(String phoneNumber) async {
    final message = "🚨 Emergency Alert! I need help.";
    final url = "sms:$phoneNumber?body=$message";
    print("Sending SMS: $message to $phoneNumber");
    // TODO: Use url_launcher package to send an SMS
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink.shade800);
  }
}
