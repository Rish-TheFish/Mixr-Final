import 'package:flutter/material.dart';
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



// This GatewayButton1 does NOT let you go to the previous screen

class GatewayButton1 extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget targetScreen; // This will hold the screen to navigate to.

  const GatewayButton1({
    Key? key,
    required this.icon,
    required this.label,
    required this.targetScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the target screen and remove all previous screens.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
          (Route<dynamic> route) => false, // This removes all previous routes from the stack
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}












// This GatewayButton DOES let you go to the previous screen

class GatewayButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget targetScreen;

  const GatewayButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.targetScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Use Navigator.push to navigate away from HomeScreen and keep it in the stack
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

