import 'package:bims/Screens/certs.dart';
import 'package:bims/Screens/home.dart';
import 'package:bims/cloud/firestore_service.dart';
import 'package:bims/main.dart';
import 'package:bims/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _email = TextEditingController();
  late UserProvider userProvider;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _email.text = userProvider.user!.email;
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
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
                  onPressed: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CertificateScreen(),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text('Certificates'),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 200, right: 200),
                        child: ListView(
                          children: [
                            const SizedBox(height: 20),
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey[300],
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage('person-placeholder.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(
                                  '${userProvider.user!.fname} ${userProvider.user!.lname}'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.email),
                              title: TextFormField(
                                enabled: isEditing,
                                controller: _email,
                                decoration: const InputDecoration(
                                  hintText: 'E-mail',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (isEditing) {
                                    await _dialogBuilder2(context);
                                  }
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(15),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                ),
                                child:
                                    Text(isEditing ? 'Save' : 'Update E-mail')),
                            const SizedBox(
                              height: 5,
                            ),
                            Visibility(
                              visible: !isEditing,
                              child: ElevatedButton(
                                  onPressed: () {
                                    _dialogBuilder1(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.all(15),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete account')),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(15),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blueGrey,
                                ),
                                child: const Text('Back')),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ))),
            ],
          )),
        ));
  }

  Future<void> _dialogBuilder1(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () async {
                UserProvider userProvder =
                    Provider.of<UserProvider>(context, listen: false);
                final nav = Navigator.of(context);
                await FirebaseAuth.instance.currentUser?.delete();
                await FirestoreService().delete(
                    collection: 'users', documentId: userProvider.user!.uid);
                Fluttertoast.showToast(
                  msg: 'Delete successful',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  timeInSecForIosWeb: 3,
                );
                nav.popUntil((route) => route.isFirst);
                userProvder.clearUser();
                // Navigate to a new screen
                nav.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const BIMSMain(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilder2(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text(
              'You are about to update your information. Wish to proceed?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                _email.text = userProvider.user!.email;
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser!;
                final nav = Navigator.of(context);
                try {
                  await user.updateEmail(_email.text);
                  await FirestoreService().create(
                      collection: 'users',
                      documentId: userProvider.user!.uid,
                      data: {'email': _email.text});
                  // Email updated successfully
                  Fluttertoast.showToast(
                    msg: 'Update successful',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    timeInSecForIosWeb: 3,
                  );
                  nav.pop();
                } catch (e) {
                  // An error occurred while updating the email address
                  print('error: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
