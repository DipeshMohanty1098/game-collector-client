import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_collector/screens/HomePage.dart';
import 'package:game_collector/screens/auth/login.dart';
import 'package:game_collector/services/auth.dart';
import 'package:game_collector/screens/shared/loading.dart';
import 'package:game_collector/screens/auth/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool loading = true;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() => {
          print("App Initialized!"),
          setState(() {
            loading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Provider<signInWithGoogle>
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: loading == true
            ? const Loading(text: "Initializing")
            : const Wrapper(),
      ),
    );
  }
}
