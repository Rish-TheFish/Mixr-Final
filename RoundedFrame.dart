import 'package:flutter/material.dart';

class RoundedFrame extends StatelessWidget {
  final Widget child;

  const RoundedFrame({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850], // Inner background color
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: child,
        ),
      ),
    );
  }
}