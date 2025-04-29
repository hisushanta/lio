import 'package:flutter/material.dart';
import '../data/models/exam.dart';
import '../data/models/question.dart';

class QuizScreen extends StatefulWidget {
  final Exam exam;
  final String year;
  final List<Question> questions;

  const QuizScreen({
    super.key,
    required this.exam,
    required this.year,
    required this.questions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuestionState> _questionStates;
  bool _quizCompleted = false;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _questionStates = widget.questions
        .map((q) => QuestionState(
              question: q,
              selectedAnswer: null,
              showSolution: false,
            ))
        .toList();
  }

  void _selectAnswer(int questionIndex, String answer) {
    if (_quizCompleted) return;

    setState(() {
      _questionStates[questionIndex].selectedAnswer = answer;
      _questionStates[questionIndex].showSolution = true;

      // Count correct answers
      _correctAnswers = _questionStates.where((qs) =>
          qs.selectedAnswer == qs.question.correctAnswer).length;

      // Check if all questions answered
      _quizCompleted = _questionStates.every((qs) => qs.selectedAnswer != null);
    });
  }

  void _retryQuiz() {
    setState(() {
      _questionStates = widget.questions
          .map((q) => QuestionState(
                question: q,
                selectedAnswer: null,
                showSolution: false,
              ))
          .toList();
      _quizCompleted = false;
      _correctAnswers = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        title: Text('${widget.exam.title} ${widget.year}'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress and score indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score: $_correctAnswers/${widget.questions.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_questionStates.where((qs) => qs.selectedAnswer != null).length}/${widget.questions.length} answered',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Questions list
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...List.generate(widget.questions.length, (index) {
                    final question = widget.questions[index];
                    final state = _questionStates[index];
                    final isCorrect = state.selectedAnswer == question.correctAnswer;
                    
                    return _buildQuestionCard(
                      context: context,
                      index: index,
                      question: question,
                      state: state,
                      isCorrect: isCorrect,
                      isSmallScreen: isSmallScreen,
                    );
                  }),
                  
                  // Results card when quiz completed
                  if (_quizCompleted) ...[
                    const SizedBox(height: 20),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Quiz Completed!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your score: $_correctAnswers/${widget.questions.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getResultMessage(_correctAnswers, widget.questions.length),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: _retryQuiz,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child: const Text('Retry Quiz'),
                                ),
                                const SizedBox(width: 16),
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Back to Exams'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required BuildContext context,
    required int index,
    required Question question,
    required QuestionState state,
    required bool isCorrect,
    required bool isSmallScreen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question number and text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: isSmallScreen ? 24 : 28,
                  height: isSmallScreen ? 24 : 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Answer options
            ...question.options.map((option) {
              final isSelected = state.selectedAnswer == option;
              final isActuallyCorrect = option == question.correctAnswer;
              
              Color? backgroundColor;
              Color? textColor;
              IconData? icon;
              Color? iconColor;
              
              if (state.showSolution) {
                if (isSelected) {
                  backgroundColor = isCorrect 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1);
                  textColor = isCorrect ? Colors.green : Colors.red;
                  icon = isCorrect ? Icons.check : Icons.close;
                  iconColor = isCorrect ? Colors.green : Colors.red;
                } else if (isActuallyCorrect) {
                  backgroundColor = Colors.green.withOpacity(0.1);
                  textColor = Colors.green;
                  icon = Icons.check;
                  iconColor = Colors.green;
                }
              } else if (isSelected) {
                backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
                textColor = Theme.of(context).colorScheme.primary;
              }
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: state.showSolution 
                      ? null 
                      : () => _selectAnswer(index, option),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: state.showSolution && isActuallyCorrect
                            ? Colors.green
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor ?? Colors.black87,
                            ),
                          ),
                        ),
                        if (icon != null)
                          Icon(icon, size: 20, color: iconColor),
                      ],
                    ),
                  ),
                ),
              );
            }),
            
            // Solution explanation
            if (state.showSolution && !isCorrect) ...[
              const SizedBox(height: 12),
              Text(
                'Solution: ${question.explanation}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getResultMessage(int score, int total) {
    final percentage = score / total;
    if (percentage >= 0.8) return 'Excellent work! You\'re well prepared!';
    if (percentage >= 0.6) return 'Good job! Keep practicing to improve!';
    if (percentage >= 0.4) return 'Not bad! Review the solutions carefully.';
    return 'Keep working at it! Focus on your weak areas.';
  }
}

class QuestionState {
  final Question question;
  String? selectedAnswer;
  bool showSolution;

  QuestionState({
    required this.question,
    required this.selectedAnswer,
    required this.showSolution,
  });
}