import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'RoundedFrame.dart';
import 'main.dart';
// import 'AccountScreen.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'DemographicsScreen.dart';
// import 'TermScreen.dart';
// import 'WelcomeScreen.dart';
// import 'Buttons.dart';
// import 'TheBarScreen.dart';
// import 'DrinkScreen.dart';
// import 'TermsContentScreen.dart';
// import 'TasteScreen.dart';
// import 'CommunitiesScreen.dart';
// import 'db_helper.dart';
// import 'BottomNavigationBar.dart';


class DrinkOfTheDayScreen extends StatefulWidget {
  const DrinkOfTheDayScreen({super.key});

  @override
  State<DrinkOfTheDayScreen> createState() => _DrinkOfTheDayScreenState();
}

// ✅ Session-persistent drink cache
Map<String, dynamic>? _cachedDrink;

class _DrinkOfTheDayScreenState extends State<DrinkOfTheDayScreen> with SingleTickerProviderStateMixin {
  int? age = globalAge;
  bool _isLoading = true;

  String drinkName = "";
  String drinkCategory = "";
  String drinkFlavors = "";
  bool drinkLoaded = false;

  final List<Map<String, String>> imageDescriptions = [
    {'vibe': 'Tart, sweet...', 'image': 'assets/regular_looking_glass.png'},
    {'vibe': 'Warm, spiky...', 'image': 'assets/champaigne.png'},
    {'vibe': 'Full-bodied, fruity...', 'image': 'assets/mint_glass.png'},
    {'vibe': 'Acidy, sweet...', 'image': 'assets/stewie_head_glass.png'},
    {'vibe': 'Savory, salty...', 'image': 'assets/v_shape_glass.png'},
    {'vibe': 'Minty, sweet...', 'image': 'assets/wine_glass.png'},
    {'vibe': 'Nutty, sweet...', 'image': 'assets/mint_glass.png'},
    {'vibe': 'Tropical, sweet...', 'image': 'assets/stewie_head_glass.png'},
  ];

  late Map<String, String> currentVisual;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _selectDrinkOfTheDay();
  }

  void _initAnimation() {
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -6.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -4.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));

    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  void _selectDrinkOfTheDay() {
    if (_cachedDrink != null) {
      setState(() {
        drinkName = _cachedDrink!['name'];
        drinkCategory = _cachedDrink!['category'];
        drinkFlavors = _cachedDrink!['flavors'];
        currentVisual = _cachedDrink!['visual'];
        _isLoading = false;
      });
      return;
    }

    final random = Random();

    if (allDrinks == null || allDrinks.isEmpty) {
      setState(() {
        drinkName = "No drinks available";
        drinkCategory = "";
        drinkFlavors = "";
        _isLoading = false;
      });
      return;
    }

    final categories = allDrinks.keys.toList();

    List<String> allowedCategories = categories.where((category) {
      if (age == null) return category != "Alcoholic";
      return age! >= 21 || category != "Alcoholic";
    }).toList();

    if (allowedCategories.isEmpty) {
      setState(() {
        drinkName = "No drinks available for your age group";
        drinkCategory = "";
        drinkFlavors = "";
        _isLoading = false;
      });
      return;
    }

    final category = allowedCategories[random.nextInt(allowedCategories.length)];
    final drinkNames = allDrinks[category]?.keys.toList();

    if (drinkNames == null || drinkNames.isEmpty) {
      setState(() {
        drinkName = "No drinks available in this category";
        drinkCategory = category;
        drinkFlavors = "";
        _isLoading = false;
      });
      return;
    }

    final selectedName = drinkNames[random.nextInt(drinkNames.length)];
    final selectedFlavors = allDrinks[category]![selectedName]?.join(", ") ?? "No flavors listed";
    final visual = imageDescriptions[random.nextInt(imageDescriptions.length)];

    _cachedDrink = {
      'name': selectedName,
      'category': category,
      'flavors': selectedFlavors,
      'visual': visual,
    };

    setState(() {
      drinkName = selectedName;
      drinkCategory = category;
      drinkFlavors = selectedFlavors;
      currentVisual = visual;
      _isLoading = false;
    });
  }

  void _shakeDrink() {
    _shakeController.forward(from: 0);
    _confettiController.play();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          /// 🎉 Confetti overlay
                          ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirectionality: BlastDirectionality.explosive,
                            shouldLoop: false,
                            emissionFrequency: 0.5,
                            numberOfParticles: 20,
                            gravity: 0.3,
                          ),

                          /// 🍹 Drink Content with Shake Animation
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AnimatedBuilder(
                                animation: _shakeAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _shakeAnimation.value),
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  currentVisual['image']!,
                                  height: 180,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                currentVisual['vibe'] ?? '',
                                style: const TextStyle(
                                  color: Colors.pinkAccent,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                drinkName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "$drinkCategory • $drinkFlavors",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              ElevatedButton(
                                onPressed: _shakeDrink,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                child: const Text("Shake it up 🍸", style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
