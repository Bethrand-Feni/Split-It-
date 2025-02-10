import 'package:flutter/material.dart';
import 'pages/input.dart';
import 'pages/intro.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async{
  await dotenv.load(fileName: "assets/.env");

  runApp(MaterialApp(
      initialRoute: '/',
      routes:{
        '/' : (context) => SplashScreen(),
      }
  ));
}
