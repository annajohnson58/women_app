import 'package:flutter/material.dart';
import 'package:women_app/services/supabase_service.dart';

class SafetyTipsScreen extends StatefulWidget {
  final SupabaseService supabaseService;

  const SafetyTipsScreen({super.key, required this.supabaseService});

  @override
  _SafetyTipsScreenState createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  List<dynamic> safetyTips = [];
  List<dynamic> filteredTips = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSafetyTips();
  }

  Future<void> _loadSafetyTips() async {
    try {
      final tips = await widget.supabaseService.getSafetyTips();
      setState(() {
        safetyTips = tips;
        filteredTips = tips; // Initially, show all tips
      });
    } catch (e) {
      print("Error loading safety tips: $e");
    }
  }

  void _filterTips(String query) {
    setState(() {
      filteredTips = safetyTips
          .where((tip) => tip['tip'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showAddTipModal() {
    TextEditingController tipController = TextEditingController();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add New Safety Tip", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: tipController,
                decoration: InputDecoration(
                  labelText: "Tip",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                onPressed: () async {
                  if (tipController.text.isNotEmpty) {
                    await widget.supabaseService.addSafetyTip(tipController.text);
                    Navigator.pop(context);
                    _loadSafetyTips();
                  }
                },
                child: Text("Add Tip", style: TextStyle(fontSize: 16, color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Safety Tips'),
        backgroundColor: Colors.pink.shade400,
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _filterTips,
              decoration: InputDecoration(
                hintText: "Search safety tips...",
                prefixIcon: Icon(Icons.search, color: Colors.pink),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // 📌 Safety Tips List
          Expanded(
            child: filteredTips.isEmpty
                ? Center(child: Text("No safety tips available.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: filteredTips.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.pink.shade100,
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        child: ListTile(
                          leading: Icon(Icons.security, color: Colors.pink.shade800),
                          title: Text(
                            filteredTips[index]['tip'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ➕ Floating Action Button to Add Tips
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Add Tip", style: TextStyle(color: Colors.white)),
        onPressed: _showAddTipModal,
      ),
    );
  }
}
