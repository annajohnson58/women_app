// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class ChatScreen extends StatelessWidget {
// //   final TextEditingController _messageController = TextEditingController();
// //   final String currentUserId = 'currentUserId'; // Replace with the actual user ID

// //   ChatScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Chat Groups'),
// //         backgroundColor: Colors.blueAccent,
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(child: _buildMessageList()),
// //           _buildMessageInput(),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildMessageList() {
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: FirebaseFirestore.instance
// //           .collection('chatMessages')
// //           .orderBy('timestamp')
// //           .snapshots(),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

// //         final messages = snapshot.data!.docs;

// //         return ListView.builder(
// //           itemCount: messages.length,
// //           itemBuilder: (context, index) {
// //             // Cast to Map<String, dynamic>
// //             final message = messages[index].data() as Map<String, dynamic>;
// //             final isCurrentUser = message['senderId'] == currentUserId;

// //             // Check if the status field exists and use a default value if not
// //             final messageStatus = message.containsKey('status') ? message['status'] : 'sent';

// //             // Use the utility function to safely convert reactions
// //             final reactions = _convertToMap<String, dynamic>(message['reactions']);

// //             return _buildMessageCard(
// //               message['content'],
// //               message['timestamp'],
// //               isCurrentUser,
// //               messageStatus,
// //               reactions,
// //               messages[index].id,
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   // Utility function to convert a dynamic map to a specific type
// //   Map<K, V> _convertToMap<K, V>(dynamic input) {
// //     if (input == null) return {};
// //     if (input is Map<K, V>) return input;
// //     return Map<K, V>.from(input);
// //   }

// //   Widget _buildMessageCard(String content, dynamic timestamp, bool isCurrentUser, String messageStatus, Map<String, dynamic> reactions, String messageId) {
// //     // Handle null or invalid timestamp
// //     DateTime time;
// //     if (timestamp is Timestamp) {
// //       time = timestamp.toDate();
// //     } else {
// //       time = DateTime.now(); // Fallback to current time
// //     }

// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
// //       child: Align(
// //         alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
// //         child: Row(
// //           mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
// //           children: [
// //             if (!isCurrentUser) CircleAvatar(child: Text('U')), // Placeholder for user avatar

// //             SizedBox(width: 8),

// //             Column(
// //               crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //               children: [
// //                 Card(
// //                   color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   elevation: 5,
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(10),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(content, style: TextStyle(fontSize: 16)),
// //                         SizedBox(height: 5),
// //                         Text(
// //                           '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
// //                           style: TextStyle(fontSize: 12, color: Colors.black54),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 2),
// //                 Text(
// //                   _getStatusText(messageStatus),
// //                   style: TextStyle(fontSize: 10, color: Colors.black54),
// //                 ),
// //                 SizedBox(height: 5),
// //                 _buildReactionsRow(reactions, messageId),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildReactionsRow(Map<String, dynamic> reactions, String messageId) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.start,
// //       children: [
// //         IconButton(
// //           icon: Icon(Icons.thumb_up, color: reactions['thumbs_up'] != null ? Colors.blue : Colors.grey),
// //           onPressed: () => _addReaction(messageId, 'thumbs_up'),
// //         ),
// //         Text(reactions['thumbs_up']?.toString() ?? '0'),
// //         SizedBox(width: 10),
// //         IconButton(
// //           icon: Icon(Icons.favorite, color: reactions['heart'] != null ? Colors.red : Colors.grey),
// //           onPressed: () => _addReaction(messageId, 'heart'),
// //         ),
// //         Text(reactions['heart']?.toString() ?? '0'),
// //       ],
// //     );
// //   }

// //   Future<void> _addReaction(String messageId, String reactionType) async {
// //     final messageRef = FirebaseFirestore.instance.collection('chatMessages').doc(messageId);
// //     await messageRef.update({
// //       'reactions.$reactionType': FieldValue.increment(1),
// //     });
// //   }

// //   String _getStatusText(String status) {
// //     switch (status) {
// //       case 'sent':
// //         return 'Sent';
// //       case 'delivered':
// //         return 'Delivered';
// //       case 'read':
// //         return 'Read';
// //       default:
// //         return '';
// //     }
// //   }

// //   Widget _buildMessageInput() {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: TextField(
// //               controller: _messageController,
// //               decoration: InputDecoration(
// //                 hintText: 'Type a message...',
// //                 filled: true,
// //                 fillColor: Colors.grey[200],
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(30),
// //                   borderSide: BorderSide.none,
// //                 ),
// //                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //               ),
// //             ),
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.send, color: Colors.blue),
// //             onPressed: () {
// //               _sendMessage();
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _sendMessage() async {
// //     if (_messageController.text.isEmpty) return;

// //     await FirebaseFirestore.instance.collection('chatMessages').add({
// //       'senderId': currentUserId,  // Replace with the actual user ID
// //       'content': _messageController.text,
// //       'timestamp': FieldValue.serverTimestamp(),
// //       'status': 'sent', // Always initialize status
// //       'reactions': {}, // Initialize as empty map
// //     });

// //     _messageController.clear();
// //   }

// //   // Optional: Migration script to add status to existing messages
// //   Future<void> migrateMessages() async {
// //     final messagesSnapshot = await FirebaseFirestore.instance.collection('chatMessages').get();
    
// //     for (var message in messagesSnapshot.docs) {
// //       if (!message.data().containsKey('status')) {
// //         await message.reference.update({'status': 'sent'});
// //       }
// //     }
// //   }
// // }




// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatelessWidget {
//   final TextEditingController _messageController = TextEditingController();
//   final String currentUserId = 'currentUserId'; // Replace with the actual user ID
//   final SupabaseClient supabase = Supabase.instance.client;

//   ChatScreen({super.key});
  
//   get reactions => null;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat Groups'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         children: [
//           Expanded(child: _buildMessageList()),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageList() {
//     return StreamBuilder<List<dynamic>>(
//       stream: supabase.from('chatMessages').stream(primaryKey: ['id']).order('timestamp').execute(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('No messages yet.'));

//         final messages = snapshot.data!;

//         return ListView.builder(
//           itemCount: messages.length,
//           itemBuilder: (context, index) {
//             final message = messages[index];
//             final isCurrentUser = message['senderId'] == currentUserId;

//             final timestamp = (message['timestamp'] as DateTime?) ?? DateTime.now();

//             return _buildMessageCard(
//               message['content'],
//               timestamp,
//               isCurrentUser,
//               message['status'] ?? 'sent',
//               message['reactions'] ?? {},
//               message['id'],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildMessageCard(String content, DateTime timestamp, bool isCurrentUser, String messageStatus, Map<String, dynamic> reactions, String messageId) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       child: Align(
//         alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//         child: Row(
//           mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//           children: [
//             if (!isCurrentUser) CircleAvatar(child: Text('U')), // Placeholder for user avatar

//             SizedBox(width: 8),

//             Column(
//               crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//               children: [
//                 Card(
//                   color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(content, style: TextStyle(fontSize: 16)),
//                         SizedBox(height: 5),
//                         Text(
//                           '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
//                           style: TextStyle(fontSize: 12, color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   _getStatusText(messageStatus),
//                   style: TextStyle(fontSize: 10, color: Colors.black54),
//                 ),
//                 SizedBox(height: 5),
//                 _buildReactionsRow(reactions, messageId),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReactionsRow(Map<String, dynamic> reactions, String messageId) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         IconButton(
//           icon: Icon(Icons.thumb_up, color: reactions['thumbs_up'] != null ? Colors.blue : Colors.grey),
//           onPressed: () => _addReaction(messageId, 'thumbs_up'),
//         ),
//         Text(reactions['thumbs_up']?.toString() ?? '0'),
//         SizedBox(width: 10),
//         IconButton(
//           icon: Icon(Icons.favorite, color: reactions['heart'] != null ? Colors.red : Colors.grey),
//           onPressed: () => _addReaction(messageId, 'heart'),
//         ),
//         Text(reactions['heart']?.toString() ?? '0'),
//       ],
//     );
//   }

//   Future<void> _addReaction(String messageId, String reactionType) async {
//     final messageTable = supabase.from('chatMessages');

//     await messageTable.update({
//       'reactions': {
//         ...reactions,
//         reactionType: (reactions[reactionType] ?? 0) + 1
//       }
//     }).eq('id', messageId);
//   }

//   String _getStatusText(String status) {
//     switch (status) {
//       case 'sent':
//         return 'Sent';
//       case 'delivered':
//         return 'Delivered';
//       case 'read':
//         return 'Read';
//       default:
//         return '';
//     }
//   }

//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Type a message...',
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send, color: Colors.blue),
//             onPressed: () {
//               _sendMessage();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.isEmpty) return;

//     await supabase.from('chatmessages').insert({
//       'senderId': currentUserId, // Replace with the actual user ID
//       'content': _messageController.text,
//       'timestamp': DateTime.now().toUtc(),
//       'status': 'sent', // Always initialize status
//       'reactions': {}, // Initialize as empty map
//     });

//     _messageController.clear();
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  final String currentUserId = Supabase.instance.client.auth.currentUser?.id ?? ''; // Get logged-in user ID
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Chat'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          if (_isTyping) _buildTypingIndicator(), // Show typing indicator
          _buildMessageInput(),
        ],
      ),
    );
  }

  // ✅ Fetch and Stream Chat Messages
  Widget _buildMessageList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase
          .from('chat_messages')
          .stream(primaryKey: ['id'])
          .order('timestamp', ascending: true)
          .execute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        }

        final messages = snapshot.data!;
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isCurrentUser = message['sender_id'] == currentUserId;
            final timestamp = DateTime.parse(message['timestamp']);
            return _buildMessageCard(
              message['content'],
              timestamp,
              isCurrentUser,
              message['status'] ?? 'sent',
              message['reactions'] ?? {},
              message['id'],
            );
          },
        );
      },
    );
  }

  // ✅ Build Chat Message UI
  Widget _buildMessageCard(String content, DateTime timestamp, bool isCurrentUser, String messageStatus, Map<String, dynamic> reactions, String messageId) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isCurrentUser)
              const CircleAvatar(
                backgroundColor: Colors.pinkAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Card(
                  color: isCurrentUser ? Colors.pink[200] : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(content, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 5),
                        Text(
                          '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getStatusText(messageStatus),
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                _buildReactionsRow(reactions, messageId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Message Reactions (Like, Heart, etc.)
  Widget _buildReactionsRow(Map<String, dynamic> reactions, String messageId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.thumb_up, color: reactions['thumbs_up'] != null ? Colors.blue : Colors.grey),
          onPressed: () => _addReaction(messageId, 'thumbs_up'),
        ),
        Text(reactions['thumbs_up']?.toString() ?? '0'),
        const SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.favorite, color: reactions['heart'] != null ? Colors.red : Colors.grey),
          onPressed: () => _addReaction(messageId, 'heart'),
        ),
        Text(reactions['heart']?.toString() ?? '0'),
      ],
    );
  }

  // ✅ Add Reactions
  Future<void> _addReaction(String messageId, String reactionType) async {
    await supabase
        .from('chat_messages')
        .update({
          'reactions': {
            reactionType: (reactionType == 'thumbs_up' ? 1 : 0) + 1,
          }
        })
        .eq('id', messageId);
  }

  // ✅ Build Message Input Field
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onChanged: (text) {
                setState(() => _isTyping = text.isNotEmpty);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.pink),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  // ✅ Send Message
  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    await supabase.from('chat_messages').insert({
      'sender_id': currentUserId,
      'content': _messageController.text,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'status': 'sent',
      'reactions': {},
    });

    _messageController.clear();
    setState(() => _isTyping = false);
  }

  // ✅ Typing Indicator
  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text("User is typing...", style: TextStyle(color: Colors.grey)),
    );
  }

  // ✅ Get Message Status
  String _getStatusText(String status) {
    switch (status) {
      case 'sent':
        return 'Sent';
      case 'delivered':
        return 'Delivered';
      case 'read':
        return 'Read';
      default:
        return '';
    }
  }
}
