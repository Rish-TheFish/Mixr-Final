import 'package:flutter/material.dart';
import 'CommunitiesScreen.dart';
import 'DrinkOfTheDayScreen.dart';
import 'TasteScreen.dart';
import 'AccountScreen.dart';
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
// import 'db_helper.dart';
// import 'main.dart';



class BottomNavBar extends StatefulWidget {
  final int initialIndex;

  const BottomNavBar({Key? key, this.initialIndex = 1}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;
  bool _showAccount = false;

  final List<Widget> _screens = [
    TasteScreen(),
    DrinkOfTheDayScreen(),
    CommunityHomePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Stack(
          children: [
            // 🧠 Active tab screen
            _screens[_currentIndex],

            // 👤 Account screen overlay
            if (_showAccount)
              AccountScreen(
                onClose: () => setState(() => _showAccount = false),
              ),

            // 👤 Top-right account/close icon
            Positioned(
              top: 30,
              right: 16,
              child: IconButton(
                icon: Image.asset(
                  _showAccount
                      ? 'assets/full_account.png'
                      : 'assets/empty_account.png',
                  height: 28,
                  width: 28,
                ),
                onPressed: () => setState(() => _showAccount = !_showAccount),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),

      // 🔻 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(249, 54, 48, 48),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
          _showAccount = false; // Close account if tab changes
        }),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/empty_shaker.png', height: 30),
            activeIcon: Image.asset('assets/full_shaker.png', height: 30),
            label: 'Taste',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/empty_house.png', height: 30),
            activeIcon: Image.asset('assets/full_house.png', height: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/empty_wine_glass.png', height: 30),
            activeIcon: Image.asset('assets/full_wine_glass.png', height: 30),
            label: 'Communities',
          ),
        ],
      ),
    );
  }
}


