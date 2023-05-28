import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_collector/services/auth.dart';
import 'package:game_collector/screens/auth/login.dart';
import 'package:game_collector/screens/SearchScreen.dart';
import 'package:game_collector/services/firebaseservice.dart';
import 'package:provider/provider.dart';

import 'shared/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.firebaseUser}) : super(key: key);
  final User firebaseUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  bool countLoad = true;
  String text = 'Loading..';
  FirebaseService fbService;
  int gameCount = 0;
  @override
  void initState() {
    super.initState();
    //log(widget.firebaseUser.toString());
    fbService = FirebaseService(firebaseUser: widget.firebaseUser);
    fbService.gameCount().then((value) => {
          setState(() {
            gameCount = value;
            countLoad = false;
          })
        });
  }

  void click() async {
    setState(() {
      loading = true;
      text = 'Logging you out...';
    });
    await context.read<AuthService>().signOutGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return loading
        ? Loading(text: text)
        : Scaffold(
            appBar: AppBar(
              title: const Text("Your Dashboard"),
              actions: [
                IconButton(
                    onPressed: () {
                      click();
                    },
                    icon: const Icon(Icons.power_settings_new))
              ],
            ),
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(child: Text(firebaseUser.displayName)),
              const SizedBox(height: 20),
              countLoad
                  ? const CircularProgressIndicator()
                  : Text('Total Number of games owned: $gameCount')
            ]),
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
