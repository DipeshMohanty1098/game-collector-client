import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Container(
                margin: const EdgeInsets.all(10.0),
                child: Text(text, style: const TextStyle(fontSize: 25)))),
        const SpinKitWave(color: Colors.black, size: 50)
      ],
    ));
  }
}
