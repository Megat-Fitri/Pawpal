import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/Views/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool visible = true;
  bool isLoading = false;
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (width > 400) {
      width = 400;
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Register Page'),backgroundColor: Colors.pinkAccent,),
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: SizedBox(
                child: Container(
                   width: width,
                   padding: EdgeInsets.all(16.0),
                   margin: EdgeInsets.all(1.0),
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.black),
                     color: Colors.white,
                    ),
                    child: Column(
                     children: [
                     Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Image.asset('assets/pawpal.png', scale: 1),
                      ),
                     TextField(
                       controller: emailController,
                       keyboardType: TextInputType.emailAddress,
                       decoration: InputDecoration(
                         labelText: 'Email',
                         prefixIcon: Icon(Icons.email),
                         border: OutlineInputBorder(),
                       ),
                     ),
                     SizedBox(height: 10),
                     TextField(
                       controller: nameController,
                       decoration: InputDecoration(
                         labelText: 'Name',
                         prefixIcon: Icon(Icons.person),
                         border: OutlineInputBorder(),
                        ),
                      ),
                     SizedBox(height: 10),
                     TextField(
                       controller: phoneController,
                       keyboardType: TextInputType.phone,
                       decoration: InputDecoration(
                         labelText: 'Phone',
                         prefixIcon: Icon(Icons.phone),
                         border: OutlineInputBorder(),
                        ),
                      ),
                     SizedBox(height: 10),
                     TextField(
                       controller: passwordController,
                       obscureText: visible,
                       decoration: InputDecoration(
                         labelText: 'Password',
                         prefixIcon: Icon(Icons.lock),
                         suffixIcon: IconButton(
                           onPressed: () {
                             if (visible) {
                               visible = false;
                              } else {
                               visible = true;
                             }
                             setState(() {});
                            },
                           icon: Icon(Icons.visibility),
                          ),
                         border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: visible,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (visible) {
                              visible = false;
                            } else {
                              visible = true;
                            }
                            setState(() {});
                          },
                          icon: Icon(Icons.visibility),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          regDialog();
                        },
                        child: Text('Register'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an account? Login here',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                  ),
                 ),
            
                )
            ),
        ),
      ),
    );
  }

  void regDialog() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Phone number is required')));
      return;
    }

    if (!RegExp(r'^01[0-9]{8,9}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid Malaysian phone number')),
      );
      return;
    }
    if (password != confirmPassword) {
      SnackBar snackBar = const SnackBar(
        content: Text('Passwords do not match'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid email address'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Register this account?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              regUser(email, password, name, phone);
            },
            child: Text('Register'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
        content: Text('Are you sure you want to register this account?'),
      ),
    );
  }

  void regUser(String email, String password, String name, String phone) async {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Registering...'),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/api/pawpal/register_user.php'),
          body: {
            'email': email,
            'name': name,
            'phone': phone,
            'password': password,
          },
        )
        .then((response) {
          log(response.body);
          log(response.statusCode.toString());
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(jsonResponse);
            if (resarray['status'] == 'success') {
              if (!mounted) return;
              SnackBar snackBar = const SnackBar(
                content: Text('Registration successful'),
              );
              if (isLoading) {
                if (!mounted) return;
                Navigator.pop(context); // Close the loading dialog
                setState(() {
                  isLoading = false;
                });
              }
              Navigator.pop(context); // Close the registration dialog
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else {
              if (!mounted) return;
              SnackBar snackBar = SnackBar(content: Text(resarray['message']));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            if (!mounted) return;
            SnackBar snackBar = const SnackBar(
              content: Text('Registration failed. Please try again.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
        .timeout(
          Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            SnackBar snackBar = const SnackBar(
              content: Text('Request timed out. Please try again.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );

    if (isLoading) {
      if (!mounted) return;
      Navigator.pop(context); // Close the loading dialog
      setState(() {
        isLoading = false;
      });
    }
  }
}

