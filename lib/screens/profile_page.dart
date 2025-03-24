// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfilePage extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance; // Non-constant initialization

//   // Removed 'const' from the constructor
//   ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser; // Get the current user

//     return Scaffold(
//       appBar: AppBar(title: Text('Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('User Profile', style: TextStyle(fontSize: 24)),
//             SizedBox(height: 20),
//             Text('Email: ${user?.email}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context); // Go back to the home page
//               },
//               child: Text('Back to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   User? user;
//   String? profileImageUrl;
//   final TextEditingController _nameController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     user = _auth.currentUser;
//     _nameController.text = user?.displayName ?? '';
//     _loadProfileImage();
//   }

//   Future<void> _loadProfileImage() async {
//     // Load the profile image from Firestore or Storage if available
//     // Replace with your logic to fetch the image URL from Firestore
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         profileImageUrl = pickedFile.path; // Update profile image path
//       });
//     }
//   }

//   Future<void> _updateProfile() async {
//     // Update the user's profile information
//     try {
//       String? imageUrl;

//       if (profileImageUrl != null) {
//         // Upload the image to Firebase Storage
//         File imageFile = File(profileImageUrl!);
//         final uploadTask = await _storage
//             .ref('profile_images/${user!.uid}.png')
//             .putFile(imageFile);
//         imageUrl = await uploadTask.ref.getDownloadURL();
//       }

//       // Update the user's display name and photo URL
//       // ignore: deprecated_member_use
//       await user!.updateProfile(displayName: _nameController.text, photoURL: imageUrl);
//       await _firestore.collection('users').doc(user!.uid).set({
//         'name': _nameController.text,
//         'photoURL': imageUrl,
//         'email': user!.email,
//       });

//       // Show a success message
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
//     } catch (e) {
//       // Handle errors
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: GestureDetector(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: profileImageUrl != null
//                       ? FileImage(File(profileImageUrl!))
//                       : NetworkImage(user?.photoURL ?? 'https://example.com/default_profile.png'),
//                   child: profileImageUrl == null
//                       ? Icon(Icons.add_a_photo, size: 30, color: Colors.white)
//                       : null,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text('Name:', style: TextStyle(fontSize: 18)),
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Enter your name',
//               ),
//             ),
//             SizedBox(height: 20),
//             Text('Email: ${user?.email}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _updateProfile,
//               child: Text('Update Profile'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context); // Go back to the home page
//               },
//               child: Text('Back to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = Supabase.instance.client.auth.currentUser;
  final TextEditingController _nameController = TextEditingController();
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (user != null) {
      // Fetch user data
      final response = await Supabase.instance.client
          .from('users') // Make sure 'users' matches the actual table name in Supabase
          .select()
          .eq('email', user!.email as Object)
          .single()
          ._execute();

      if (response.error == null) {
        setState(() {
          _nameController.text = response.data['name'] ?? ''; // Safely assign
          profileImageUrl = response.data['photoURL']; // Adjust according to your schema
        });
      } else {
        // Handle the error if needed
        print(response.error!.message);
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      await Supabase.instance.client.from('users').update({
        'name': _nameController.text,
      }).eq('email', user!.email as Object);

      // Check if context is still mounted before using it
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
    } catch (e) {
      // Capture any exceptions that may occur
      if (!mounted) return; // Check if mounted
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating profile: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : NetworkImage('https://example.com/default_profile.png'), // Default profile image
              ),
            ),
            const SizedBox(height: 20),
            const Text('Name:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            Text('Email: ${user?.email}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the home page
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on PostgrestTransformBuilder<PostgrestMap> {
  _execute() {}
}