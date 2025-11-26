import 'package:flutter/material.dart';
import '../models/user.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"), backgroundColor: Colors.pinkAccent,),
      body: Center(
        child: Text(
          "Welcome, Nana!",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
