import 'package:bims/Screens/add_person.dart';
import 'package:bims/Screens/analytics.dart';
import 'package:bims/Screens/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BIMSHome extends StatefulWidget {
  const BIMSHome({super.key});

  @override
  State<BIMSHome> createState() => _BIMSHomeState();
}

class _BIMSHomeState extends State<BIMSHome> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List<Widget> _navItems = [
    const AnalyticsScreen(),
    const AddPersonScreen(),
    const ProfileScreen()
  ];
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          key: _bottomNavigationKey,
          backgroundColor: Colors.black87,
          items: const <Widget>[
            Icon(Icons.analytics_outlined, size: 30),
            Icon(Icons.add, size: 30),
            Icon(Icons.person_outline, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: SafeArea(
          child: _navItems[_page],
        ));
  }
}
