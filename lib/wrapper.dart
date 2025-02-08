import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:solution_cha/signupPage.dart';
import 'package:solution_cha/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution_cha/emailSignup.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }
  void checkUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => firstPage()),
            (Route<dynamic> route) => false);
      });
    } else {
      bool userExists = await AuthService().checkIfUserExists(user.uid);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (userExists) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepage()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignupWithEmail()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with Google
  Future<bool> checkIfUserExists(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc.exists;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("some error in wrapper.dart");
        return null;
      } // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("Google Auth Token is null");
        return null;
      }
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // await Future.delayed(Duration(milliseconds: 500));

      print("User signed in successfully: ${user?.uid}");
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          return null; // New user, needs to fill additional info
        }
      }
      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // Check if user is logged in
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Save user info in Firestore
  Future<void> saveUserInfo({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required int age,
    required String gender,
    required String countryCode,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'countryCode': countryCode,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
