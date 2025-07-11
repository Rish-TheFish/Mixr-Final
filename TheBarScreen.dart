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


// This is the Party Mode Screen, kithcen, or checklist screen

class PartyModeScreen extends StatefulWidget {
  const PartyModeScreen({super.key});

  @override
  State<PartyModeScreen> createState() => _PartyModeScreenState();
}

class _PartyModeScreenState extends State<PartyModeScreen> {
  List<String> userIngredients = [];
  List<String> suggestedDrinks = [];
  int age = 25;
  int displayedDrinkCount = 5;
  bool showMore = false;

  final TextEditingController _ingredientController = TextEditingController();

  void _addIngredient() {
    setState(() {
      final ingredient = _ingredientController.text.trim();
      if (ingredient.isNotEmpty && !userIngredients.contains(ingredient)) {
        userIngredients.add(ingredient);
        _ingredientController.clear();
      }
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      userIngredients.removeAt(index);
    });
  }

  void _getSuggestions() {
    setState(() {
      suggestedDrinks = suggestDrinks(userIngredients, age: age);

      suggestedDrinks.sort((a, b) {
        int missingCountA = 0;
        int missingCountB = 0;

        if (a.contains("Missing:")) {
          missingCountA = a.split("Missing:")[1].split(",").length;
        }
        if (b.contains("Missing:")) {
          missingCountB = b.split("Missing:")[1].split(",").length;
        }
        return missingCountA.compareTo(missingCountB);
      });

      displayedDrinkCount = 5;
      showMore = suggestedDrinks.length > 5;
    });
  }

  List<String> suggestDrinks(List<String> userIngredients, {int? age}) {
    List<String> possibleDrinks = [];

    for (var category in allDrinksRecipes.keys) {
      for (var drinkName in allDrinksRecipes[category]!.keys) {
        var ingredients = allDrinksRecipes[category]![drinkName]!;

        if (age != null && age < 21 && category == "Alcoholic") {
          continue;
        }

        bool canMake = true;
        List<String> missingIngredients = [];

        for (var ingredient in ingredients) {
          if (!userIngredients.map((e) => e.toLowerCase()).contains(ingredient.toLowerCase())) {
            canMake = false;
            missingIngredients.add(ingredient);
          }
        }

        if (canMake) {
          possibleDrinks.add("$drinkName (You have all the ingredients!)");
        } else if (missingIngredients.isNotEmpty) {
          possibleDrinks.add("$drinkName (Missing: ${missingIngredients.join(', ')})");
        }
      }
    }

    return possibleDrinks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Party Mode"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ingredientController,
              decoration: const InputDecoration(labelText: "Enter Ingredient"),
              onSubmitted: (value) => _addIngredient(),
            ),
            ElevatedButton(
              onPressed: _addIngredient,
              child: const Text("Add Ingredient"),
            ),
            const SizedBox(height: 16),
            const Text("Your Ingredients:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: userIngredients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(userIngredients[index]),
                    trailing: IconButton(
                      onPressed: () => _removeIngredient(index),
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getSuggestions,
              child: const Text("Get Drink Suggestions"),
            ),
            const SizedBox(height: 16),
            const Text("Suggested Drinks:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              flex: 2,
              child: suggestedDrinks.isEmpty
                  ? const Center(child: Text("No suggestions yet."))
                  : ListView.builder(
                      itemCount: showMore
                          ? displayedDrinkCount + 1
                          : suggestedDrinks.length,
                      itemBuilder: (context, index) {
                        if (showMore && index == displayedDrinkCount) {
                          return TextButton(
                            onPressed: () {
                              setState(() {
                                displayedDrinkCount += 5;
                                if (displayedDrinkCount >=
                                    suggestedDrinks.length) {
                                  showMore = false;
                                }
                              });
                            },
                            child: const Text("Show More"),
                          );
                        } else {
                          return ListTile(
                            title: Text(suggestedDrinks[index]),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

