import 'package:flutter/material.dart';
import 'RoundedFrame.dart';
// import 'dart:io';
// import 'dart:math';
// import 'dart:convert';
// import 'DemographicsScreen.dart';
// import 'TermScreen.dart';
// import 'WelcomeScreen.dart';
// import 'Buttons.dart';
// import 'DrinkOfTheDay.dart';
// import 'TheBarScreen.dart';
// import 'DrinkScreen.dart';
// import 'TermsContentScreen.dart';
// import 'main.dart';





// This scren contains ONLY the terms, no agreeing

class TermsContentScreen extends StatelessWidget {
  const TermsContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: SizedBox.expand(
            child: RoundedFrame(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Terms and Conditions for Mixr",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Effective Date: February 14, 2025",
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 16),
                        Text(
                          """
Welcome to Mixr (the "App"), provided by Mixr ("we," "us," or "our"). By accessing or using the App, you agree to be bound by these Terms and Conditions ("Terms"). Please read them carefully.

1. Access to Content
The App provides information about drinks, including alcoholic and non-alcoholic beverages. Users of all ages may use the App. However, access to information and recommendations regarding alcoholic beverages is restricted to users who are at least 21 years of age...

2. Drink Recommendations
...

3. Intellectual Property
...

4. Disclaimer of Warranties
...

5. Limitation of Liability
...

6. Governing Law
...

7. Changes to these Terms
...

8. Contact Us
[Your Contact Info]
                          """,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
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

