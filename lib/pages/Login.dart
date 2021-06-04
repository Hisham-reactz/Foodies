// @dart=2.9
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';

Future<UserCredential> signInWithGoogle() async {
// Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

// Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

// Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginPageWidget extends StatefulWidget {
  final data;
  LoginPageWidget({Key key, this.data}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  FirebaseAuth auth;
  PhoneAuthCredential phn;
  bool phone = false;
  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        auth = FirebaseAuth.instance;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails

    }
  }

  fiebasePhone() async {
    print(controller.text);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + controller.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        setState(() {
          phn = credential;
        });
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = phn.smsCode;

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          width: 100.w,
          height: 100.h * 1,
          constraints: BoxConstraints(
            maxWidth: 100.w,
            maxHeight: 100.h * 1,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 175),
                child: Image.asset(
                  'assets/images/Firebase_Logo_Logomark.png',
                  width: 100.w * 0.5,
                  height: 100.h * 0.25,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 1, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 15.sp),
                    primary: Color(0xFF1389EE),
                    fixedSize: Size(85.w, 8.h),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () {
                    signInWithGoogle();
                  },
                  child: Stack(children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/gicon.png',
                          fit: BoxFit.contain,
                          width: 8.w,
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Google',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ]),
                ),
              ),
              phone
                  ? Container(
                      padding: EdgeInsets.all(2.w + 2.h),
                      child: InternationalPhoneNumberInput(
                        onFieldSubmitted: (s) {
                          setState(() {
                            phone = false;
                          });
                        },
                        onInputChanged: (PhoneNumber numberz) {},
                        onInputValidated: (bool value) {},
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: controller,
                        formatInput: false,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputBorder: OutlineInputBorder(),
                        onSaved: (PhoneNumber numberza) {},
                      ))
                  : Padding(
                      padding: EdgeInsets.fromLTRB(0, 13, 1, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 15.sp),
                          primary: Color(0xFF46C663),
                          fixedSize: Size(85.w, 8.h),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () {
                          controller.text.length == 10
                              ? fiebasePhone()
                              : setState(() {
                                  phone = true;
                                });
                        },
                        child: Stack(children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.call,
                                size: 4.h,
                              )),
                          Align(
                              alignment: Alignment.center,
                              child: Text('Phone',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))
                        ]),
                      ),
                    ),
            ],
          ),
        )),
      ),
    );
  }
}
