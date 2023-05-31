import 'dart:developer';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_collector/screens/dashboard/donut_chart.dart';
import 'package:game_collector/services/auth.dart';
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
  String text = 'Loading..';
  FirebaseService fbService;
  Map<String, dynamic> gameDistribution;
  int gameCount = 0;
  @override
  void initState() {
    super.initState();
    //log(widget.firebaseUser.toString());
    fbService = FirebaseService(firebaseUser: widget.firebaseUser);
    fbService.userInfo().then((value) => {
          setState(() {
            gameDistribution = value;
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
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      click();
                    },
                    icon: const Icon(Icons.power_settings_new))
              ],
            ),
            body: Column(children: [
              const SizedBox(height: 25.0),
              Center(
                  child: Text(
                "Welcome ${firebaseUser.displayName}!",
                style: const TextStyle(fontSize: 25),
              )),
              const SizedBox(height: 20),
              const Text('Here is a quick summary of your collection'),
              const SizedBox(height: 20),
              gameDistribution == null
                  ? const Center(child: CircularProgressIndicator())
                  : Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                        child: Distribution(
                          playStation: gameDistribution['PlayStation'],
                          playStation2: gameDistribution['PlayStation 2'],
                          playStation3: gameDistribution['PlayStation 3'],
                          playStation4: gameDistribution['PlayStation 4'],
                          playStation5: gameDistribution['PlayStation 5'],
                          playStationvita: gameDistribution['PlayStation Vita'],
                          playStationportable:
                              gameDistribution['PlayStation Portable'],
                        ),
                      ),
                    ),
              const SizedBox(height: 50),
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


/*
SizedBox(
                      height: 300,
                      width: 300,
                      child: Distribution(
                        playStation: gameDistribution['PlayStation'],
                        playStation2: gameDistribution['PlayStation 2'],
                        playStation3: gameDistribution['PlayStation 3'],
                        playStation4: gameDistribution['PlayStation 4'],
                        playStation5: gameDistribution['PlayStation 5'],
                        playStationvita: gameDistribution['PlayStation Vita'],
                        playStationportable:
                            gameDistribution['PlayStation Portable'],
                      ),
                    ),
*/