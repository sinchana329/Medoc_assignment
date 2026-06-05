import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final Color color;

  const QuestionCard({
    super.key,
    required this.question,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 300,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}