import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_collector/screens/HomePage.dart';
import 'package:game_collector/services/auth.dart';

import '../shared/loading.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  User user;
  bool loading = false;
  void click() {
    signInWithGoogle().then((user) => {
          this.user = user,
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage(userDisplayName: user.displayName)))
        });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading(text: "Signing you in")
        : Scaffold(
            appBar: AppBar(
              title: const Text("Login/SignUp"),
              centerTitle: true,
            ),
            body: Center(
                child: ElevatedButton(
              child: const Text("Login/Sign Up with Google"),
              onPressed: () {
                click();
                setState(() {
                  loading = true;
                });
              },
            )),
          );
  }
}
