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
  final ageController = TextEditingController();
  final _emailLogin = TextEditingController();
  final _passLogin = TextEditingController();
  final _emailReg = TextEditingController();
  final _passReg = TextEditingController();
  final _cpassReg = TextEditingController();
  final _FNameReg = TextEditingController();
  final _LNameReg = TextEditingController();
  final _ageReg = TextEditingController();
  String _authType = 'Login';
  String? selectedGender;
  String? selectedVoter;
  bool _isLoading = false;
  String? _loginEmailErrorText;
  String? _loginPasswordErrorText;

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

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loginSection = Center(
      child: Container(
        height: _authType == 'Login' ? 112 : 0,
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
                      decoration: const InputDecoration(
                          hintText: 'First Name', border: InputBorder.none),
                    )),
                    const VerticalDivider(),
                    Expanded(
                        child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Last Name', border: InputBorder.none),
                    )),
                  ],
                ),
              ),
              const Divider(),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text('Age: '),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: ageController,
                        decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
                        cursorColor: Colors.grey,
                      ),
                    ),
                    const VerticalDivider(),
                    Radio<String>(
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: onGenderSelected,
                    ),
                    const Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: onGenderSelected,
                    ),
                    const Text('Female'),
                  ],
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Are you a registered voter?'),
                  Radio<String>(
                    value: 'Yes',
                    groupValue: selectedVoter,
                    onChanged: onVoterSelected,
                  ),
                  const Text('Yes'),
                  Radio<String>(
                    value: 'No',
                    groupValue: selectedVoter,
                    onChanged: onVoterSelected,
                  ),
                  const Text('No'),
                ],
              ),
              const Divider(),
              TextFormField(
                //controller: _email,
                decoration: const InputDecoration(
                    hintText: 'Email', border: InputBorder.none
                    //errorText: _errorText,
                    ),
                onChanged: (textt) {
                  // setState(() {
                  //   _errorText = null;
                  // });
                },
              ),
              const Divider(),
              TextFormField(
                obscureText: true,
                //controller: _email,
                decoration: const InputDecoration(
                    hintText: 'Password', border: InputBorder.none
                    //errorText: _errorText,
                    ),
                onChanged: (textt) {
                  // setState(() {
                  //   _errorText = null;
                  // });
                },
              ),
              const Divider(),
              TextFormField(
                obscureText: true,
                //controller: _email,
                decoration: const InputDecoration(
                    hintText: 'Confirm Password', border: InputBorder.none
                    //errorText: _errorText,
                    ),
                onChanged: (textt) {
                  // setState(() {
                  //   _errorText = null;
                  // });
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
                              p1: const Offset(0, 200),
                              p2: const Offset(0, 80),
                              p3: Offset(
                                  MediaQuery.of(context).size.width, 200),
                              p4: Offset(MediaQuery.of(context).size.width, 80),
                            ),
                          ],
                        ),
                        child: Container(
                          height: 200,
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
                        EdgeInsets.only(top: _authType == 'Login' ? 470 : 590),
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
                                        if (_emailLogin.text == '') {
                                          _loginEmailErrorText =
                                              'Please enter an email.';
                                        } else {
                                          _loginEmailErrorText =
                                              'No user found for that email.';
                                        }
                                      } else if (e.code == 'wrong-password') {
                                        if (_emailLogin.text == '') {
                                          _loginPasswordErrorText =
                                              'Please enter a password.';
                                        } else {
                                          _loginPasswordErrorText =
                                              'Wrong password provided for that email.';
                                        }
                                      }
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
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
              padding: EdgeInsets.only(top: _authType != 'Login' ? 145 : 260),
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
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Provider.of<UserProvider>(context).user != null
            ? const Center(
                child: Text(
                  'Logged In',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : notLoggedIn);
  }
}
