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
      .from('forumposts')
      .stream(primaryKey: ['id']) // Ensure 'id' is the actual primary key in your Supabase table
      .order('created_at', ascending: false)
      .map((data) => List<Map<String, dynamic>>.from(data)); // Ensure correct type conversion
}



  // ✅ Create a Post
  Future<void> createPost(String userId, String content, String category, int likes) async {
  await _client.from('forumposts').insert({
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
  // ✅ Fetch user health logs
  Future<List<Map<String, dynamic>>> getHealthData(String userId) async {
    final response = await _client
        .from('health_logs')
        .select('*')
        .eq('user_id', userId)
        .order('date', ascending: false);

    return response;
  }

  // ✅ Save health data
  Future<void> saveHealthData(
      String userId, String mood, int steps, double sleepHours, int waterIntake) async {
    await _client.from('health_logs').insert({
      'user_id': userId,
      'mood': mood,
      'steps': steps,
      'sleep_hours': sleepHours,
      'water_intake': waterIntake,
    });
  }

  // ✅ Fetch health tips based on user logs
  Future<List<String>> getHealthTips(String userId) async {
    final userLogs = await _client
        .from('health_logs')
        .select('*')
        .eq('user_id', userId)
        .order('date', ascending: false)
        .limit(1);

    if (userLogs.isEmpty) return [];

    final log = userLogs.first;
    List<String> tips = [];

    if (log['water_intake'] < 2000) {
      final tip = await _client.from('health_tips').select('message').eq('condition', 'low_water').single();
      tips.add(tip['message']);
    }
    if (log['sleep_hours'] < 6) {
      final tip = await _client.from('health_tips').select('message').eq('condition', 'low_sleep').single();
      tips.add(tip['message']);
    }
    if (log['steps'] < 5000) {
      final tip = await _client.from('health_tips').select('message').eq('condition', 'low_steps').single();
      tips.add(tip['message']);
    }

    return tips;
  }
  // ✅ Save Period Data
  Future<void> savePeriodData(String userId, DateTime startDate, DateTime endDate, int cycleLength, List<String> symptoms, String mood, String notes) async {
    await _client.from('period_tracking').insert({
      'user_id': userId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'cycle_length': cycleLength,
      'symptoms': symptoms,
      'mood': mood,
      'notes': notes,
    });
  }

  // ✅ Fetch User Period Data
  Future<List<Map<String, dynamic>>> getPeriodData(String userId) async {
    final response = await _client
        .from('period_tracking')
        .select('*')
        .eq('user_id', userId)
        .order('start_date', ascending: false);
    return response;
  }

  // ✅ Predict Next Period Date
  Future<DateTime> getNextPeriodDate(String userId) async {
    final data = await getPeriodData(userId);
    if (data.isNotEmpty) {
      DateTime lastStartDate = DateTime.parse(data.first['start_date']);
      int cycleLength = data.first['cycle_length'];
      return lastStartDate.add(Duration(days: cycleLength));
    }
    return DateTime.now(); // Default to today if no data available
  }
}
