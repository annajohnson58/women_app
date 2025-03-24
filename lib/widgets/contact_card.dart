import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final dynamic contact;

  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(contact['name']),
        subtitle: Text(contact['phone']),
        trailing: IconButton(
          icon: Icon(Icons.phone),
          onPressed: () {
            // Logic to call this contact
          },
        ),
      ),
    );
  }
}