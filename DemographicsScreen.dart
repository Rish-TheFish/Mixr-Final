import 'package:flutter/material.dart';
import 'main.dart';
import 'BottomNavigationBar.dart';
import 'RoundedFrame.dart';
// import 'dart:io';
// import 'dart:math';
// import 'dart:convert';
// import 'DemographicsScreen.dart';
// import 'TermScreen.dart';
// import 'WelcomeScreen.dart';
// import 'Buttons.dart';
// import 'TheBarScreen.dart';
// import 'DrinkScreen.dart';
// import 'TermsContentScreen.dart';
// import 'DrinkoftheDayScreen.dart';


// This is the Demographics Screen

class DemographicsScreen extends StatefulWidget {
  const DemographicsScreen({super.key});

  @override
  State<DemographicsScreen> createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends State<DemographicsScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = globalName;
  int? _age = globalAge;
  String _gender = globalGender.isNotEmpty ? globalGender : 'Male';
  int? _heightFeet = globalHeightFeet;
  int? _heightInches = globalHeightInches;
  int? _weight = globalWeight;
  double? _bmi = globalBMI;
  bool _bmiCalculated = globalBMI != null;

  void _saveDemographicsData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      globalName = _name;
      globalAge = _age;
      globalGender = _gender;
      globalHeightFeet = _heightFeet;
      globalHeightInches = _heightInches;
      globalWeight = _weight;
      globalBMI = _bmi;
    }
  }

  double? _calculateBMI() {
    if (_weight == null || _heightFeet == null || _heightInches == null) return null;
    try {
      final weight = _weight!.toDouble();
      final height = (_heightFeet! * 12 + _heightInches!).toDouble();
      return (weight / (height * height)) * 703;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: RoundedFrame(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tell us about yourself",
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: const InputDecoration(labelText: "Name"),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) => value!.isEmpty ? "Please enter your name" : null,
                        onSaved: (value) => _name = value!,
                        initialValue: _name,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Age"),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter your age";
                          final age = int.tryParse(value);
                          if (age == null) return "Please enter a valid age";
                          return null;
                        },
                        onSaved: (value) => _age = int.tryParse(value!),
                        keyboardType: TextInputType.number,
                        initialValue: _age?.toString() ?? '',
                      ),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        dropdownColor: Colors.grey[900],
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(value: 'Female', child: Text('Female')),
                        ],
                        onChanged: (value) => setState(() => _gender = value!),
                        decoration: const InputDecoration(labelText: "Gender"),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Height (Feet)"),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter your height in feet";
                          final feet = int.tryParse(value);
                          if (feet == null) return "Please enter a valid number";
                          return null;
                        },
                        onSaved: (value) => _heightFeet = int.tryParse(value!),
                        keyboardType: TextInputType.number,
                        initialValue: _heightFeet?.toString() ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Height (Inches)"),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter your height in inches";
                          final inches = int.tryParse(value);
                          if (inches == null) return "Please enter a valid number";
                          return null;
                        },
                        onSaved: (value) => _heightInches = int.tryParse(value!),
                        keyboardType: TextInputType.number,
                        initialValue: _heightInches?.toString() ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Weight (lbs)"),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter your weight";
                          final weight = int.tryParse(value);
                          if (weight == null) return "Please enter a valid number";
                          return null;
                        },
                        onSaved: (value) => _weight = int.tryParse(value!),
                        keyboardType: TextInputType.number,
                        initialValue: _weight?.toString() ?? '',
                      ),

                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _bmi = _calculateBMI();
                              _bmiCalculated = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                        child: const Text("Calculate BMI"),
                      ),
                      if (_bmi != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Your BMI is: ${_bmi!.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _bmiCalculated
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  _saveDemographicsData();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BottomNavBar(initialIndex: 1),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

