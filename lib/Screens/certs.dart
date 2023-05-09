import 'package:bims/Screens/home.dart';
import 'package:bims/Screens/profile.dart';
import 'package:flutter/material.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/bims-logo-white-black.png'),
            ),
          ),
          flexibleSpace: SizedBox(
            height: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => BIMSHome(),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text('Home'),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    disabledForegroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white,
                  ),
                  child: const Text('Certificates'),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ProfileScreen(),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text('Profile'),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
              child: Stack(
            children: [
              Image.asset(
                'assets/community.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Center(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width - 300,
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView(
                        children: [],
                      ))),
            ],
          )),
        ));
  }
}
