import 'package:flutter/material.dart';
import 'TermsContentScreen.dart';
import 'RoundedFrame.dart';

class AccountScreen extends StatefulWidget {
  final VoidCallback onClose;

  const AccountScreen({super.key, required this.onClose});

  @override
  State<AccountScreen> createState() => _AccountScreenOverlayState();
}

class _AccountScreenOverlayState extends State<AccountScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: Stack(
              children: [
                RoundedFrame(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.person, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 12),
                        const Text("@Username", style: TextStyle(color: Colors.white, fontSize: 22)),
                        const SizedBox(height: 8),
                        const Text("Mike Oxlong", style: TextStyle(color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 12),
                        const Text("Favorite Drink: Whiskey Sour", style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 6),
                        const Text(
                          "Bio: Just a chill dude that loves whiskey, bourbon,\nand brandi",
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const TermsContentScreen(),
                                ));
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Edit Profile"),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const TermsContentScreen(),
                                ));
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("View T&C’s"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white70),
                        const SizedBox(height: 10),
                        const Text("Your Bar", style: TextStyle(fontSize: 20, color: Colors.white)),
                        const SizedBox(height: 10),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 6,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (_, index) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Close button — same spot as account icon
                Positioned(
                  top: 30,
                  right: 16,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/full_account.png',
                      height: 28,
                      width: 28,
                    ),
                    onPressed: widget.onClose,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}