// lib/data/exam_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qaweb/data/models/exam.dart';
import 'package:qaweb/data/models/question.dart';
import 'package:qaweb/data/models/year.dart';

class ExamData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check Firebase connection
  static Future<bool> checkConnection() async {
    try {
      await _firestore.collection('exams').limit(1).get();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Exams Stream
  static Stream<List<Exam>> getExamsStream() {
    return _firestore.collection('exams').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Exam(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          icon: _getIconFromString(data['icon']),
          color: _getColorFromHex(data['color']),
        );
      }).toList();
    });
  }

  // Years Stream for specific exam
  static Stream<List<ExamYear>> getYearsStream(String examId) {
    return _firestore
        .collection('examYears')
        .where('examId', isEqualTo: examId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ExamYear(
          year: data['year'],
          examId: data['examId'],
          questionCount: data['questionCount'],
        );
      }).toList();
    });
  }

  // Questions Stream for specific exam/year
  static Stream<List<Question>> getQuestionsStream(String examId, String year) {
    return _firestore
        .collection('questions')
        .where('examId', isEqualTo: examId)
        .where('year', isEqualTo: year)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Question(
          examId: data['examId'],
          year: data['year'],
          questionText: data['questionText'],
          options: List<String>.from(data['options']),
          correctAnswer: data['correctAnswer'],
          explanation: data['explanation'],
        );
      }).toList();
    });
  }

  // Add new exam
  static Future<void> addExam(Exam exam) async {
    try {
      await _firestore.collection('exams').doc(exam.id).set({
        'id': exam.id,
        'title': exam.title,
        'description': exam.description,
        'icon': _getStringFromIcon(exam.icon),
        'color': _getHexFromColor(exam.color),
      });
    } catch (e) {
      throw Exception('Failed to add exam: $e');
    }
  }

  // Add new year
  static Future<void> addYear(ExamYear year) async {
    try {
      await _firestore.collection('examYears').add({
        'year': year.year,
        'examId': year.examId,
        'questionCount': year.questionCount,
      });
    } catch (e) {
      throw Exception('Failed to add year: $e');
    }
  }

  // Add new question
  static Future<void> addQuestion(Question question) async {
    try {
      await _firestore.collection('questions').add({
        'examId': question.examId,
        'year': question.year,
        'questionText': question.questionText,
        'options': question.options,
        'correctAnswer': question.correctAnswer,
        'explanation': question.explanation,
      });
    } catch (e) {
      throw Exception('Failed to add question: $e');
    }
  }


  // Get all exams for dropdowns
  static Future<List<Exam>> getAllExams() async {
    final snapshot = await _firestore.collection('exams').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Exam(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        icon: _getIconFromString(data['icon']),
        color: _getColorFromHex(data['color']),
      );
    }).toList();
  }

  // Get years for specific exam
  static Future<List<ExamYear>> getYearsForExam(String examId) async {
    final snapshot = await _firestore
        .collection('examYears')
        .where('examId', isEqualTo: examId)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ExamYear(
        year: data['year'],
        examId: data['examId'],
        questionCount: data['questionCount'],
      );
    }).toList();
  }

  // Helper methods
  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'medical_services': return Icons.medical_services;
      case 'engineering': return Icons.engineering;
      case 'assignment_ind': return Icons.assignment_ind;
      case 'business_center': return Icons.business_center;
      case 'assignment': return Icons.assignment;
      default: return Icons.help_outline;
    }
  }

  static String _getStringFromIcon(IconData icon) {
    if (icon == Icons.medical_services) return 'medical_services';
    if (icon == Icons.engineering) return 'engineering';
    if (icon == Icons.assignment_ind) return 'assignment_ind';
    if (icon == Icons.business_center) return 'business_center';
    if (icon == Icons.assignment) return 'assignment';
    return 'help_outline';
  }

  static Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static String _getHexFromColor(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}