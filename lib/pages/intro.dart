import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitit/pages/input.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Screen',
      home: IntroScreen(),
    );
  }
}

class IntroScreen extends StatelessWidget {
  get getter => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Positioned(
              top: 100.0,
              left: 0,
              right: 0,
              child: Container(
                height: 200.0, // Set a specific height for the image container
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/scissorsmoney.png'),
                    fit: BoxFit.cover, // Ensure the image covers the container
                  )
                ),
              ),
            ),
          const Positioned(
            top: 500.0,
            left: 130,
            right: 0,
            child: Text("Split it?",
              style: TextStyle(
                fontSize: 40.0
              ),),
            ),
            Positioned(
              bottom: 50.0,
              left: 0,
              right: 0,
              child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Input()),
                    );
                  }, child: Text("->"))
                ],
              ),
              ),
            ),
        ],
      ),
    );
  }
}


