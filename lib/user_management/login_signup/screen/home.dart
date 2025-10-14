import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_waste_management/feedback/screen/view_feedback.dart';
import 'package:csse_waste_management/payments/screen/Fee_Management.dart';
import 'package:csse_waste_management/pickup/screen/PickUp_Home.dart';
import 'package:csse_waste_management/recycling_tips/waste_categories.dart';
import 'package:csse_waste_management/reminders/screens/home_screen.dart';
import 'package:csse_waste_management/report/screen/RequestHome.dart';
import 'package:csse_waste_management/user_management/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    "Home",
    "Pickups",
    "Payments",
    "Reminders",
    "Feedback",
    "Bin",
    "Waste Categories",
    "Profile",
  ];

  final List<Widget> _children = [
    const HomePage(),
    PickupHome(),
    const Fee_Management(),
    const ReminderScreen(),
    const ViewFeedbackPage(),
    const RequestHome(),
    const WasteCategoriesScreen(),
    const ProfileScreen(),
  ];

  // Function to check if the current index has an AppBar already
  bool _hasAppBar() {
    // Only show AppBar for the home and profile pages
    return _currentIndex == 0 || _currentIndex == 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _hasAppBar()
          ? AppBar(
              title: Text(_titles[_currentIndex]),
              centerTitle: true,
              backgroundColor: const Color(0xFF00C04B),
              leading:
                  _currentIndex != 0 // Show back arrow for non-home screens
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0; // Go back to Home screen
                            });
                          },
                        )
                      : null, // No back arrow for home screen
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            )
          : null, // Remove AppBar for the Home screen
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color:
                    _currentIndex == 0 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fire_truck,
                color:
                    _currentIndex == 1 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Pickups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.paid,
                color:
                    _currentIndex == 2 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,
                color:
                    _currentIndex == 3 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback,
                color:
                    _currentIndex == 4 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment,
                color:
                    _currentIndex == 5 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color:
                    _currentIndex == 6 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color:
                    _currentIndex == 7 ? const Color(0xFF00C04B) : Colors.grey),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.grey[200],
        selectedItemColor: const Color(0xFF00C04B),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/why_waste_management.mp4')
          ..initialize().then((_) {
            setState(() {
              _isVideoInitialized = true; // Mark video as initialized
            });
          }).catchError((error) {
            setState(() {
              _hasError = true; // Mark error state
            });
            print("Error initializing video: $error");
          });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user == null) {
          return const Center(child: Text("Not logged in"));
        }

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const Center(child: Text("User data not found"));
            }

            // Get user data from Firestore
            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final userName = userData['name'] ?? 'User';
            final userImage = userData['image'];

            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // User profile image, name, and email under the top bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: userImage != null
                                ? NetworkImage(userImage!)
                                : const AssetImage(
                                        'assets/images/default_profile.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome, $userName",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user.email ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Image slider below profile section
                    _buildImageSlider(),
                    const SizedBox(height: 20),

                    // App explanation before video section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Manage your waste smartly! Get recycling tips, schedule pickups, track your bin’s status, and pay for services—all in one app. Together, let's keep the environment clean!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Grid view of components
                    _buildGridView(),

                    const SizedBox(height: 20),

                    // Video section
                    if (_hasError)
                      const Text(
                        "Error loading video. Please try again later.",
                        style: TextStyle(color: Colors.red),
                      )
                    else
                      _buildVideoSection(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoSection() {
    return AnimatedOpacity(
      opacity: _isVideoInitialized ? 1.0 : 0.0,
      duration: const Duration(seconds: 1),
      child: Column(
        children: [
          const Text(
            "Why Waste Management is Really Important",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          if (_isVideoInitialized)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_controller),
            ),
          const SizedBox(height: 10),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextButton(
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  backgroundColor: _controller.value.isPlaying
                      ? Colors.green.shade50
                      : Colors.blue.shade50, // Dynamic background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: _controller.value.isPlaying
                          ? Colors.green
                          : Colors.blue, // Dynamic border color
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow, // Dynamic icon
                      color: _controller.value.isPlaying
                          ? Colors.green
                          : Colors.blue,
                    ),
                    const SizedBox(width: 8.0), // Spacing between icon and text
                    Text(
                      _controller.value.isPlaying
                          ? 'Pause Video'
                          : 'Play Video', // Dynamic text
                      style: TextStyle(
                        color: _controller.value.isPlaying
                            ? Colors.green
                            : Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: [
        'assets/images/home1.jpg',
        'assets/images/home2.jpg',
        'assets/images/home3.jpg',
        'assets/images/home4.png',
        'assets/images/home5.jpg',
      ]
          .map((item) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildGridView() {
    final List<Map<String, dynamic>> components = [
      {
        'title': 'Pickups',
        'description':
            'Schedule bulky pickups with ease and get timely reminders!',
        'icon': Icons.fire_truck,
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PickupHome(),
          ));
        },
      },
      {
        'title': 'Payments',
        'description': 'Pay for waste services online in a few clicks!',
        'icon': Icons.paid,
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Fee_Management(),
          ));
        },
      },
      {
        'title': 'Reminders',
        'description':
            'Schedule bulky pickups with ease and get timely reminders!',
        'icon': Icons.notifications,
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ReminderScreen(),
          ));
        },
      },
      {
        'title': 'Feedback',
        'description': ' Instant alerts for pickups and quick issue reporting!',
        'icon': Icons.feedback,
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ViewFeedbackPage(),
          ));
        },
      },
      {
        'title': 'Recycling Tips',
        'description':
            'Learn about different waste categories and recycling tips!',
        'icon': Icons.tips_and_updates,
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WasteCategoriesScreen(),
          ));
        },
      },
      {
        'title': 'Reports',
        'description': 'Update us with your issues!',
        'icon': Icons.assessment,
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RequestHome(),
          ));
        },
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: components.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: components[index]['onTap'],
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(components[index]['icon'],
                    size: 40, color: const Color(0xFF00C04B)),
                const SizedBox(height: 10),
                Text(
                  components[index]['title'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    components[index]['description'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
