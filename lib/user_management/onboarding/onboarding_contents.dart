class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Schedule Special Waste Collections",
    image: "assets/images/image1.jpg",
    desc: " Need to dispose of bulky items? Schedule a special collection with just a few taps.",
  ),
  OnboardingContents(
    title: "Earn Rewards for Recycling",
    image: "assets/images/image2.jpg",
    desc:
    "Get paybacks for recycling e-waste and other materials.",
  ),
  OnboardingContents(
    title: "Your guide to smarter waste management.",
    image: "assets/images/image3.jpg",
    desc:
    "Join us in making your community cleaner and greener. Let’s get started!",
  ),
];