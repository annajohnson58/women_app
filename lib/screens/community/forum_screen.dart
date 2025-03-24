import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  ForumScreenState createState() => ForumScreenState();
}

class ForumScreenState extends State<ForumScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final TextEditingController _postController = TextEditingController();
  User? _currentUser;
  String? _selectedCategory = 'All';
  String? _searchQuery;

  final List<String> _categories = ['All', 'General', 'Tech', 'Health', 'Lifestyle'];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = Supabase.instance.client.auth.currentUser;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildPostList()),
          _buildPostInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
      'Community Forum',
      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(Icons.search, color: Colors.black),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.notifications_none, color: Colors.black),
        onPressed: () {},
      ),
    ],
  );
}


  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.pinkAccent,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forum'),
        BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Safety'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButton<String>(
        value: _selectedCategory,
        items: _categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category, style: GoogleFonts.poppins(fontSize: 16)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedCategory = newValue);
        },
        isExpanded: true,
      ),
    );
  }

  Widget _buildPostList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
  stream: _supabaseService.getPostsStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    final posts = snapshot.data ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: posts.length,
      itemBuilder: (context, index) => _buildPostCard(posts[index]),
    );
  },
);

  }

  Widget _buildPostCard(dynamic post) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post['content'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category: ${post['category']}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                IconButton(
                  icon: Icon(Icons.thumb_up, color: Colors.pinkAccent),
                  onPressed: () {
                    if (_currentUser != null) {
                      _supabaseService.likePost(_currentUser!.id, post['id']);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: 'Write a post...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.pinkAccent),
            onPressed: () {
              if (_currentUser != null) {
                _supabaseService.createPost(
                  _currentUser!.id,
                  _postController.text,
                  _selectedCategory ?? 'General',
                  0,
                );
                _postController.clear();
                setState(() {}); // Refresh posts
              }
            },
          ),
        ],
      ),
    );
  }
}
