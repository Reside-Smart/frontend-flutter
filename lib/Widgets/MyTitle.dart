import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  final String title;
  const MyTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26, // Responsive font size
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
