import 'package:bims/cloud/firestore_service.dart';
import 'package:bims/firebase_options.dart';
import 'package:bims/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserProvider() {
    init();
  }

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void updateUser({String? fname, String? lname}) {
    if (_user != null) {
      _user = UserModel(
        uid: _user!.uid,
        email: _user!.email,
        fname: fname ?? _user!.fname,
        lname: lname ?? _user!.lname,
      );

      notifyListeners();
    }
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        print('User is signed in!');
        signIn(user);
      } else {
        print('User is currently signed out!');
      }
      notifyListeners();
    });
  }

  Future<void> signIn(User? user) async {
    final firestoreUserData = await FirestoreService()
        .read(collection: 'users', documentId: user!.uid);
    final userData = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      fname: firestoreUserData!['fname'],
      lname: firestoreUserData!['lname'],
    );
    if (_user == null) {
      setUser(userData);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    clearUser();
  }
}
