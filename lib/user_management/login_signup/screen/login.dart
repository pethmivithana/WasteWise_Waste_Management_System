import 'package:flutter/material.dart';
import 'package:csse_waste_management/user_management/login_signup/widget/button.dart';
import 'package:csse_waste_management/user_management/login_signup/password_forgot/forgot_password.dart';
import 'package:csse_waste_management/user_management/login_signup/services/authentication.dart';
import 'package:csse_waste_management/user_management/login_signup/widget/snackbar.dart';
import 'package:csse_waste_management/user_management/login_signup/widget/text_field.dart';
import 'home.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool _validateInputs() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, "Please fill in all fields");
      return false;
    }
    // Regular expression for validating email
    String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(email)) {
      showSnackBar(context, "Please enter a valid email address");
      return false;
    }
    if (password.length < 6) {
      showSnackBar(context, "Password must be at least 6 characters long");
      return false;
    }
    return true;
  }

  void loginUser() async {
    if (!_validateInputs()) return;

    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 2.7,
                  child: Image.asset('assets/images/login.jpg'),
                ),
                const SizedBox(height: 30),
                TextFieldInput(
                  icon: Icons.person,
                  textEditingController: emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 20),
                const ForgotPassword(),
                const SizedBox(height: 30),
                MyButtons(
                  onTap: loginUser,
                  text: "LOGIN",
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
