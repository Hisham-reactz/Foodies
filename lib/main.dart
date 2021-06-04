import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'pages/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/Home.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

FirebaseAuth auth;

class MyApp extends StatefulWidget {
  final data;
  MyApp({Key key, this.data}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn = false;
  dynamic userdata;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        auth = FirebaseAuth.instance;
      });
      checkLogin();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails

    }
  }

  checkLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        setState(() {
          _loggedIn = false;
        });
      } else {
        setState(() {
          _loggedIn = true;
          userdata = {
            'name': user.displayName,
            'photo': user.photoURL,
            'id': user.uid,
            'phone': user.phoneNumber
          };
        });
      }
    });
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Foodies',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: !_loggedIn
            ? LoginPageWidget(data: {})
            : HomePageWidget(
                data: userdata,
              ),
      );
    });
  }
}
