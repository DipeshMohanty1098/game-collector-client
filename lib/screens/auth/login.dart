import 'package:flutter/material.dart';
import 'package:game_collector/screens/HomePage.dart';
import 'package:game_collector/services/auth.dart';
import 'package:provider/provider.dart';

import '../shared/loading.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  void click() {
    context.read<AuthService>().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading(text: "Signing you in")
        : Scaffold(
            appBar: AppBar(
              title: const Text("Login or Sign Up"),
              centerTitle: true,
            ),
            body: Center(
                child: ElevatedButton(
              child: const Text("Login or Sign Up with Google"),
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
