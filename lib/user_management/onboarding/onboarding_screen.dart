import 'package:flutter/material.dart';
import 'package:csse_waste_management/user_management/onboarding/size_config.dart';
import 'package:csse_waste_management/user_management/onboarding/onboarding_contents.dart';
import 'package:csse_waste_management/user_management/login_signup/screen/login.dart'; // Import the login screen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late PageController _controller;
  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = PageController();

    // Initialize Animation Controller for images and title
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define image scale animation
    _imageAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Define fade and slide animations for the title
    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _titleSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start the animation as soon as the Onboarding screen loads
    _animationController.forward();
  }

  int _currentPage = 0;
  List colors = const [
    Colors.white, // Background color set to white
    Colors.white,
    Colors.white,
  ];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                  // Trigger animations when the page changes
                  _animationController.forward(from: 0.0);
                },
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _imageAnimation,
                          child: Image.asset(
                            contents[i].image,
                            height: SizeConfig.blockV! * 35,
                          ),
                        ),
                        SizedBox(
                          height: (height >= 840) ? 60 : 30,
                        ),
                        FadeTransition(
                          opacity: _titleFadeAnimation,
                          child: SlideTransition(
                            position: _titleSlideAnimation,
                            child: Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w600,
                                fontSize: (width <= 550) ? 30 : 35,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ScaleTransition(
                          scale: _imageAnimation,  // Applying the same scale animation as the image
                          child: Text(
                            contents[i].desc,
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w300,
                              fontSize: (width <= 550) ? 17 : 25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                          (int index) => _buildDots(index: index),
                    ),
                  ),
                  _currentPage + 1 == contents.length
                      ? Padding(
                    padding: const EdgeInsets.all(30),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the Login screen when "START" is clicked
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }, // Text color set to green
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: (width <= 550)
                            ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
                            : EdgeInsets.symmetric(horizontal: width * 0.2, vertical: 25),
                        textStyle: TextStyle(
                          fontSize: (width <= 550) ? 13 : 17,
                        ),
                      ),
                      child: const Text("START", style: TextStyle(color: Colors.green)),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              _controller.previousPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                              );
                            },
                            style: TextButton.styleFrom(
                              elevation: 0,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: (width <= 550) ? 13 : 17,
                              ),
                            ),
                            child: const Text(
                              "GO BACK",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            _controller.jumpToPage(2);
                          },
                          style: TextButton.styleFrom(
                            elevation: 0,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: (width <= 550) ? 13 : 17,
                            ),
                          ),
                          child: const Text(
                            "SKIP",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            );
                          }, // Text color set to green
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                            padding: (width <= 550)
                                ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                                : const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                            textStyle: TextStyle(
                              fontSize: (width <= 550) ? 13 : 17,
                            ),
                          ),
                          child: const Text("NEXT", style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
