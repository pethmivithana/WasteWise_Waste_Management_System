import 'dart:io';

import 'package:csse_waste_management/user_management/login_signup/services/authentication.dart';
import 'package:csse_waste_management/user_management/login_signup/widget/button.dart';
import 'package:csse_waste_management/user_management/login_signup/widget/custom_dropdown.dart';
import 'package:csse_waste_management/user_management/login_signup/widget/snackbar.dart';
import 'package:csse_waste_management/user_management/login_signup/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'login.dart'; // Navigating to login screen

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  File? _image;
  String? _selectedDistrict;

  final List<String> districts = [
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Galle',
    'Hambantota',
    'Matara',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Mullaitivu',
    'Vavuniya',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Polonnaruwa',
    'Anuradhapura',
    'Kurunegala',
    'Puttalam',
    'Kegalle',
    'Ratnapura',
    'Badulla',
    'Monaragala',
  ];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });

    // Call the signup method with all required parameters
    String res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      district: _selectedDistrict ?? '', // Ensure this is not null
      image: _image, // Pass the image directly
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      // Show success notification
      showSnackBar(context, "Signup successful! Please log in.");

      // Navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/images/signup.jpg', height: height / 4),
                const SizedBox(height: 20),
                const Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Name TextField
                TextFieldInput(
                  icon: Icons.person,
                  textEditingController: nameController,
                  hintText: 'Enter your name',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 16),

                // Email TextField
                TextFieldInput(
                  icon: Icons.email,
                  textEditingController: emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password TextField
                TextFieldInput(
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 16),

                // District Selector using CustomDropdown
                CustomDropdown(
                  selectedValue: _selectedDistrict,
                  items: districts,
                  hintText: 'Select your district',
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDistrict = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Image Picker
                Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                          color: Colors
                              .grey.shade200, // Light background for the picker
                        ),
                        child: _image != null
                            ? ClipOval(
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap to select your profile picture',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Sign Up Button
                MyButtons(onTap: signupUser, text: "Sign Up"),
                const SizedBox(height: 16),

                // Already have an account? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
