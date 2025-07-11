import 'package:flutter/material.dart';
import 'main.dart';
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
// import 'TermsContentScreen.dart';

// This screen shows the drinks based on the tastes selected

class DrinkScreen extends StatefulWidget {
  final Map<String, List<String>> selectedTastes;

  const DrinkScreen({super.key, required this.selectedTastes});

  @override
  State<DrinkScreen> createState() => _DrinkScreenState();
}

class _DrinkScreenState extends State<DrinkScreen> {
  int _visibleDrinkCount = 10;
  List<Map<String, dynamic>> _recommendedDrinks = [];
  late Map<String, List<String>> _selectedTastes;

  @override
  void initState() {
    super.initState();
    _selectedTastes = widget.selectedTastes;
    _recommendedDrinks = compareDrinks(_selectedTastes);
  }

  List<Map<String, dynamic>> compareDrinks(
      Map<String, List<String>> selectedTastes) {
    List<Map<String, dynamic>> recommendedDrinks = [];

    final List<String> categoryOrder = allDrinks.keys.toList();

    for (var category in categoryOrder) {
      if (allDrinks.containsKey(category) &&
          allDrinks.containsKey(category)) {
        for (var drink in allDrinks[category]!.keys) {
          if (globalAge != null && globalAge! < 21 && category == "Alcoholic") {
            continue;
          }

          var descriptors = allDrinks[category]![drink]!;
          int matchCount = 0;

          List<String> allSelectedTastes = [];
          selectedTastes.values.forEach((list) {
            allSelectedTastes.addAll(list);
          });

          for (var descriptor in descriptors) {
            if (allSelectedTastes.any((taste) =>
                taste.toLowerCase() == descriptor.toLowerCase())) {
              matchCount++;
            }
          }

          double threshold = selectedTastes.containsKey(category) &&
                  selectedTastes[category]!.isNotEmpty
              ? selectedTastes[category]!.length * 0.5
              : 0;

          if (matchCount >= threshold) {
            // Convert to String with Null Checks:
            String? drinkName;
            drinkName = drink.toString();
          
            String? categoryName;
            categoryName = category.toString();
          
            recommendedDrinks.add({
              'drink': drinkName,
              'category': categoryName,
              'matchCount': matchCount,
            });
          }
        }
      }
    }

    recommendedDrinks.sort((a, b) {
      if (b['matchCount'] != a['matchCount']) {
        return b['matchCount'].compareTo(a['matchCount']);
      } else {
        int categoryIndexA = categoryOrder.indexOf(a['category']);
        int categoryIndexB = categoryOrder.indexOf(b['category']);
        return categoryIndexA.compareTo(categoryIndexB);
      }
    });

    return recommendedDrinks;
  }

  // ... (rest of your DrinkScreen widget code - build method, _showDrinkDialog)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recommended Drinks")),
      body: _recommendedDrinks.isEmpty
          ? const Center(child: Text("No drinks match your selected tastes."))
          : ListView.builder(
              itemCount: _visibleDrinkCount > _recommendedDrinks.length
                  ? _recommendedDrinks.length
                  : _visibleDrinkCount,
              itemBuilder: (context, index) {
                var drinkData = _recommendedDrinks[index];

                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(drinkData['drink']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline),
                        onPressed: () {
                          _showDrinkDialog(context, drinkData);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _showDrinkDialog(context, drinkData);
                  },
                  subtitle: Text(
                      "Category: ${drinkData['category']} | Match Count: ${drinkData['matchCount']}"),
                );
              },
            ),
      floatingActionButton: _recommendedDrinks.length > _visibleDrinkCount
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _visibleDrinkCount += 15;
                  if (_visibleDrinkCount > _recommendedDrinks.length) {
                    _visibleDrinkCount = _recommendedDrinks.length;
                  }
                });
              },
              child: const Text("Show More"),
            )
          : null,
    );
  }

  void _showDrinkDialog(BuildContext context, Map<String, dynamic> drinkData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(drinkData['drink']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Important for short content
            children: [
              Text(
                allDrinksDescriptions[drinkData['category']]?[drinkData['drink']] ??
                    "Description not available",
              ),
              const SizedBox(height: 8),
              const Text("Ingredients:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...(allDrinksRecipes[drinkData['category']]?[drinkData['drink']] ??
                      []) // Use allDrinksRecipes
                  .map((ingredient) => Text("- ${ingredient.trim()}"))
                  .toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

