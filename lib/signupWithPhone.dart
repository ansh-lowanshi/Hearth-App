import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution_cha/colors.dart';
import 'package:solution_cha/homepage.dart';

class signupWithPhone extends StatefulWidget {
  const signupWithPhone({super.key});

  @override
  State<signupWithPhone> createState() => _signupWithPhoneState();
}

class _signupWithPhoneState extends State<signupWithPhone> {
  final _formKey = GlobalKey<FormState>(); // To handle form validation
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _gender; // Default gender selection
  String _selectedCountryCode = '+91';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        // Save the data to Firestore under a "users" collection.
        await _firestore.collection('users').doc(user.uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'age': _ageController.text.trim(),
          'gender': _gender,
          // 'phone': _phoneController.text.trim(),
          'phone': user.phoneNumber,
          'email': _emailController.text.trim(), // email from Google sign-in
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // After storing the data, navigate to the Homepage.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
          (Route<dynamic> route) => false,
        );
      } else {
        await _firestore.collection('users').doc(user?.uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'age': _ageController.text.trim(),
          'gender': _gender,
          // 'phone': _phoneController.text.trim(),
          'phone': user?.phoneNumber,
          'email': _emailController.text.trim(), // email from Google sign-in
          'uid': user?.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
        toolbarHeight: 100,
        elevation: 5,
      ),
      backgroundColor: color3,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // First Name & Last Name fields (adjacent)
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Age & Gender fields (adjacent)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      //gender
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: ['Male', 'Female', 'Other']
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a gender';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  //phone
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email ID',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email ID';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () async {
                      await _submitData();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      elevation: 5,
                      backgroundColor: color4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Sign Up',
                        style: TextStyle(fontSize: 20, color: color3)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
