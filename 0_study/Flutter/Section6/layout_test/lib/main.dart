import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.purple[900],
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                color: Colors.purple[100],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.purple[300],
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.purple[400],
                    ),
                  ],
                ),
              ),
              Container(
                width: 100,
                color: Colors.purple[500],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
