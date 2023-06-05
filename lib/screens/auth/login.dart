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

  final googleLogo = Image.asset('assets/google_logo.png', height: 10);

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading(text: "Signing you in")
        : Scaffold(
            appBar: AppBar(
              title: const Text("Login or Sign Up"),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/ps_logo.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text("PlayStation Game Collector!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                      "Maintain all your PlayStation games in a single platform!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 20),
                Center(
                    child: ElevatedButton(
                  child: const Text("Login or Sign Up with Google"),
                  onPressed: () {
                    click();
                    setState(() {
                      loading = true;
                    });
                  },
                )),
              ],
            ),
          );
  }
}
