import 'package:flutter/material.dart';

void main() => runApp(SetLyricPrompter());

class SetLyricPrompter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SetLyric Prompter',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: Text('SetLyric Prompter')),
        body: Center(child: Text('Welcome to SetLyric!')),
      ),
    );
  }
}
