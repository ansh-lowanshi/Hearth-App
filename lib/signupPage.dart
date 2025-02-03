// ignore_for_file: camel_case_types

// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution_cha/homepage.dart';
import 'package:solution_cha/wrapper.dart';
import 'package:solution_cha/colors.dart';
import 'package:solution_cha/emailSignup.dart';

class firstPage extends StatefulWidget {
  const firstPage({super.key});

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _checkUserStatus();
      }
    });
  }

  void _checkUserStatus() async {
    await Future.delayed(Duration(seconds: 1));
    User? user = FirebaseAuth.instance.currentUser;
    print("Checking user status, User: ${user?.uid}");
    if (user != null) {
      // Check if user exists in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      print("User exists in Firestore: ${userDoc.exists}");
      if (userDoc.exists) {
        // User exists, navigate to HomePage
        if (mounted) {
          // ✅ Ensure widget is still in the tree
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
            (Route<dynamic> route) => false, // Clear stack
          );
        }
      } else {
        // New user, navigate to EmailSignupPage
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignupWithEmail()),
            (Route<dynamic> route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hearth",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color4,
            fontSize: 35,
          ),
        ),
        centerTitle: true,
        backgroundColor: color1,
        toolbarHeight: screenHeight * 0.13,
        elevation: 5,
      ),
      body: Container(
        color: color3,
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              // onPressed: () {
              //   Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => AuthCheck()),
              //     (route) => false,
              //   );
              // },
              onPressed: () async {
                User? user = await _authService.signInWithGoogle();
                await Future.delayed(Duration(seconds: 5));
                print("User after Google Sign-In: ${user?.uid}");
                if (user != null) {
                  _checkUserStatus();
                } else {
                  print("Google Sign-In failed or returned null user.");
                }
              },
              icon: Icon(
                Icons.email_outlined,
                size: 30,
                color: color3,
              ),
              iconAlignment: IconAlignment.start,
              label: Text(
                "Continue with Google",
                style: TextStyle(color: color3, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 60),
                elevation: 5,
                backgroundColor: color4,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.phone_enabled_outlined,
                size: 30,
                color: color3,
              ),
              iconAlignment: IconAlignment.start,
              label: Text(
                "Continue with Phone",
                style: TextStyle(color: color3, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 60),
                elevation: 5,
                backgroundColor: color4,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.person_outline,
                size: 30,
                color: color3,
              ),
              iconAlignment: IconAlignment.start,
              label: Text(
                "Continue as a guest",
                style: TextStyle(color: color3, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 60),
                elevation: 5,
                backgroundColor: color4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
