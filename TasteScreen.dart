import 'package:flutter/material.dart';
import 'DrinkScreen.dart';
import 'RoundedFrame.dart';
import 'AccountScreen.dart';
// import 'dart:io';
// import 'dart:math';
// import 'dart:convert';
// import 'DemographicsScreen.dart';
// import 'TermScreen.dart';
// import 'WelcomeScreen.dart';
// import 'Buttons.dart';
// import 'DrinkOfTheDay.dart';
// import 'TheBarScreen.dart';
// import 'TermsContentScreen.dart';
// import 'main.dart';



// This is the Taste Profiles Screen, the main feature of the app

class TasteScreen extends StatefulWidget {
  const TasteScreen({super.key});

  @override
  State<TasteScreen> createState() => _TasteScreenState();
}

class _TasteScreenState extends State<TasteScreen> {
  static const String categoryTaste = "Taste";
  static const String categoryTexture = "Texture/Mouthfeel";
  static const String categoryIntensity = "Intensity";
  static const String categoryTemperature = "Temperature/Sensation";
  static const String categoryOrigin = "Origin/Style/Type";
  static const String categoryOverall = "Overall Impression/Quality";

  final Map<String, List<String>> tasteCategories = {
    categoryTaste: ["Bitter", "Salty", "Spicy", "Sweet", "Tangy", "Tart"],
    categoryTexture: ["Bubbly", "Creamy", "Crisp", "Fizzy", "Icy", "Rich", "Smooth", "Velvety"],
    categoryIntensity: ["Bold", "Intense", "Light", "Mellow", "Rich", "Sharp", "Strong"],
    categoryTemperature: ["Cool", "Refreshing", "Warm"],
    categoryOrigin: [
      "Aromatic", "Caffeinated", "Citrusy", "Clean", "Earthy", "Exotic",
      "Fruity", "Herbal", "Herbaceous", "Juicy", "Nutty", "Roasty",
      "Robust", "Savory", "Tropical"
    ],
    categoryOverall: ["Balanced", "Fresh", "Hydrating", "Indulgent", "Lively", "Vibrant"]
  };

  Map<String, List<String>> selectedTastes = {};
  bool _showAccount = false;

  @override
  void initState() {
    super.initState();
    tasteCategories.forEach((category, _) {
      selectedTastes[category] = [];
    });
  }

  void toggleTasteSelection(String category, String taste) {
    setState(() {
      selectedTastes[category] ??= [];
      if (selectedTastes[category]!.contains(taste)) {
        selectedTastes[category]!.remove(taste);
      } else {
        selectedTastes[category]!.add(taste);
      }
    });
  }

  void onSubmit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrinkScreen(selectedTastes: selectedTastes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
              child: SizedBox.expand(
                child: RoundedFrame(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: tasteCategories.entries.map((entry) {
                          final category = entry.key;
                          final subcategories = entry.value;

                          return Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              unselectedWidgetColor: Colors.white70,
                            ),
                            child: ExpansionTile(
                              collapsedIconColor: Colors.white54,
                              iconColor: Colors.white,
                              title: Text(
                                category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: subcategories.map((subcategory) {
                                return CheckboxListTile(
                                  activeColor: Colors.pinkAccent,
                                  checkColor: Colors.black,
                                  title: Text(
                                    subcategory,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  value: selectedTastes[category]?.contains(subcategory) ?? false,
                                  onChanged: (bool? selected) {
                                    toggleTasteSelection(category, subcategory);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 🔒 Account Screen Overlay
            if (_showAccount)
              AccountScreen(onClose: () => setState(() => _showAccount = false)),

            // 👤 Account Button
            if (!_showAccount)
              Positioned(
                top: 30,
                right: 16,
                child: IconButton(
                  icon: Image.asset(
                    'assets/full_account.png',
                    height: 28,
                    width: 28,
                  ),
                  onPressed: () => setState(() => _showAccount = true),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: onSubmit,
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}