import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  void playAudio(int number) {
    final player = AudioCache();
    player.play('note$number.wav');
  }

  Expanded buildKey({int soundNumber, Color colorString}) {
    return Expanded(
      child: FlatButton(
        color: colorString,
        onPressed: () {
          print(colorString);
          playAudio(soundNumber);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildKey(soundNumber: 1, colorString: Colors.red),
              buildKey(soundNumber: 2, colorString: Colors.orange),
              buildKey(soundNumber: 3, colorString: Colors.yellow),
              buildKey(soundNumber: 4, colorString: Colors.green),
              buildKey(soundNumber: 5, colorString: Colors.blue[500]),
              buildKey(soundNumber: 6, colorString: Colors.blue[800]),
              buildKey(soundNumber: 7, colorString: Colors.purple),
            ],
          ),
        ),
      ),
    );
  }
}
