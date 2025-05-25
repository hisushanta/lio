// lib/data/models/question.dart
class Question {
  final String examId;
  final String year;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final int point;

  Question({
    required this.examId,
    required this.year,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.point,
  });
}