import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:solution_cha/signupPage.dart';
import 'package:solution_cha/colors.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final User? user = FirebaseAuth.instance.currentUser;

  signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => firstPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  signOut();
                },
                icon: Icon(Icons.logout,size: 28,)),
          )
        ],
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
        child: Center(
          child: user != null
              ? FutureBuilder<DocumentSnapshot>(
                  // Fetch user data from Firestore
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Text("User data not found.");
                    }
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Welcome, ${userData['firstName']} ${userData['lastName']}"),
                        Text("Email: ${userData['email']}"),
                        Text("Phone: ${userData['phone']}"),
                        Text("Gender: ${userData['gender']}"),
                      ],
                    );
                  },
                )
              : const Text("No user logged in"),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     signOut();
      //   },
      //   child: Text('Sign Out'),
      // ),
    );
  }
}
