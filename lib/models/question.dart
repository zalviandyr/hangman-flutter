import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class Question {
  final String question;
  final String answer;

  const Question({
    required this.question,
    required this.answer,
  });

  static Future<List<Question>> getQuestions() async {
    List<Question> questions = [];

    String value = await rootBundle.loadString('assets/json/questions.json');
    var data = jsonDecode(value);
    for (var item in data) {
      questions.add(
        Question(question: item.keys.first, answer: item.values.first),
      );
    }

    questions.shuffle();
    return questions;
  }

  @override
  String toString() {
    return 'Question: $question - $answer';
  }
}
