import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitit/pages/input.dart';


class MyApp extends StatelessWidget {//difference between stateless and stateful
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
      backgroundColor: Colors.deepPurple[100],
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset("assets/images/rwhiteup.png")
          ),
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
            top: 100.0,
            left: 120,
            right: 0,
            child: Text("Split it?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[100],
                fontFamily: 'Edu Australia VIC WA NT Hand',//TODO check if it works
                fontSize: 50.0
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


