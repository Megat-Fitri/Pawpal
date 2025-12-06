import 'dart:async';

import 'package:flutter/material.dart ';
import 'package:pawpal/Views/login_screen.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState(){
    super.initState();
    Timer(Duration(seconds:5),(){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => LoginScreen()),
        );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/pawpal.png', scale: 1,),
            ),
            Text("-PAWPAL-",
            style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold, color: Colors.pinkAccent)
            ),
            SizedBox(height: 20,),
            CircularProgressIndicator(color: Colors.pinkAccent,),
            SizedBox(height: 10,),
            Text('Meowting...', style: TextStyle(fontSize: 20,color: Colors.pinkAccent),)
          ],
          
        ),
      ),
    );
  }
}