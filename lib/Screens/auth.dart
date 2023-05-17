import 'package:bims/cloud/firestore_service.dart';
import 'package:bims/models/user_model.dart';
import 'package:bims/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum Gender { male, female, lgbtq }

enum Voter { yes, no }

enum PWD { yes, no }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailLogin = TextEditingController();
  final _passLogin = TextEditingController();
  final _emailReg = TextEditingController();
  final _passReg = TextEditingController();
  final _cpassReg = TextEditingController();
  final _FNameReg = TextEditingController();
  final _LNameReg = TextEditingController();
  final _ageController = TextEditingController();
  late UserProvider userProvider;
  String? _loginEmailErrorText;
  String? _loginPasswordErrorText;
  int flag = 0;
  Gender _gender = Gender.male;
  Voter _voter = Voter.no;
  PWD _pwd = PWD.no;
  bool _loginLoading = false;
  bool _regLoading = false;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _emailLogin.text = 'JohnSmith@test.com';
    _passLogin.text = 'JohnSmith@test.com';
    _FNameReg.text = 'John';
    _LNameReg.text = 'Smith';
    _emailReg.text = 'JohnSmith@test.com';
    _passReg.text = 'JohnSmith@test.com';
    _cpassReg.text = 'JohnSmith@test.com';
    _ageController.text = '25';
  }

  @override
  void dispose() {
    _emailLogin.dispose();
    _passLogin.dispose();
    _emailReg.dispose();
    _passReg.dispose();
    _cpassReg.dispose();
    _FNameReg.dispose();
    _LNameReg.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    setState(() {
      _regLoading = true;
    });

    final firebaseAuth = FirebaseAuth.instance;

    try {
      // Create a new user account using Firebase Authentication
      final authResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: _emailReg.text, password: _passReg.text);

      // Create a new user document in Firestore
      final userData = {
        'fname': _FNameReg.text,
        'lname': _LNameReg.text,
        'email': _emailReg.text,
        'gender':
            _gender.toString().substring(_gender.toString().indexOf('.') + 1),
        'voter':
            _voter.toString().substring(_voter.toString().indexOf('.') + 1) ==
                    'no'
                ? false
                : true,
        'pwd':
            _pwd.toString().substring(_pwd.toString().indexOf('.') + 1) ==
                    'no'
                ? false
                : true,
        'age': _ageController.text,
      };
      FirestoreService().create(
          collection: 'users',
          documentId: authResult.user!.uid,
          data: userData);

      // Update the user data in the UserProvider
      final user = UserModel(
          uid: authResult.user!.uid,
          email: _emailReg.text,
          fname: _FNameReg.text,
          lname: _LNameReg.text);
      userProvider.setUser(user);
    } catch (e) {
      // Display an error message
      if (kDebugMode) {
        print('Error registering user: $e');
      }
    } finally {
      //Navigator.pop(context);
      setState(() {
        _regLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loginWidget = Padding(
      padding: const EdgeInsets.only(left: 200, right: 200),
      child: Column(
        children: [
          const Text(
            'LOGIN',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 100),
          TextFormField(
            controller: _emailLogin,
            decoration: InputDecoration(
              hintText: 'Email',
              border: InputBorder.none,
              errorText: _loginEmailErrorText,
            ),
            onChanged: (textt) {
              setState(() {
                _loginEmailErrorText = null;
              });
            },
          ),
          const Divider(),
          TextFormField(
            obscureText: true,
            controller: _passLogin,
            decoration: InputDecoration(
              hintText: 'Password',
              border: InputBorder.none,
              errorText: _loginPasswordErrorText,
            ),
            onChanged: (textt) {
              setState(() {
                _loginPasswordErrorText = null;
              });
            },
          ),
          const Divider(),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  _loginLoading = true;
                });
                try {
                  //Firebase sign in
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailLogin.text, password: _passLogin.text);
                  if (mounted) {
                    //sign in success
                    final userInfo = userCredential.user;
                    Provider.of<UserProvider>(context, listen: false)
                        .signIn(userInfo);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    if (_emailLogin.text == '') {
                      _loginEmailErrorText = 'Please enter an email.';
                    } else {
                      _loginEmailErrorText = 'No user found for that email.';
                    }
                  } else if (e.code == 'wrong-password') {
                    if (_emailLogin.text == '') {
                      _loginPasswordErrorText = 'Please enter a password.';
                    } else {
                      _loginPasswordErrorText =
                          'Wrong password provided for that email.';
                    }
                  } else {
                    print('else catch e: $e');
                  }
                } finally {
                  setState(() {
                    _loginLoading = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(15),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
              ),
              child: _loginLoading
                  ? const CircularProgressIndicator()
                  : const Text('Log in')),
        ],
      ),
    );
    Widget regWidget = Padding(
      padding: const EdgeInsets.only(left: 200, right: 200),
      child: Column(
        children: [
          const Text(
            'REGISTER',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _FNameReg,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const VerticalDivider(),
                Flexible(
                  child: TextFormField(
                    controller: _LNameReg,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          IntrinsicHeight(
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: Row(
                    children: [
                      Flexible(
                        child: Radio(
                          value: Gender.male,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                      const Text('Male'),
                      Flexible(
                        child: Radio(
                          value: Gender.female,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                      const Text('Female'),
                      Flexible(
                        child: Radio(
                          value: Gender.lgbtq,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                      const Text('LGBTQ'),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 1,
                  child: TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Age',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 4,
                  child: Row(
                    children: [
                      const Flexible(child: Text('Voter?')),
                      Flexible(
                        child: Radio(
                          value: Voter.yes,
                          groupValue: _voter,
                          onChanged: (value) {
                            setState(() {
                              _voter = value!;
                            });
                          },
                        ),
                      ),
                      const Text('Yes'),
                      Flexible(
                        child: Radio(
                          value: Voter.no,
                          groupValue: _voter,
                          onChanged: (value) {
                            setState(() {
                              _voter = value!;
                            });
                          },
                        ),
                      ),
                      const Text('No'),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 4,
                  child: Row(
                    children: [
                      const Flexible(child: Text('PWD?')),
                      Flexible(
                        child: Radio(
                          value: PWD.yes,
                          groupValue: _pwd,
                          onChanged: (value) {
                            setState(() {
                              _pwd = value!;
                            });
                          },
                        ),
                      ),
                      const Text('Yes'),
                      Flexible(
                        child: Radio(
                          value: PWD.no,
                          groupValue: _pwd,
                          onChanged: (value) {
                            setState(() {
                              _pwd = value!;
                            });
                          },
                        ),
                      ),
                      const Text('No'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          TextFormField(
            controller: _emailReg,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          TextFormField(
            obscureText: true,
            controller: _passReg,
            decoration: const InputDecoration(
              hintText: 'Password',
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                _registerUser();
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(15),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
              ),
              child: _regLoading
                  ? const CircularProgressIndicator()
                  : const Text('Register')),
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/bims-logo-white-black.png'),
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
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Expanded(
                            child: Stack(
                              children: [
                                Visibility(
                                    visible: flag == 0, child: loginWidget),
                                Visibility(visible: flag == 1, child: regWidget)
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                child: RichText(
                                  text: TextSpan(
                                    text: flag == 0
                                        ? "Don't have an account? "
                                        : 'Already have an account? ',
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: flag == 0 ? 'Register' : 'Login',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () => setState(() {
                                  flag = flag == 0 ? 1 : 0;
                                }),
                              )),
                          const SizedBox(height: 20),
                        ],
                      ))),
            ],
          )),
        ));
  }
}
