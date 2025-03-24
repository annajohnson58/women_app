import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  final String content;
  final DateTime timestamp;
  final bool isCurrentUser;
  final String messageStatus;
  final Map<String, dynamic> reactions;
  final String messageId;
  final Function(String, String) onReact;

  const ChatMessageWidget({
    super.key,
    required this.content,
    required this.timestamp,
    required this.isCurrentUser,
    required this.messageStatus,
    required this.reactions,
    required this.messageId,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isCurrentUser) CircleAvatar(child: Text('U')), // Placeholder avatar

            SizedBox(width: 8),

            Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Card(
                  color: isCurrentUser ? Colors.pink[200] : Colors.grey[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(content, style: TextStyle(fontSize: 16, color: Colors.black)),
                        SizedBox(height: 5),
                        Text(
                          '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2),
                _buildReactionsRow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionsRow() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.thumb_up, color: reactions['thumbs_up'] != null ? Colors.blue : Colors.grey),
          onPressed: () => onReact(messageId, 'thumbs_up'),
        ),
        Text(reactions['thumbs_up']?.toString() ?? '0'),
      ],
    );
  }
}
