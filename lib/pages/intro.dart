import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitit/pages/input.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to the Input page (or your main page) after 3 seconds
    Timer(Duration(seconds: 15), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Input()), // Change this to your actual main screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4EEFF),
      body: Stack(
        children: [
           Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
              child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/images/car1.gif'))
            ),
          Positioned(
              bottom:-62.0,
              right: 0.0,
              child: Image.asset("assets/images/brownfloor.png")),
          const Positioned(
            top: 100.0,
            left: 70,
            right: 0,
            child: Text.rich(
               TextSpan(
                children: [
                  TextSpan(
                    text: "Split ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF304040),
                      fontSize: 52.0,
                      fontFamily: 'Edu Australia VIC WA NT Hand',
                    )
                  ),
                TextSpan(text: "It?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF309090),
                      fontFamily: 'Edu Australia VIC WA NT Hand',
                      fontSize: 52.0,
                    ),
                )
                ]
              )
            ),
          ),
          const Positioned(top: 170.0,
              left: 120.0,
              child: Text("The trip sharing app",
              style: TextStyle(
                  fontSize: 17.0,
                  color: Color(0XFF309090)
              ),))
        ],
      ),
    );
  }
}

