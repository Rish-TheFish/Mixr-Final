import 'package:flutter/material.dart';
import 'main.dart';
import 'DemographicsScreen.dart';
import 'RoundedFrame.dart';
// import 'dart:io';
// import 'dart:math';
// import 'dart:convert';
// import 'TermScreen.dart';
// import 'WelcomeScreen.dart';
// import 'Buttons.dart';
// import 'DrinkOfTheDay.dart';
// import 'TheBarScreen.dart';
// import 'DrinkScreen.dart';
// import 'TermsContentScreen.dart';



// This is the Terms Screen which HAS to be agreed to in order to use the app


class TermScreen extends StatefulWidget {
  const TermScreen({super.key});

  @override
  State<TermScreen> createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  bool _isAgreed = globalIsAgreed;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: RoundedFrame(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Terms and Conditions for Mixr",
                      style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Effective Date: February 14, 2025",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      // Your Terms Content:
                      
                        """
                        Welcome to Mixr (the "App"), provided by Mixr ("we," "us," or "our"). By accessing or using the App, you agree to be bound by these Terms and Conditions ("Terms"). Please read them carefully.

                        1. Access to Content

                        The App provides information about drinks, including alcoholic and non-alcoholic beverages. Users of all ages may use the App. However, access to information and recommendations regarding alcoholic beverages is restricted to users who are at least 21 years of age. By using the App, you represent and warrant that you are at least 21 years of age or that you will not access the portions of the App related to alcoholic beverages if you are under 21.

                        2. Drink Recommendations

                        The App provides drink recommendations based on user-selected taste preferences. These recommendations are for informational purposes only and do not constitute professional advice. We do not guarantee the accuracy or completeness of the recommendations. For alcoholic beverages, users must be of legal drinking age. Drink responsibly.

                        3. Intellectual Property

                        The App and its content, including but not limited to text, graphics, logos, and software, are the property of [Your Company Name or Your Name] and are protected by copyright and other intellectual property laws. You may not use the App's content for any commercial purpose without our prior written consent.

                        4. Disclaimer of Warranties

                        The App is provided "as is" without any warranties of any kind, either express or implied. We do not warrant that the App will be uninterrupted, error-free, or that any defects will be corrected.

                        5. Limitation of Liability

                        To the fullest extent permitted by law, we will not be liable for any damages arising out of or in connection with your use of the App, including but not limited to direct, indirect, incidental, consequential, or punitive damages.

                        6. Governing Law

                        These Terms will be governed by and construed in accordance with the laws of The State of New Jersey, without regard to its conflict of law principles.

                        7. Changes to these Terms

                        We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the updated Terms on the App. Your continued use of the App following the posting of the updated Terms constitutes your acceptance of the changes.

                        8. Contact Us

                        If you have any questions about these Terms, please contact us at:

                        [Your Contact Information]

                        [Your Company Name or Your Name]
                        [Your Address]
                        [Your Email Address]
                        """, // Your full Terms and Conditions text here
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _isAgreed,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _isAgreed = value;
                                globalIsAgreed = value;
                              });
                            }
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "I agree to the terms and conditions",
                            style: TextStyle(color: Colors.white),
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _isAgreed
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DemographicsScreen()),
                );
              }
            : () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                }
              },
        child: Icon(_isAgreed ? Icons.arrow_forward : Icons.arrow_downward),
      ),
    );
  }
}

