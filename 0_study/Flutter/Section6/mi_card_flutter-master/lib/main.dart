import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage("images/Profile.png"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'JJIKKYU',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 25.0,
                ),
              ),
              Text(
                'UX/UI ORIENTED DEVELOPER',
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  color: Colors.grey,
                  fontSize: 18,
                  letterSpacing: 2.5,
                ),
              ),
              SizedBox(
                width: 150.0,
                height: 40.0,
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Card(
                  color: Color.fromRGBO(0, 116, 203, 1),
                  margin: EdgeInsets.fromLTRB(67, 15, 67, 5),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 18,
                    ),
                    title: Text(
                      '010-9999-2037',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 15),
                    ),
                  )),
              Card(
                color: Color.fromRGBO(0, 116, 203, 1),
                margin: EdgeInsets.fromLTRB(67, 2, 67, 5),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.white,
                    size: 19,
                  ),
                  title: Text(
                    'jjikkyu@naver.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Source Sans Pro',
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
