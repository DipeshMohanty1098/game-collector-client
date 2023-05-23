import 'package:flutter/material.dart';
import 'package:game_collector/screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_collector/screens/shared/loading.dart';
import 'package:game_collector/screens/auth/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool loading = true;
  String token;
  String displayName;
  Widget conditionalLoginPage;
  @override
  void initState() {
    checklogin().whenComplete(() => {
          setState(() {
            loading = false;
            token == null
                ? conditionalLoginPage = const Login()
                : conditionalLoginPage = HomePage(userDisplayName: displayName);
          })
        });
    super.initState();
  }

  Future checklogin() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    String displayName = sharedPreferences.getString('displayName');
    setState(() {
      this.token = token;
      this.displayName = displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading(text: "Intializing") : conditionalLoginPage;
  }
}
