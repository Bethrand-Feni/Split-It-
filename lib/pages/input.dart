import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "YOUR_API_KEY");

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Addresses'),
        content: Form(
          key: _formKey4,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Address'),
                onTap: () async {
                  Prediction? p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: "YOUR_API_KEY",
                    mode: Mode.overlay, // Mode.fullscreen
                    language: "en",
                  );
                  if (p != null) {
                    PlacesDetailsResponse detail =
                    await _places.getDetailsByPlaceId(p.placeId!);
                    setState(() {
                      _startAddress = detail.result.formattedAddress!;
                    });
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the start address';
                  }
                  return null;
                },
                controller: TextEditingController(text: _startAddress),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Address'),
                onTap: () async {
                  Prediction? p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: "YOUR_API_KEY",
                    mode: Mode.overlay, // Mode.fullscreen
                    language: "en",
                  );
                  if (p != null) {
                    PlacesDetailsResponse detail =
                    await _places.getDetailsByPlaceId(p.placeId!);
                    setState(() {
                      _endAddress = detail.result.formattedAddress!;
                    });
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the end address';
                  }
                  return null;
                },
                controller: TextEditingController(text: _endAddress),
              ),
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
                    backgroundColor: _unleaded ? Colors.grey[100] : Colors.grey[500],
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
                    backgroundColor: !_unleaded ? Colors.grey[100] : Colors.grey[500],
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
            onSaved: (value) {
              _email = value!;
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
              onChanged: (double newValue) {
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
    // final response = await http.get(Uri.parse(
    //     'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$_startAddress&destinations=$_endAddress&key=YOUR_API_KEY'));
    // final json = jsonDecode(response.body);
    // final distance = json['rows'][0]['elements'][0]['distance']['text'];
    // setState(() {
    //   _distance = distance;
    // });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen()),
    );
  }

  void _submit() {
    // You can save data here
    print('Name: $_name');
    print('Email: $_email');
    print('Password: $_password');
    print('Start Address: $_startAddress');
    print('End Address: $_endAddress');
    print('Distance: $_distance');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 25,
            right: 0,
            child: SizedBox(
              height: 100,
                width: 250,
                child: Image.asset('assets/dog.gif'))),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Stepper(
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
                    if (_currentStep == 0 && _formKey4.currentState!.validate()) {
                      _formKey4.currentState!.save();
                      _currentStep += 1;
                    } else if (_currentStep == 1 && _formKey1.currentState!.validate()) {
                      _formKey1.currentState!.save();
                      _currentStep += 1;
                    } else if (_currentStep == 2 && _formKey2.currentState!.validate()) {
                      _formKey2.currentState!.save();
                      _currentStep += 1;
                    } else if (_currentStep == 3 && _formKey3.currentState!.validate()) {
                      _formKey3.currentState!.save();
                      _currentStep += 1;
                    }
                  });
                } else {
                  if (_formKey4.currentState!.validate()) {
                    _formKey4.currentState!.save();
                    _submit();
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
}
