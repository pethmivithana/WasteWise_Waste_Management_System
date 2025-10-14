import 'package:flutter/material.dart';
import 'package:csse_waste_management/user_management/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  String _displayText = '';
  int _textIndex = 0;
  final String _fullText = 'Waste is only waste when we waste it'; // Full phrase
  late Duration _characterDuration; // Time interval for each character

  @override
  void initState() {
    super.initState();

    // Initialize the Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Animation duration
      vsync: this,
    );

    // Fade animation for logo
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Slide animation for the WasteWise text
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Scale animation for the logo
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Time interval for each character in the typewriter effect
    _characterDuration = const Duration(milliseconds: 80);

    // Start the animation
    _controller.forward();

    // Start typing effect for the phrase
    _startTypingEffect();

    // Navigate to the onboarding screen after the animation and delay
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  // Typing effect method
  void _startTypingEffect() {
    Future.delayed(_characterDuration, _updateDisplayText);
  }

  // Update the display text by adding one character at a time
  void _updateDisplayText() {
    if (_textIndex < _fullText.length) {
      setState(() {
        _displayText += _fullText[_textIndex];
        _textIndex++;
      });
      _startTypingEffect(); // Recursively call to keep updating
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for a clean look
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with Scale and Fade transition
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      'assets/images/logo.jpg', // Ensure the path is correct
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spacing between logo and text
                // Sliding in "WasteWise" text
                SlideTransition(
                  position: _slideAnimation,
                  child: const Text(
                    'WasteWise',
                    style: TextStyle(
                      fontSize: 32, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4CAF50), // Green color for the text
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Spacing for the phrase
                // Typing effect for the phrase "Waste is only waste when we waste it"
                Text(
                  _displayText, // Displaying text dynamically updated
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20, // Subtle font size
                    fontStyle: FontStyle.italic,
                    color: Colors.black54, // Slightly muted color for subtlety
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
