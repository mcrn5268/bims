import 'package:bims/cloud/firestore_service.dart';
import 'package:bims/models/user_model.dart';
import 'package:bims/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailLogin = TextEditingController();
  final _passLogin = TextEditingController();
  final _emailReg = TextEditingController();
  final _passReg = TextEditingController();
  final _cpassReg = TextEditingController();
  final _FNameReg = TextEditingController();
  final _LNameReg = TextEditingController();
  String _authType = 'Login';
  String? selectedGender;
  String? selectedVoter;
  bool _isLoading = false;
  String? _loginEmailErrorText;
  String? _loginPasswordErrorText;
  bool _obscureText = true;
  bool logInHasError = false;
  void onGenderSelected(String? value) {
    setState(() {
      selectedGender = value;
    });
  }

  void onVoterSelected(String? value) {
    setState(() {
      selectedVoter = value;
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailLogin.text = 'JohnSmith@test.com';
    _passLogin.text = 'JohnSmith@test.com';
    _FNameReg.text = 'John';
    _LNameReg.text = 'Smith';
    _emailReg.text = 'JohnSmith@test.com';
    _passReg.text = 'JohnSmith@test.com';
    _cpassReg.text = 'JohnSmith@test.com';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Widget loginSection = Center(
      child: Container(
        height: _authType == 'Login'
            ? logInHasError
                ? 133
                : 112
            : 0,
        width:
            _authType == 'Login' ? MediaQuery.of(context).size.width - 50 : 0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
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
            ],
          ),
        ),
      ),
    );
    Widget signupSection = Center(
      child: Container(
        width:
            _authType == 'Sign up' ? MediaQuery.of(context).size.width - 50 : 0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: _FNameReg,
                      decoration: const InputDecoration(
                          hintText: 'First Name', border: InputBorder.none),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a first name";
                        } else {
                          return null;
                        }
                      },
                    )),
                    const VerticalDivider(),
                    Expanded(
                        child: TextFormField(
                      controller: _LNameReg,
                      decoration: const InputDecoration(
                          hintText: 'Last Name', border: InputBorder.none),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a last name";
                        } else {
                          return null;
                        }
                      },
                    )),
                  ],
                ),
              ),
              const Divider(),
              TextFormField(
                controller: _emailReg,
                decoration: const InputDecoration(
                    hintText: 'Email', border: InputBorder.none),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter an email";
                  } else {
                    return null;
                  }
                },
              ),
              const Divider(),
              TextFormField(
                obscureText: _obscureText,
                controller: _passReg,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    hintText: 'Password', border: InputBorder.none
                    //todo
                    // suffixIcon: InkWell(
                    //   onTap: _toggle,
                    //   child: Icon(
                    //     _obscureText
                    //         ? FontAwesomeIcons.eye
                    //         : FontAwesomeIcons.eyeSlash,
                    //     size: 15.0,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a password";
                  } else if (value.length < 8) {
                    return "Password must be atleast 8 characters long";
                  } else {
                    return null;
                  }
                },
              ),
              const Divider(),
              TextFormField(
                obscureText: true,
                controller: _cpassReg,
                decoration: const InputDecoration(
                    hintText: 'Confirm Password', border: InputBorder.none),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please re-enter the password";
                  } else if (value != _passReg.text) {
                    return "Password do not match";
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
    Widget notLoggedIn = SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      ClipPath(
                        clipper: ProsteThirdOrderBezierCurve(
                          position: ClipPosition.bottom,
                          list: [
                            ThirdOrderBezierCurveSection(
                              p1: const Offset(0, 300),
                              p2: const Offset(0, 120),
                              p3: Offset(
                                  MediaQuery.of(context).size.width, 300),
                              p4: Offset(
                                  MediaQuery.of(context).size.width, 120),
                            ),
                          ],
                        ),
                        child: Container(
                          height: 300,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/community.png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _authType == 'Login' ? 1.0 : 0.0,
                                child: loginSection),
                          ),
                          AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _authType == 'Sign up' ? 1.0 : 0.0,
                              child: signupSection),
                        ],
                      ),
                    ],
                  ),
                  //login/signup
                  Padding(
                    padding:
                        EdgeInsets.only(top: _authType == 'Login' ? 510 : 570),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (_authType == 'Login') {
                                      try {
                                        //Firebase sign in
                                        UserCredential userCredential =
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: _emailLogin.text,
                                                    password: _passLogin.text);
                                        if (mounted) {
                                          //sign in success
                                          final userInfo = userCredential.user;
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .signIn(userInfo);
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'user-not-found') {
                                          setState(() {
                                            logInHasError = true;
                                          });
                                          if (_emailLogin.text == '') {
                                            _loginEmailErrorText =
                                                'Please enter an email.';
                                          } else {
                                            _loginEmailErrorText =
                                                'No user found for that email.';
                                          }
                                        } else if (e.code == 'wrong-password') {
                                          setState(() {
                                            logInHasError = true;
                                          });
                                          if (_emailLogin.text == '') {
                                            _loginPasswordErrorText =
                                                'Please enter a password.';
                                          } else {
                                            _loginPasswordErrorText =
                                                'Wrong password provided for that email.';
                                          }
                                        }
                                      }
                                    } else if (_authType == 'Sign up') {
                                      final firebaseAuth =
                                          FirebaseAuth.instance;
                                      try {
                                        // Create a new user account using Firebase Authentication
                                        final authResult = await firebaseAuth
                                            .createUserWithEmailAndPassword(
                                                email: _emailReg.text,
                                                password: _passReg.text);

                                        // Create a new user document in Firestore
                                        final userData = {
                                          'name': {
                                            'first': _FNameReg.text,
                                            'last': _LNameReg.text
                                          },
                                          'email': _emailReg.text
                                        };

                                        FirestoreService().create(
                                            collection: 'users',
                                            documentId: authResult.user!.uid,
                                            data: userData);

                                        // Update the user data in the UserProvider
                                        final user = UserModel(
                                            uid: authResult.user!.uid,
                                            email: _emailReg.text,
                                            Fname: _FNameReg.text,
                                            Lname: _LNameReg.text);
                                        // ignore: use_build_context_synchronously
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setUser(user);
                                      } catch (e) {
                                        // Display an error message
                                        print('Error registering user: $e');
                                      }
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0),
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          _authType,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ))),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: InkWell(
                            child: RichText(
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                                text: _authType == 'Login'
                                    ? "Don't have an account?"
                                    : '',
                                children: [
                                  TextSpan(
                                    text: _authType == 'Login'
                                        ? ' Sign up '
                                        : ' Back to Login ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _authType =
                                    _authType == 'Login' ? 'Sign up' : 'Login';
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(top: _authType == 'Login' ? 300 : 230),
              child: Center(
                child: Text(
                  _authType,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
    Widget loggedIn = SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: ProsteBezierCurve(
                  position: ClipPosition.bottom,
                  list: [
                    BezierCurveSection(
                      start: const Offset(0, 150),
                      top: Offset(MediaQuery.of(context).size.width / 2, 225),
                      end: Offset(MediaQuery.of(context).size.width, 150),
                    ),
                  ],
                ),
                child: Container(
                  height: 225,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/community.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 125),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 80,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          AssetImage('assets/person-placeholder.png'),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
            child: Column(
              children: [
                ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                    title: userProvider.user != null
                        ? Text(
                            '${userProvider.user!.Fname} ${userProvider.user!.Lname}',
                            style: const TextStyle(color: Colors.white),
                          )
                        : null),
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                    leading: const Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                    title: userProvider.user != null
                        ? Text(
                            userProvider.user!.email,
                            style: const TextStyle(color: Colors.white),
                          )
                        : null),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          _dialogBuilder(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, elevation: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Sign out'),
                          ],
                        )))
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
        backgroundColor: Colors.black87,
        body: userProvider.user != null ? loggedIn : notLoggedIn);
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
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
              onPressed: () {
                //todo
              },
            ),
          ],
        );
      },
    );
  }
}
