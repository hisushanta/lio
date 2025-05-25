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

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late List<QuestionState> _questionStates;
  bool _quizCompleted = false;
  int _totalScore = 0;
  int _maxPossibleScore = 0;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;
  final ScrollController _scrollController = ScrollController();
  final Map<int, AnimationController> _questionAnimations = {};

  @override
  void initState() {
    super.initState();
    
    // Initialize question states only if questions exist
    _questionStates = widget.questions
        .map((q) => QuestionState(
              question: q,
              selectedAnswer: null,
              showSolution: false,
            ))
        .toList();

    // Calculate max possible score
    _maxPossibleScore = widget.questions.fold(0, (sum, q) => sum + (q.point ?? 0));

    // Initialize animations for each question if they exist
    for (int i = 0; i < widget.questions.length; i++) {
      _questionAnimations[i] = AnimationController(
        duration: Duration(milliseconds: 300 + (i * 100)),
        vsync: this,
      )..forward();
    }

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _scoreController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _scoreController.dispose();
    _scrollController.dispose();
    for (var controller in _questionAnimations.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _selectAnswer(int questionIndex, String answer) {
    if (_quizCompleted || widget.questions.isEmpty) return;

    setState(() {
      _questionStates[questionIndex].selectedAnswer = answer;
      _questionStates[questionIndex].showSolution = true;

      // Calculate total score
      _totalScore = _questionStates.fold(0, (sum, qs) {
        if (qs.selectedAnswer != null && qs.selectedAnswer == qs.question.correctAnswer) {
          return sum + (qs.question.point ?? 0);
        }
        return sum;
      });

      // Check if all questions answered
      _quizCompleted = _questionStates.every((qs) => qs.selectedAnswer != null);

      // Play score animation when answer is selected
      _scoreController.reset();
      _scoreController.forward();

      // Scroll to next question if not last
      if (questionIndex < widget.questions.length - 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _calculateScrollPosition(questionIndex + 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  double _calculateScrollPosition(int questionIndex) {
    // Calculate position based on question index
    return questionIndex * 280.0; // Adjust based on your question card height
  }

  void _retryQuiz() {
    if (widget.questions.isEmpty) return;
    
    setState(() {
      _questionStates = widget.questions
          .map((q) => QuestionState(
                question: q,
                selectedAnswer: null,
                showSolution: false,
              ))
          .toList();
      _quizCompleted = false;
      _totalScore = 0;
      _progressController.reset();
      _progressController.forward();
      
      // Reset all question animations
      for (var controller in _questionAnimations.values) {
        controller.reset();
        controller.forward();
      }
      
      // Scroll back to top
      _scrollController.jumpTo(0);
    });
  }

  double _getProgressValue() {
    if (widget.questions.isEmpty) return 0;
    return _questionStates.where((qs) => qs.selectedAnswer != null).length / 
           widget.questions.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressValue = _getProgressValue();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('${widget.exam.title} ${widget.year}'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.questions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: ScaleTransition(
                  scale: _scoreAnimation,
                  child: Text(
                    '$_totalScore/$_maxPossibleScore pts',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: widget.questions.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Animated progress bar (only shown if questions exist)
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value * progressValue,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 4,
                    );
                  },
                ),

                // Questions area
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // List of all questions
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
                          );
                        }),

                        // Results card when quiz completed
                        if (_quizCompleted)
                          _buildResultsCard(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No Questions Available',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This quiz doesn\'t contain any questions yet.\nPlease check back later or try another quiz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Back to Exams'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required BuildContext context,
    required int index,
    required Question question,
    required QuestionState state,
    required bool isCorrect,
  }) {
    final theme = Theme.of(context);
    final isAnswered = state.selectedAnswer != null;
    final animation = _questionAnimations[index]!;

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question header with points
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Question ${index + 1} of ${widget.questions.length}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${question.point ?? 0} pts',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isAnswered)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

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
                        icon = isCorrect ? Icons.check_circle : Icons.cancel;
                        iconColor = isCorrect ? Colors.green : Colors.red;
                      } else if (isActuallyCorrect) {
                        backgroundColor = Colors.green.withOpacity(0.1);
                        textColor = Colors.green;
                        icon = Icons.check_circle;
                        iconColor = Colors.green;
                      }
                    } else if (isSelected) {
                      backgroundColor = theme.colorScheme.primary.withOpacity(0.1);
                      textColor = theme.colorScheme.primary;
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          color: backgroundColor ?? Colors.white,
                          elevation: isSelected ? 2 : 0,
                          child: InkWell(
                            onTap: isAnswered 
                                ? null 
                                : () => _selectAnswer(index, option),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: state.showSolution && isActuallyCorrect
                                      ? Colors.green
                                      : Colors.grey[200]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor ?? Colors.black87,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  if (icon != null)
                                    Icon(icon, size: 24, color: iconColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  
                  // Solution explanation
                  if (state.showSolution && !isCorrect) 
                    AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lightbulb_outline, color: Colors.blue[700], size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Explanation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.explanation,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsCard(BuildContext context) {
    final theme = Theme.of(context);
    final scorePercentage = (_totalScore / _maxPossibleScore) * 100;

    return ScaleTransition(
      scale: _scoreAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Score circle
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getScoreColor(scorePercentage).withOpacity(0.2),
                    _getScoreColor(scorePercentage).withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_totalScore',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(scorePercentage),
                      ),
                    ),
                    Text(
                      'out of $_maxPossibleScore pts',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Result message
            Text(
              _getResultMessage(scorePercentage),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(scorePercentage),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You scored ${scorePercentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _retryQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back to Exams'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.lightGreen;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getResultMessage(double percentage) {
    if (percentage >= 80) return 'Perfect Score! 🎉';
    if (percentage >= 60) return 'Great Job! 👍';
    if (percentage >= 40) return 'Good Effort! 💪';
    return 'Keep Practicing! 📚';
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