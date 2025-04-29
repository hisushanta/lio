// lib/screens/exam_years_screen.dart
import 'package:flutter/material.dart';
import '../data/exam_data.dart';
import '../data/models/exam.dart';
import 'quiz_screen.dart';

class ExamYearsScreen extends StatelessWidget {
  final Exam exam;

  const ExamYearsScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final years = ExamData.getYearsForExam(exam.id);

    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(exam.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('${year.year} Exam'),
              subtitle: Text('${year.questionCount} questions'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                final questions = ExamData.getQuestionsForExamYear(exam.id, year.year);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      exam: exam,
                      year: year.year,
                      questions: questions,
                    ),
                  ),
                );
              },

            ),
          );
        },
      ),
    );
  }
}