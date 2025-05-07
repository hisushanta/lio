// lib/data/exam_data.dart
import 'package:flutter/material.dart';
import 'package:qaweb/data/models/exam.dart';
import 'package:qaweb/data/models/question.dart';
import 'package:qaweb/data/models/year.dart';


class ExamData {
  static final List<Exam> exams = [
    Exam(
      id: 'neet',
      title: 'NEET',
      description: 'Medical entrance',
      icon: Icons.medical_services,
      color: const Color(0xFFE53935),
    ),
    Exam(
      id: 'jee',
      title: 'JEE',
      description: 'Engineering',
      icon: Icons.engineering,
      color: const Color(0xFF3949AB),
    ),
    Exam(
      id: 'upsc',
      title: 'UPSC',
      description: 'Civil services',
      icon: Icons.assignment_ind,
      color: const Color(0xFF43A047),
    ),
    Exam(
      id: 'cat',
      title: 'CAT',
      description: 'MBA entrance',
      icon: Icons.business_center,
      color: const Color(0xFFFB8C00),
    ),

    Exam(
      id: 'gate',
      title: 'GATE',
      description: "Public Sector Undertakings",
      icon: Icons.assignment,
      color: const Color.fromARGB(255, 251, 238, 0)
    )
  ];

  static final List<ExamYear> examYears = [
    // NEET Years
    ExamYear(year: '2024', examId: 'neet', questionCount: 180),
    ExamYear(year: '2023', examId: 'neet', questionCount: 180),
    ExamYear(year: '2022', examId: 'neet', questionCount: 180),
    ExamYear(year: '2021', examId: 'neet', questionCount: 180),
    
    // JEE Years
    ExamYear(year: '2023', examId: 'jee', questionCount: 90),
    ExamYear(year: '2022', examId: 'jee', questionCount: 90),
    ExamYear(year: '2021', examId: 'jee', questionCount: 90),
    
    // UPSC Years
    ExamYear(year: '2023', examId: 'upsc', questionCount: 100),
    ExamYear(year: '2022', examId: 'upsc', questionCount: 100),
    ExamYear(year: '2021', examId: 'upsc', questionCount: 100),
    
    // CAT Years
    ExamYear(year: '2023', examId: 'cat', questionCount: 100),
    ExamYear(year: '2022', examId: 'cat', questionCount: 100),
    ExamYear(year: '2021', examId: 'cat', questionCount: 100),
    // CAT Years
    ExamYear(year: '2023', examId: 'gate', questionCount: 100),
    ExamYear(year: '2022', examId: 'gate', questionCount: 100),
    ExamYear(year: '2021', examId: 'gate', questionCount: 100),
  ];

  static final List<Question> questions = [
    // NEET Questions
    Question(
      id: '1',
      examId: 'neet',
      year: '2023',
      questionText: 'Which is not a liver function?',
      options: [
        'Bile production',
        'Glycogen storage',
        'Insulin production',
        'Detoxification'
      ],
      correctAnswer: 'Insulin production',
      explanation: 'Insulin is produced by pancreas',
    ),
    Question(
      id: '2',
      examId: 'neet',
      year: '2023',
      questionText: 'NO2 to N2 conversion is called:',
      options: [
        'Nitrogen fixation',
        'Ammonification',
        'Denitrification',
        'Nitrogen assimilation'
      ],
      correctAnswer: 'Denitrification',
      explanation: 'Denitrification reduces nitrate to nitrogen gas',
    ),
    
    // JEE Questions
    Question(
      id: '3',
      examId: 'jee',
      year: '2023',
      questionText: 'Dimensional formula for impulse:',
      options: [
        '[MLT⁻¹]',
        '[ML²T⁻²]',
        '[MLT⁻²]',
        '[ML²T⁻¹]'
      ],
      correctAnswer: '[MLT⁻¹]',
      explanation: 'Impulse = Force × Time = [MLT⁻¹]',
    ),
    
    // UPSC Questions
    Question(
      id: '4',
      examId: 'upsc',
      year: '2023',
      questionText: 'Which article of the Indian Constitution deals with the Fundamental Right to Equality?',
      options: [
        'Article 14',
        'Article 19',
        'Article 21',
        'Article 32'
      ],
      correctAnswer: 'Article 14',
      explanation: 'Article 14 guarantees equality before law and equal protection of laws to all persons.',
    ),
    Question(
      id: '5',
      examId: 'upsc',
      year: '2023',
      questionText: 'The "Doklam" dispute was between which countries?',
      options: [
        'India and China',
        'India and Pakistan',
        'China and Bhutan',
        'India and Nepal'
      ],
      correctAnswer: 'India and China',
      explanation: 'The Doklam dispute was a military standoff between India and China in 2017.',
    ),
    
    // CAT Questions
    Question(
      id: '6',
      examId: 'cat',
      year: '2023',
      questionText: 'In a race of 1 km, A beats B by 40 meters or 8 seconds. What is B\'s speed (in m/s)?',
      options: ['5', '6', '7', '8'],
      correctAnswer: '5',
      explanation: 'B covers 40 meters in 8 seconds, so speed = 40/8 = 5 m/s',
    ),
    Question(
      id: '7',
      examId: 'cat',
      year: '2023',
      questionText: 'If "PENCIL" is coded as "RGPENK", how is "PAPER" coded in that code?',
      options: ['RCRGT', 'RCTGR', 'RCRTG', 'RCTRG'],
      correctAnswer: 'RCRGT',
      explanation: 'Each letter is moved 2 positions forward in the alphabet.',
    ),

    // GATE Questions
    Question(
      id: '1',
      examId: 'gate',
      year: '2023',
      questionText: 'Even though I had planned to go skiing with my friends, I had to ___________ at the last moment because of an injury.',
      options: ['BACK UP', 'BACK OF', 'BACK ON', 'BACK OUT'],
      correctAnswer: 'BACK OUT',
      explanation: 'Back out answer is most genune answare for this question',
    ),
    Question(
      id: '2',
      examId: 'gate',
      year: '2023',
      questionText: 'The President along with Council of Ministers, _____________ to visit india next week.',
      options: ['WISH','WISHES','WILL WISH','IS WISHING'],
      correctAnswer: 'WISHES',
      explanation: 'The president along with the council of ministers wishes to visit india next week'
    )
  ];

  static List<ExamYear> getYearsForExam(String examId) {
    return examYears.where((year) => year.examId == examId).toList();
  }

  static List<Question> getQuestionsForExamYear(String examId, String year) {
    return questions.where((q) => q.examId == examId && q.year == year).toList();
  }
}