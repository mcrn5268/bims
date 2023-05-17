import 'package:bims/Screens/home.dart';
import 'package:bims/Screens/profile.dart';
import 'package:bims/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' as html;

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final GlobalKey _globalKey1 = GlobalKey();
  final GlobalKey _globalKey2 = GlobalKey();
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  Future<Uint8List> _captureImage({required int option}) async {
    late RenderRepaintBoundary? boundary;
    if (option == 0) {
      boundary = _globalKey1.currentContext!.findRenderObject()
          as RenderRepaintBoundary?;
    } else if (option == 1) {
      boundary = _globalKey2.currentContext!.findRenderObject()
          as RenderRepaintBoundary?;
    }
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _saveImage(Uint8List imageBytes) async {
    // Encode the image data to base64
    final String base64Image = base64Encode(imageBytes);
    // Create a data URI for the image data
    final String dataUri = 'data:image/png;base64,$base64Image';
    // Create an anchor element
    final html.AnchorElement anchor = html.AnchorElement(href: dataUri);
    // Set the download attribute to specify the file name
    anchor.download = 'my_image.png';
    // Trigger a click event on the anchor element to start the download
    anchor.click();
  }

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
                      pageBuilder: (_, __, ___) => const BIMSHome(),
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
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        final imageItem =
                                            await _captureImage(option: 0);
                                        _saveImage(imageItem);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        padding: const EdgeInsets.all(15),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blueGrey,
                                      ),
                                      child:
                                          const Text('Get Barangay Clearance')),
                                  // Image.asset('assets/brgy_cert.jpg')
                                  RepaintBoundary(
                                    key: _globalKey1,
                                    child: Stack(
                                      children: <Widget>[
                                        Image.asset('assets/brgy_cert.jpg'),
                                        Positioned(
                                          bottom: 370,
                                          right: 150,
                                          child: Text(
                                            '${userProvider.user!.fname} ${userProvider.user!.lname}',
                                            style:
                                                const TextStyle(fontSize: 24),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                              Expanded(
                                  child: Column(children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      final imageItem =
                                          await _captureImage(option: 1);
                                      _saveImage(imageItem);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.all(15),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                    child: const Text('Get Business Permit')),
                                //Image.asset('assets/brgy_permit.png')
                                RepaintBoundary(
                                  key: _globalKey2,
                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset('assets/brgy_permit.png'),
                                      Positioned(
                                        top: 190,
                                        left: 150,
                                        child: Text(
                                          '${userProvider.user!.fname} ${userProvider.user!.lname}',
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ])),
                            ],
                          ),
                        ],
                      ))),
            ],
          )),
        ));
  }
}
