import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

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
  final apiKey = 'AIzaSyBJoiQcj44Atm9w0lYo-URYXRTKiNZr6RE';


  double _startLat = 0.0;
  double _startLng = 0.0;

  double _endLat = 0.0;
  double _endLng = 0.0;


  int _currentStep = 0;
  double _sliderValue = 1.0;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  // Form data
  String _name = '';
  String _email = '';
  String _password = '';
  String _startAddress = '';
  String _endAddress = '';
  String _distance = '';
  bool _unleaded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Stepper( //Need to understand
              currentStep: _currentStep,
              steps: _getSteps(),
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              onStepContinue: () {
                if (_currentStep < _getSteps().length - 1) {
                  setState(() {
                    if (_currentStep == 0 &&
                        _formKey4.currentState!.validate()) {
                      _formKey4.currentState!.save();
                      _currentStep += 1;
                    } else if (_currentStep == 1 &&
                        _formKey1.currentState!.validate()) {
                      _formKey1.currentState!.save();
                      _currentStep += 1;
                    } else if (_currentStep == 2 &&
                        _formKey2.currentState!.validate()) {
                      _formKey2.currentState!.save();
                      _currentStep += 1;
                    } else if (_currentStep == 3 &&
                        _formKey3.currentState!.validate()) {
                      _formKey3.currentState!.save();
                      _currentStep += 1;
                    }
                  });
                } else {
                  if (_formKey4.currentState!.validate()) {
                    _formKey4.currentState!.save();
                    // _submit();
                  }
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _calculateDistance,
                  child: Text('Calculate Distance'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  placesAutoCompleteTextFieldStart(controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: apiKey,
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["za"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
          print("placeDetails" + prediction.lng.toString());
        },

        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));

          _startLat = prediction.lat != null ? prediction.lat as double : 0.0;
          _startLng = prediction.lng != null ? prediction.lng as double : 0.0;
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }

  placesAutoCompleteTextFieldEnd(controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: apiKey,
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["za"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
          print("placeDetails" + prediction.lng.toString());
        },

        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));

          _endLat = prediction.lat != null ? prediction.lat as double : 0.0;
          _endLng = prediction.lng != null ? prediction.lng as double : 0.0;
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
          key: _formKey4,
          child: Column(
            children: [
              placesAutoCompleteTextFieldStart(_startController),
              placesAutoCompleteTextFieldEnd(_endController),
              if (_distance.isNotEmpty) ...[
                SizedBox(height: 20),
                Text('Distance: $_distance'),
              ]
            ],
          ),
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Fuel Type'),
        content: Form(
          key: _formKey1,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _unleaded = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _unleaded ? Colors.grey[100] : Colors.grey[500],
                  ),
                  child: const Text('Unleaded'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _unleaded = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    !_unleaded ? Colors.grey[100] : Colors.grey[500],
                  ),
                  child: const Text('Diesel'),
                ),
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('L/100km'),
        content: Form(
          key: _formKey2,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Enter your cars L/100km'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onSaved: (value) { // wouldnt I need to set state?
              _email = value!; //! for?
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

  void _calculateDistance() async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$_startLat,$_startLng&destinations=$_endLat,$_endLng&key=$apiKey',
    );

    final response = await http.get(url);

    print(response);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        _distance = data['rows'][0]['elements'][0]['distance']['text'];
        // _duration = data['rows'][0]['elements'][0]['duration']['text'];
        print('Distance: ${_distance}');
        // print('Duration: $duration');

      } else {
        print('Error: ${data['status']}');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen()),
      );
    }

  //   void _submit() {
  //     // You can save data here
  //     print('Name: $_name');
  //     print('Email: $_email');
  //     print('Password: $_password');
  //     print('Start Address: $_startAddress');
  //     print('End Address: $_endAddress');
  //     print('Distance: $_distance');
  //   }
  }
}
