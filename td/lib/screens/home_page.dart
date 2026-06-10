import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/question_card.dart';
import '../data/questions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  void nextQuestion() {
    setState(() {
      currentIndex = Random().nextInt(questions.length);
    });
  }

  @override
  void initState() {
    super.initState();
    nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],

      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Truth & Dare",
          style: TextStyle(fontSize: 24),
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Center(
            child: QuestionCard(
              question: questions[currentIndex],
              color: currentIndex.isEven
                  ? Colors.green
                  : Colors.pink,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(140, 60),
                ),
                onPressed: nextQuestion,
                child: const Text(
                  "Completed",
                  style: TextStyle(fontSize: 20),
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(140, 60),
                ),
                onPressed: nextQuestion,
                child: const Text(
                  "Forfeit",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}