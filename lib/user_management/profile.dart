import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // For selecting an image
import 'package:firebase_storage/firebase_storage.dart'; // For uploading the image to Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database
import 'dart:io';
import 'package:csse_waste_management/user_management/login_signup/screen/login.dart';// For File class

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  String? displayName;
  String? photoUrl;
  String? district;// District field
  String? email; // Add email field// District field

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (user != null) {
      // Load district, displayName, and photoUrl from Firestore
      DocumentSnapshot userDoc = await firestore.collection('users').doc(user?.uid).get();
      if (userDoc.exists) {
        setState(() {
          district = userDoc['district'] ?? 'Not Set';
          displayName = userDoc['name'] ?? 'User'; // Fetching name from Firestore
          photoUrl = userDoc['image'] ?? user?.photoURL; // Fetching image URL from Firestore or fallback to Auth
          email = user?.email; // Get email
        });
      }
    }
  }



  Future<void> _deleteAccount() async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Delete user from Firebase Authentication
        await user?.delete();

        // Optionally, you can also delete the user data from Firestore
        await firestore.collection('users').doc(user?.uid).delete();

        // Navigate to the login screen (you may need to adjust the route)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (e) {
        print("Error deleting account: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete account")),
        );
      }
    }
  }

  Future<void> _changeProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${user?.uid}.jpg');

        await storageRef.putFile(File(image.path));

        String downloadURL = await storageRef.getDownloadURL();

        await user?.updatePhotoURL(downloadURL);
        await FirebaseAuth.instance.currentUser?.reload();

        await firestore.collection('users').doc(user?.uid).update({
          'image': downloadURL,
        });

        User? updatedUser = FirebaseAuth.instance.currentUser;

        setState(() {
          photoUrl = updatedUser?.photoURL;
          displayName = updatedUser?.displayName ?? 'User';
        });
      }
    } catch (e) {
      print('Error changing profile picture: $e');
    }
  }

  Future<void> _removeProfilePicture() async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Profile Picture"),
        content: const Text("Are you sure you want to remove your profile picture?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Remove"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await user?.updatePhotoURL(null);
      const String defaultImageUrl = 'assets/images/default_profile.png';
      setState(() {
        photoUrl = defaultImageUrl; // Update to show default image
      });

      await firestore.collection('users').doc(user?.uid).update({
        'image': null,
      });
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose an option",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Change Profile Picture"),
                onTap: () {
                  Navigator.of(context).pop();
                  _changeProfilePicture();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Remove Profile Picture"),
                onTap: () {
                  Navigator.of(context).pop();
                  _removeProfilePicture();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changePassword() async {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    final bool? confirmed = await showDialog<bool>(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Old Password"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password must be at least 6 characters"),
                  ),
                );
              } else {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text("Change"),
          ),
        ],
      );
    });

    if (confirmed == true) {
      try {
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: oldPasswordController.text,
        );

        await user?.reauthenticateWithCredential(credential);
        await user?.updatePassword(newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password changed successfully")),
        );
      } catch (e) {
        print("Error changing password: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Old password did not match. Failed to change password")),
        );
      }
    }
  }

  Future<void> _changeDisplayName() async {
    final TextEditingController newNameController = TextEditingController();

    final bool? confirmed = await showDialog<bool>(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Change Display Name"),
        content: TextField(
          controller: newNameController,
          decoration: const InputDecoration(labelText: "New Display Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Change"),
          ),
        ],
      );
    });

    if (confirmed == true && newNameController.text.isNotEmpty) {
      try {
        await user?.updateDisplayName(newNameController.text);
        await FirebaseAuth.instance.currentUser?.reload();

        await firestore.collection('users').doc(user?.uid).update({
          'name': newNameController.text,
        });

        setState(() {
          displayName = newNameController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Display name changed successfully")),
        );
      } catch (e) {
        print("Error changing display name: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to change display name")),
        );
      }
    }
  }

  Future<void> _changeDistrict() async {
    final TextEditingController newDistrictController = TextEditingController();

    final bool? confirmed = await showDialog<bool>(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Change Living District"),
        content: TextField(
          controller: newDistrictController,
          decoration: const InputDecoration(labelText: "New District"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Change"),
          ),
        ],
      );
    });

    if (confirmed == true && newDistrictController.text.isNotEmpty) {
      try {
        // Update district in Firestore
        await firestore.collection('users').doc(user?.uid).update({
          'district': newDistrictController.text,
        });

        setState(() {
          district = newDistrictController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("District updated successfully")),
        );
      } catch (e) {
        print("Error changing district: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update district")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl!)
                  : const AssetImage('assets/images/default_profile.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              displayName ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(email ?? 'No Email', style: const TextStyle(fontSize: 16,)), // Email below display name
            const SizedBox(height: 8),TextButton(
              onPressed: _showImageOptions,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                backgroundColor: Colors.green.shade50, // Light background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Colors.green), // Border color
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.image, // Change icon as needed
                    color: Colors.green,
                  ),
                  SizedBox(width: 8.0), // Spacing between icon and text
                  Text(
                    "Change or Remove Profile Picture",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16, // Increased font size
                      fontWeight: FontWeight.bold, // Make text bold
                    ),
                  ),
                ],
              ),
              // Adding a tooltip for better understanding

            ),

            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Change Display Name"),
              onTap: _changeDisplayName,
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Change Password"),
              onTap: _changePassword,
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Change Living District"),
              subtitle: Text(district ?? 'Not Set'),
              onTap: _changeDistrict,
            ),
            const SizedBox(height: 24), // Add some space before delete button
            TextButton(
                onPressed: _deleteAccount,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  backgroundColor: Colors.red.shade50, // Light background for delete button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.red), // Border color
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8.0), // Spacing between icon and text
                    Text(
                      "Delete Account",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16, // Increased font size
                        fontWeight: FontWeight.bold, // Make text bold
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
