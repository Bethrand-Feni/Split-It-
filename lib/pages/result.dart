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
              bottom: -100,
              left: 0,
              right: 0,
              child: Image.asset("assets/images/rpurpled.png")),
          Positioned(
              top: 200.0,
              left: 0,
              right: 0,
              child: CircleAvatar(
                  radius: 150,
                  child: ClipOval(
                      child: Image.asset('assets/images/dog.gif',
                        fit: BoxFit.cover,
                        width: 300,
                        height: 300,)
                  )
              )
          ),
          Positioned(
            top: 100,
            left: 75,
            right: 0,
            child: Text("R40 is the split!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.deepPurple[100]
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

