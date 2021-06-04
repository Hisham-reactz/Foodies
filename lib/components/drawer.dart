import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  final data;
  AppDrawer({this.data});

  Future<void> _signOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.h * 0.25,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF60D868), Color(0xFF14B15C)],
                stops: [0, 1],
                begin: Alignment(1, 0),
                end: Alignment(-1, 0),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 17, 0, 7),
                    child: Container(
                      width: 100.w * 0.25,
                      height: 100.w * 0.25,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: data["phone"] == null
                          ? Image.network(
                              data["photo"],
                              fit: BoxFit.contain,
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                    child: Text(
                      data["phone"] == null
                          ? data["name"]
                          : data["phone"].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Text(
                    'ID : ' + data["id"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
            child: ListTile(
              onTap: () {
                // ignore: unnecessary_statements
                _signOut(context);
              },
              leading: Icon(
                Icons.logout,
              ),
              title: Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              tileColor: Color(0xFFF5F5F5),
              dense: false,
            ),
          )
        ],
      ),
    );
  }
}
