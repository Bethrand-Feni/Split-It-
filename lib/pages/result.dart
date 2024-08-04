import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitit/pages/intro.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Input screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResultScreen(),
    );
  }
}

class ResultScreen extends StatelessWidget {
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
          Positioned(
            bottom: -100,
            left: 0,
            right: 0,
            child: Container(
            height: 600.0, // Set a specific height for the image container
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/rblue.png'),
                  // Ensure the image covers the container
                )
        ))
          ),
          const Positioned(
            bottom: 300,
            left: 75,
            right: 0,
            child: Text("R40 is split",
            style: TextStyle(
              fontSize: 50
            ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => IntroScreen())
                    );
                  }, child: Text("->")),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

