import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution_cha/homepage.dart';
import 'package:solution_cha/phoneSignup.dart';

class PhoneWrapper extends StatefulWidget {
  const PhoneWrapper({super.key});

  @override
  State<PhoneWrapper> createState() => _PhoneWrapperState();
}

class _PhoneWrapperState extends State<PhoneWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Homepage();
            } else {
              return phoneSignup();
            }
          }),
    );
  }
}
