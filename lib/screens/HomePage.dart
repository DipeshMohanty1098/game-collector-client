import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_collector/services/auth.dart';
import 'package:game_collector/screens/auth/login.dart';
import 'package:game_collector/screens/SearchScreen.dart';

import 'shared/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.userDisplayName}) : super(key: key);
  final String userDisplayName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  String text = 'Loading..';
  void click() async {
    setState(() {
      loading = true;
      text = 'Logging you out...';
    });
    await signOutGoogle().whenComplete(() => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()))
        });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading(text: text)
        : Scaffold(
            appBar: AppBar(
              title: const Text("HomePage"),
              actions: [
                IconButton(
                    onPressed: () {
                      click();
                    },
                    icon: const Icon(Icons.power_settings_new))
              ],
            ),
            body: Center(child: Text(widget.userDisplayName)),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()));
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          );
  }
}
