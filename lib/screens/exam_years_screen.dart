import 'package:flutter/material.dart';
import 'package:qaweb/data/models/year.dart';
import '../data/exam_data.dart';
import '../data/models/exam.dart';
import 'quiz_screen.dart';

class ExamYearsScreen extends StatelessWidget {
  final Exam exam;

  const ExamYearsScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final years = ExamData.getYearsForExam(exam.id);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App bar with cool gradient
          SliverAppBar(
            expandedHeight: size.height * 0.2,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                exam.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.school,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          // Content area
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final year = years[index];
                  return _YearCard(
                    year: year,
                    exam: exam,
                    color: _getCardColor(index),
                  );
                },
                childCount: years.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCardColor(int index) {
    final colors = [
      const Color(0xFF6A1B9A),
      const Color(0xFFAB47BC),
      const Color(0xFF1E88E5),
      const Color(0xFF00ACC1),
      const Color(0xFF43A047),
      const Color(0xFF7CB342),
      const Color(0xFFFB8C00),
      const Color(0xFFE53935),
    ];
    return colors[index % colors.length];
  }
}

class _YearCard extends StatelessWidget {
  final ExamYear year;
  final Exam exam;
  final Color color;

  const _YearCard({
    required this.year,
    required this.exam,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
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
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.95),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -20,
                right: -20,
                child: Icon(
                  Icons.circle,
                  size: 80,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Year with decorative underline
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          year.year.toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 3,
                          color: Colors.white.withOpacity(0.7),
                          margin: const EdgeInsets.only(top: 4),
                        ),
                      ],
                    ),
                    
                    // Question count and exam text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exam',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.help_outline,
                              size: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${year.questionCount} questions',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Start button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Start',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}