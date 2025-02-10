import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitit/pages/input.dart';




class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> calculationData;
  const ResultScreen({required this.calculationData});



  String calculateFuelShare(String distanceStr, double fuelPrice, double people, double efficiency) {
    double distance = double.parse(distanceStr.replaceAll(RegExp(r'[^0-9.]'), ''));

    double fuelCost = (distance / 100) * efficiency * fuelPrice; // Total fuel cost
    double costPerPerson = fuelCost / people; // Split cost per person

    return costPerPerson.toStringAsFixed(2); // Return as a formatted string
  }



  @override
  Widget build(BuildContext context) {
    print(calculationData);
    String cost = calculateFuelShare(
      calculationData["distance"], // Convert distance to string
      calculationData["fuelPrice"],          // Fuel price as double
      calculationData["people"],              // Number of people as int
      calculationData["efficiency"],          // Efficiency as double
    );

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
            child: Text("R${cost} is the split!",
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
                        MaterialPageRoute(builder: (context) => Input())
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

