import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
    required String district,
    required File? image, // Changed to File? to allow null images
  }) async {
    String res = "Please fill all the fields";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          name.isNotEmpty &&
          district.isNotEmpty) {
        // Register user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String imageUrl = '';
        // Check if an image is provided
        if (image != null) {
          // Upload image to Firebase Storage
          imageUrl = await uploadImage(image, cred.user!.uid);
        }

        // Add user to your Firestore database
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'district': district, // Store district
          'image': imageUrl,    // Store image URL (may be empty if no image)
        });

        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Upload Image to Firebase Storage
  Future<String> uploadImage(File image, String uid) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref = _storage.ref().child('profile_images').child(uid);

      // Upload the image file to Firebase Storage
      await ref.putFile(image);

      // Get the download URL
      String imageUrl = await ref.getDownloadURL();

      return imageUrl; // Return the image URL
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }

  // Fetch User Data
  Future<Map<String, dynamic>> getUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnap = await _firestore.collection('users').doc(currentUser.uid).get();
      return userSnap.data() as Map<String, dynamic>;
    }
    throw Exception("No user logged in");
  }

  // LogIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // SignOut
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
