import 'package:flutter/material.dart';
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
  final TextEditingController _commentController = TextEditingController();
  String? _selectedCategory = 'All';
  String? _searchQuery;
  User? _currentUser;

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
      appBar: AppBar(title: const Text('Community Forum')),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildPostList()),
          _buildPostInput(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _selectedCategory,
        items: _categories.map((String category) {
          return DropdownMenuItem<String>(value: category, child: Text(category));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => _selectedCategory = newValue);
        },
      ),
    );
  }

  Widget _buildPostList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
  stream: _supabaseService.getPostsStream(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
    if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

    final posts = snapshot.data!;
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
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(post['content']),
        subtitle: Text('Category: ${post['category']}'),
        trailing: IconButton(
          icon: const Icon(Icons.thumb_up),
          onPressed: () {
            if (_currentUser != null) {
              _supabaseService.likePost(_currentUser!.id, post['id']);
              setState(() {});
            }
          },
        ),
        onTap: () => _showCommentsDialog(post['id']),
      ),
    );
  }

  Future<void> _showCommentsDialog(String postId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Comments'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<dynamic>>(
              future: _supabaseService.getComments(postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Text("No comments yet.");
                return Column(children: snapshot.data!.map((comment) => Text(comment['content'])).toList());
              },
            ),
            TextField(controller: _commentController, decoration: const InputDecoration(hintText: 'Add a comment...')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_currentUser != null) {
                _supabaseService.addComment(_currentUser!.id, postId, _commentController.text);
                _commentController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Post'),
          ),
        ],
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () async {
  if (_currentUser != null) {
    await _supabaseService.createPost(
      _currentUser!.id,
      _postController.text.trim(),
      _selectedCategory ?? 'General',
      0
    );
    _postController.clear();
    setState(() {}); // 🔄 Force UI Refresh
  } else {
    print("⚠️ User not logged in! Cannot create post.");
  }
},

          ),
        ],
      ),
    );
  }
}