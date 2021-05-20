import 'package:chattie/AuthServices/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          user.uid,
        ),
      ),
    );
  }
}
