import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:splitit/pages/result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue, // Active step color
          secondary: Colors.orange, // Completed step and connector color
        ),
      ),
      home: Input(),
    );
  }
}

class Input extends StatefulWidget {
  @override
  _Input createState() => _Input();
}

class _Input extends State<Input> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  String _startLat = '';
  String _startLng = '';

  String _endLat = '';
  String _endLng = '';


  int _currentStep = 0;
  double _sliderValue = 1.0;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  // Form data
  double _l100km = 0.0;
  double _people = 0.0;
  String _distance = '';
  double _priceFuel = 0.0;

  //Calculation final data
  var _split = '_____';

  //For width adaption


  @override
  Widget build(BuildContext context) {

    //For width adaption
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFE4EEFF),
      body: Stack(
        children: [
          Positioned(
            top: 65,
            left: 0,
            right: 0,
            child: Theme(
              data: ThemeData(
                colorScheme: const ColorScheme.light(
                  primary: Color(0XFF309090),
                  surface: Color(0XFF309090),
                  onSurface: Color(0XFF304040)
                  //0XFFD9D9D9

                )
              ),
              child: Stepper(
                currentStep: _currentStep,
                steps: _getSteps(),
                onStepContinue: () {
                  if (_currentStep < _getSteps().length - 1) {
                    setState(() {
                      if (_currentStep == 0 && _formKey1.currentState!.validate()) {
                        _formKey1.currentState!.save();
                        _getDistance();
                        _currentStep += 1;
                      } else if (_currentStep == 1 && _formKey2.currentState!.validate()) {
                        _formKey2.currentState!.save();
                        _currentStep += 1;
                      } else if (_currentStep == 2 && _formKey3.currentState!.validate()) {
                        _formKey3.currentState!.save();
                        _currentStep += 1;
                      } else if (_currentStep == 3) {
                        print('Triggering _calculateDistance()');
                        _calculateDistance();
                      }
                      print('Current step: $_currentStep');
                    });
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Row(
                    children: <Widget>[
                      if (_currentStep < _getSteps().length - 1)
                        Padding(
                          padding: const EdgeInsets.only(right:8.0,top: 8.0),
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // This ensures sharp corners
                              ),
                              fixedSize: Size(105, 40), // Ensure the button is square (100px by 100px)
                            ),
                            child: const Text('Continue'),
                          ),
                        ),
                      if (_currentStep == _getSteps().length - 1)
                        Padding(
                          padding: const EdgeInsets.only(top:8.0, right: 8.0),
                          child: ElevatedButton(
                            onPressed:(){
                                setState(() {
                                  _calculateDistance();
                                });
                              ;
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // This ensures sharp corners
                              ),
                              fixedSize: const Size(105, 40), // Ensure the button is square (100px by 100px)
                            ),
                            child: Text('Finish'),
                          ),
                        ),
                      if (_currentStep > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: details.onStepCancel,
                            style: ElevatedButton.styleFrom(
                              foregroundColor:Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // This ensures sharp corners
                              ),
                              fixedSize: const Size(105, 40), // Ensure the button is square (100px by 100px)
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
              bottom: 20.0,
              right: 35.0,
              child: Container(
                width: 300,
                height: 150,
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0XFFD9D9D9),
                ),
              )),
          Positioned(
                  bottom: -180.0,
                  right: 95.0,
                  child: SizedBox(
                      width: 500,
                      height: 450,
                      child: Image.asset("assets/images/tree.png"))
          ),
          Positioned(bottom: 65,
              left: 120,

              child: Text("The split is R$_split!",
              style: const TextStyle(
                color: Color(0XFF304040),
                fontSize: 21
              ),))

        ],
      ),
    );
  }

  Map<String, dynamic> _submit() {
    // You can save data here

    // print('People: $_people');
    // print('L100k/m: $_l100km');
    // print('Distance: $_distance');
    // print('fuelPrice: $_priceFuel');

   Map<String, dynamic> data = {
     'people': _people,
     'efficiency': _l100km,
     'distance': _distance,
     'fuelPrice':_priceFuel,
   };

   return data;
  }

  placesAutoCompleteTextFieldStart(controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: apiKey,
          inputDecoration: InputDecoration(
            hintText: "Start location",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          debounceTime: 400,
          countries: ["za"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("placeDetails" + prediction.lat.toString());
            print("placeDetails" + prediction.lng.toString());
            _startLat = prediction.lat.toString();
            _startLng = prediction.lng.toString();
          },

          itemClick: (Prediction prediction) {
            controller.text = prediction.description ?? "";
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description?.length ?? 0));


          },
          seperatedBuilder: Divider(),
          containerHorizontalPadding: 10,

          isCrossBtnShown: true,

          // default 600 ms ,
        ),
      ),
    );
  }

  String calculateFuelShare(String distanceStr, double fuelPrice, double people, double efficiency) {
    double distance = double.parse(distanceStr.replaceAll(RegExp(r'[^0-9.]'), ''));

    double fuelCost = (distance / 100) * efficiency * fuelPrice; // Total fuel cost
    double costPerPerson = fuelCost / people; // Split cost per person

    return costPerPerson.toStringAsFixed(2); // Return as a formatted string
  }

  placesAutoCompleteTextFieldEnd(controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: apiKey,
        inputDecoration: InputDecoration(
          hintText: "End location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["za"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
          print("placeDetails" + prediction.lng.toString());
          _endLat = prediction.lat.toString();
          _endLng = prediction.lng.toString();
        },

        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));


        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Addresses'),
        content: Form(
          key: _formKey1,
          child: Column(
            children: [
              placesAutoCompleteTextFieldStart(_startController),
              placesAutoCompleteTextFieldEnd(_endController),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Feul Price'),
        content: Form(
          key: _formKey2,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Enter the fuel price'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the current Fuel Price';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            onSaved: (value) { // wouldnt I need to set state?
              _priceFuel = double.parse(value!); //! for?
            },
          ),
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('L/100km'),
        content: Form(
          key: _formKey3,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Enter your cars L/100km'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your cars L/100km';
              }
              return null;
            },
            onSaved: (value) { // wouldnt I need to set state?
              _l100km = double.parse(value!); //! for?
            },
          ),
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('People'),
        content: Column(
          children: [
            Text(
              'People: ${_sliderValue.toInt()}',
              style: const TextStyle(fontSize: 20),
            ),
            Slider(
              value: _sliderValue,
              min: 1,
              max: 10,
              divisions: 9,
              label: _sliderValue.round().toString(),
              onChanged: (
                  double newValue) { // how does it know to equate the change to NewValue?
                setState(() {
                  _sliderValue = newValue;
                });
              },
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
  }

  void _getDistance() async {
    print("Get Button clicked!");
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$_startLat,$_startLng&destinations=$_endLat,$_endLng&key=$apiKey',
    );

    final response = await http.get(url);

    if (!mounted) return;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data['status'] == 'OK') {
        _distance = data['rows'][0]['elements'][0]['distance']['text'];
        // _duration = data['rows'][0]['elements'][0]['duration']['text'];
        print('Distance: ${_distance}');
        // print('Duration: $duration');

      } else {
        print('Error: ${data['status']}');
      }

      if (!context.mounted) return;
    }
  }



  void _calculateDistance()  {
    print("Button clicked!");
    _people = _sliderValue;
    _split = calculateFuelShare(_distance, _priceFuel, _people, _l100km);


  }


  }

