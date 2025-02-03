import 'package:flutter/material.dart';
import 'package:solution_cha/colors.dart';

class phoneSignup extends StatefulWidget {
  const phoneSignup({super.key});

  @override
  State<phoneSignup> createState() => _phoneSignupState();
}

class _phoneSignupState extends State<phoneSignup> {
  String _selectedCountryCode = '+91';
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              //form key will be used further
              // key: _formKey, 
              child: Column(
                children: [
                  Text("Enter the Phone number",style:TextStyle(
                    fontSize: 25,
                    color: color4
                  ),),
                  SizedBox(height: 10,),
                  Text('We will send an OTP on this number',style:TextStyle(
                    fontSize: 15,
                    color: color4
                  ),),
                  SizedBox(height: 30,),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                        child: Container(
                          width: 70,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              // isExpanded: true,
                              itemHeight: 48,
                              value: _selectedCountryCode,
                              items: countryCodes.map((code) {
                                return DropdownMenuItem<String>(
                                  value: code,
                                  child: Text(code,
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCountryCode = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                   SizedBox(
                    height: 30,
                  ),

                  // Get otp button
                  ElevatedButton(
                    onPressed: () async {
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      elevation: 5,
                      backgroundColor: color4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Get OTP',
                        style: TextStyle(fontSize: 20, color: color3)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
