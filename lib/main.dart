import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    home: SplitIt(),
  ));
}

class SplitIt extends StatefulWidget{

  @override
  State<SplitIt> createState() => _SplitItState();
}

class _SplitItState extends State<SplitIt>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
      ),
      body: Container(
        color: Colors.lime[50],
      ),
    );
  }
}

