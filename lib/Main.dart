import 'package:flutter/material.dart';
import 'pages/input.dart';
import 'pages/result.dart';
import 'pages/intro.dart';


void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      routes:{
        '/' : (context) => IntroScreen(),
        '/input': (context) => InputScreen(),
        '/location': (context) => ResultScreen(),
      }
  ));
}
