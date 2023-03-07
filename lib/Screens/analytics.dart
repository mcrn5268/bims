import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final controller =
      PageController(initialPage: 1, viewportFraction: 1.0, keepPage: true);

  late final List<Widget> pages;
  @override
  void initState() {
    super.initState();
    pages = [genderAnalytics(), votersAnalytics(), ageAnalytics()];
  }

  Widget genderAnalytics() {
    return const Center(
        child: Text(
      "Gender Page",
      style: TextStyle(color: Colors.white),
    ));
  }

  Widget votersAnalytics() {
    return const Center(
        child: Text(
      "Voters Page",
      style: TextStyle(color: Colors.white),
    ));
  }

  Widget ageAnalytics() {
    return const Center(
        child: Text(
      "Age Page",
      style: TextStyle(color: Colors.white),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Stack(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView.builder(
              padEnds: false,
              controller: controller,
              // itemCount: pages.length,
              itemBuilder: (_, index) {
                return pages[index % pages.length];
              },
            ),
          ),
          Positioned(
            bottom: 100,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: pages.length,
                      effect: const JumpingDotEffect(
                        activeDotColor: Colors.white,
                        dotHeight: 16,
                        dotWidth: 16,
                        jumpScale: .7,
                        verticalOffset: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
