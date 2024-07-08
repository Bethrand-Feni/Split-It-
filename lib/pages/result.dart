import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


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
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 250.0, 0.0, 0.0),
            child: Text("R40 is split",
            style: TextStyle(
              fontSize: 40
            ),),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100.0, 100.0, 0.0, 0.0),
                    child: ElevatedButton(onPressed: getter, child: Text("->")),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

