import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ✅ Register User
  Future<User?> registerUser(String email, String password, String name, String phone) async {
    final response = await _client.auth.signUp(email: email, password: password);
    
    if (response.user != null) {
      await _client.from('users').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'phone': phone,
      });
    }
    return response.user;
  }

  // ✅ Login User
  Future<User?> loginUser(String email, String password) async {
    final response = await _client.auth.signInWithPassword(email: email, password: password);
    return response.user;
  }

  // ✅ Logout User
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // ✅ Get Current User ID
  String getCurrentUserId() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception("No user is logged in.");
    }
    return user.id;
  }

  // ✅ Fetch Forum Posts
  Stream<List<Map<String, dynamic>>> getPostsStream() {
  return _client
      .from('forum_posts')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);
}


  // ✅ Create a Post
  Future<void> createPost(String userId, String content, String category, int likes) async {
  await _client.from('forum_posts').insert({
    'userId': userId,
    'content': content,
    'category': category,
    'likes': likes,
    'created_at': DateTime.now().toUtc().toIso8601String(), // Ensure timestamp is included
  });
}


  // ✅ Fetch Comments
  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    final List<Map<String, dynamic>> response =
        await _client.from('comments').select('*').eq('postId', postId).order('created_at');
    return response;
  }

  // ✅ Add a Comment
  Future<void> addComment(String userId,String postId, String content) async {
    String userId = getCurrentUserId();
    await _client.from('comments').insert({
      'userId': userId,
      'postId': postId,
      'content': content,
    });
  }

  // ✅ Like a Post
  Future<void> likePost( String userId,String postId) async {
    String userId = getCurrentUserId();
    try {
      await _client.from('postLikes').insert({'userId': userId, 'postId': postId});
      await _client.rpc('increment_likes', params: {'postId': postId});
    } catch (error) {
      print("Error liking post: $error");
    }
  }

  // ✅ Check if User Already Liked a Post
  Future<bool> hasUserLiked(String postId) async {
    String userId = getCurrentUserId();
    final List<Map<String, dynamic>> response =
        await _client.from('postLikes').select().eq('userId', userId).eq('postId', postId);
    return response.isNotEmpty;
  }

  // ✅ Fetch Chat Messages
  Stream<List<Map<String, dynamic>>> getChatMessages() {
    return _client.from('chat_messages').stream(primaryKey: ['id']).order('timestamp', ascending: true);
  }

  // ✅ Send Chat Message
  Future<void> sendMessage(String content) async {
    String senderId = getCurrentUserId();
    await _client.from('chat_messages').insert({
      'sender_id': senderId,
      'content': content,
      'timestamp': DateTime.now().toUtc(),
      'status': 'sent',
      'reactions': {},
    });
  }

  // ✅ Fetch Safety Tips
  Future<List<Map<String, dynamic>>> getSafetyTips() async {
    return await _client.from('safety_tips').select();
  }

  // ✅ Add Safety Tip
  Future<void> addSafetyTip(String tip) async {
    await _client.from('safety_tips').insert({'tip': tip});
  }

  // ✅ Fetch Job Listings
  Future<List<Map<String, dynamic>>> getJobs() async {
    return await _client.from('jobs').select();
  }

  // ✅ Upload Resume
  Future<void> uploadResume(String userId,String resumeUrl, String name, List<String> skills, String experience) async {
    String userId = getCurrentUserId();
    await _client.from('resumes').insert({
      'user_id': userId,
      'resume_url': resumeUrl,
      'name': name,
      'skills': skills,
      'experience': experience,
    });
  }

  // ✅ Fetch Mentors
  Future<List<Map<String, dynamic>>> getMentors() async {
    return await _client.from('mentors').select();
  }

  // ✅ Apply for Mentorship
  Future<void> applyForMentorship(String userId,String mentorId) async {
    String userId = getCurrentUserId();
    await _client.from('mentorship_applications').insert({
      'user_id': userId,
      'mentor_id': mentorId,
      'status': 'pending',
      'applied_at': DateTime.now().toIso8601String(),
    });
  }
   // ✅ Add Emergency Contact
  Future<void> addEmergencyContact( String userId,String name, String phone, String relation) async {
    String userId = getCurrentUserId(); // Ensure the user is logged in
    await _client.from('emergency_contacts').insert({
      'user_id': userId,
      'name': name,
      'phone': phone,
      'relation': relation,
    });
  }
  // ✅ Get Emergency Contacts
  Future<List<dynamic>> getEmergencyContacts(String userId) async {
    String userId = getCurrentUserId(); // Ensure user is logged in
    final response = await _client
        .from('emergency_contacts')
        .select('*')
        .eq('user_id', userId);

    return response; // Ensure it returns a valid list
  }
}
