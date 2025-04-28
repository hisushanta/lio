// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Exam Prep India',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(useMaterial3: true).copyWith(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF0D47A1),
//           brightness: Brightness.light,
//         ),
//         cardTheme: CardTheme(
//           elevation: 1,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: const EdgeInsets.symmetric(vertical: 8),
//         ),
//       ),
//       home: const ExamHomePage(),
//     );
//   }
// }

// class ExamHomePage extends StatefulWidget {
//   const ExamHomePage({super.key});

//   @override
//   State<ExamHomePage> createState() => _ExamHomePageState();
// }

// class _ExamHomePageState extends State<ExamHomePage> {
//   late YoutubePlayerController _youtubeController;
//   final String _youtubeVideoId = 'dQw4w9WgXcQ'; // Replace with your video ID

//   @override
//   void initState() {
//     super.initState();
//     _initializeYoutubePlayer();

//   }

//   void _initializeYoutubePlayer() {
//     _youtubeController = YoutubePlayerController(
//       initialVideoId: _youtubeVideoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//         enableCaption: true,
//         captionLanguage: 'en',
//         disableDragSeek: false,
//         loop: false,
//         forceHD: false,
//       ),
//     )..addListener(() {
//         if (mounted) setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _youtubeController.dispose();
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 600;

//     return Scaffold(
//       backgroundColor: Colors.white, // Pure white background
//       appBar: AppBar(
//         title: const Text(
//           'Exam Prep India',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF0D47A1),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'Login',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           const SizedBox(width: 8),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: const Color(0xFF0D47A1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             onPressed: () {},
//             child: const Text('Sign Up'),
//           ),
//           const SizedBox(width: 12),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(
//                 horizontal: isSmallScreen ? 20 : 30,
//                 vertical: 24,
//               ),
//               child: Column(
//                 children: [
//                   // Centered Header Section
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Ace Your Competitive Exams',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 26 : 32,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF0D47A1),
//                           height: 1.3,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'Master your preparation with our comprehensive collection\nof previous year questions and expert guidance',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 16 : 18,
//                           color: Colors.black87,
//                           height: 1.5,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Container(
//                         width: 100,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF0D47A1).withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 32),

//                   // Video Section
//                   Column(
//                     children: [
//                       const Text(
//                         'How to Get Started',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF0D47A1),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Center(
//                         child: Container(
//                           constraints: const BoxConstraints(
//                             maxWidth: 600, // Limits video width on large screens
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.1),
//                                 spreadRadius: 1,
//                                 blurRadius: 6,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: AspectRatio(
//                               aspectRatio: 16 / 9,
//                               child: YoutubePlayer(
//                                 controller: _youtubeController,
//                                 showVideoProgressIndicator: true,
//                                 progressIndicatorColor: const Color(0xFF0D47A1),
//                                 progressColors: const ProgressBarColors(
//                                   playedColor: Color(0xFF0D47A1),
//                                   handleColor: Color(0xFF0D47A1),
//                                   bufferedColor: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       const Text(
//                         'Watch this quick tutorial to maximize your learning',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                           fontStyle: FontStyle.italic,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 40),

//                   // Exam Categories
//                   const Text(
//                     'Popular Exam Categories',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildExamCategories(isSmallScreen),
//                   const SizedBox(height: 40),

//                   // Features Section
//                   const Text(
//                     'Why Learners Choose Us',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildFeaturesSection(),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),

//           // Footer
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               border: Border(
//                 top: BorderSide(
//                   color: Colors.grey[300]!,
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       '© 2023 Exam Prep India',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.facebook, size: 20, color: Colors.blue),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.social_distance, size: 20, color: Colors.pink),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon:  Icon(Icons.score, size: 20, color: Colors.blue[700]),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'contact@examprepindia.com | +91 9876543210',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExamCategories(bool isSmallScreen) {
//     final List<Map<String, dynamic>> examCategories = [
//       {
//         'title': 'NEET',
//         'description': 'Medical entrance',
//         'icon': Icons.medical_services,
//         'color': const Color(0xFFE53935),
//       },
//       {
//         'title': 'JEE',
//         'description': 'Engineering',
//         'icon': Icons.engineering,
//         'color': const Color(0xFF3949AB),
//       },
//       {
//         'title': 'UPSC',
//         'description': 'Civil services',
//         'icon': Icons.assignment_ind,
//         'color': const Color(0xFF43A047),
//       },
//       {
//         'title': 'CAT',
//         'description': 'MBA entrance',
//         'icon': Icons.business_center,
//         'color': const Color(0xFFFB8C00),
//       },
//     ];

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isSmallScreen ? 2 : 4,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 1,
//       ),
//       itemCount: examCategories.length,
//       itemBuilder: (context, index) {
//         final exam = examCategories[index];
//         return Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(12),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => QuizScreen(
//                     examTitle: exam['title'],
//                   ),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: exam['color'].withOpacity(0.15),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       exam['icon'],
//                       color: exam['color'],
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     exam['title'],
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     exam['description'],
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFeaturesSection() {
//     final List<Map<String, dynamic>> features = [
//       {
//         'icon': Icons.library_books,
//         'title': 'Curated Content',
//         'description': 'Handpicked questions from previous years'
//       },
//       {
//         'icon': Icons.analytics,
//         'title': 'Smart Analytics',
//         'description': 'Track your strengths and weaknesses'
//       },
//       {
//         'icon': Icons.timer,
//         'title': 'Time Management',
//         'description': 'Practice with timed tests'
//       },
//       {
//         'icon': Icons.star,
//         'title': 'Expert Solutions',
//         'description': 'Detailed explanations for each question'
//       },
//     ];

//     return Column(
//       children: [
//         for (final feature in features)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Card(
//               elevation: 0,
//               color: Colors.grey[50],
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Icon(
//                       feature['icon'],
//                       size: 32,
//                       color: const Color(0xFF0D47A1),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             feature['title'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             feature['description'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// // QuizScreen remains exactly the same as before
// class QuizScreen extends StatefulWidget {
//   final String examTitle;
  
//   const QuizScreen({super.key, required this.examTitle});

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   late List<Map<String, dynamic>> questions;
//   int correctAnswersCount = 0;
//   bool quizCompleted = false;

//   @override
//   void initState() {
//     super.initState();
//     questions = _getQuestionsForExam(widget.examTitle);
//   }

//   List<Map<String, dynamic>> _getQuestionsForExam(String examTitle) {
//     if (examTitle == 'NEET') {
//       return [
//         {
//           'question': 'Which is not a liver function?',
//           'answers': [
//             'Bile production',
//             'Glycogen storage',
//             'Insulin production',
//             'Detoxification'
//           ],
//           'correctAnswer': 'Insulin production',
//           'selectedAnswer': null,
//           'showFeedback': false,
//           'explanation': 'Insulin is produced by pancreas',
//         },
//         {
//           'question': 'NO2 to N2 conversion is called:',
//           'answers': [
//             'Nitrogen fixation',
//             'Ammonification',
//             'Denitrification',
//             'Nitrogen assimilation'
//           ],
//           'correctAnswer': 'Denitrification',
//           'selectedAnswer': null,
//           'showFeedback': false,
//           'explanation': 'Denitrification reduces nitrate to nitrogen gas',
//         },
//       ];
//     } else if (examTitle == 'JEE') {
//       return [
//         {
//           'question': 'Dimensional formula for impulse:',
//           'answers': [
//             '[MLT⁻¹]',
//             '[ML²T⁻²]',
//             '[MLT⁻²]',
//             '[ML²T⁻¹]'
//           ],
//           'correctAnswer': '[MLT⁻¹]',
//           'selectedAnswer': null,
//           'showFeedback': false,
//           'explanation': 'Impulse = Force × Time = [MLT⁻¹]',
//         },
//       ];
//     } else {
//       return [
//         {
//           'question': 'Sample question for ${widget.examTitle}',
//           'answers': ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
//           'correctAnswer': 'Option 2',
//           'selectedAnswer': null,
//           'showFeedback': false,
//           'explanation': 'Sample explanation',
//         },
//       ];
//     }
//   }

//   void selectAnswer(int questionIndex, String answer) {
//     setState(() {
//       questions[questionIndex]['selectedAnswer'] = answer;
//       questions[questionIndex]['showFeedback'] = true;
//       correctAnswersCount = questions.where((q) => q['selectedAnswer'] == q['correctAnswer']).length;
//       quizCompleted = questions.every((q) => q['showFeedback']);
//     });
//   }

//   void retryQuiz() {
//     setState(() {
//       for (var question in questions) {
//         question['selectedAnswer'] = null;
//         question['showFeedback'] = false;
//       }
//       correctAnswersCount = 0;
//       quizCompleted = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 400;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.examTitle),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(isSmallScreen ? 10 : 16),
//           child: Column(
//             children: [
//               // Exam header (simplified for small screens)
//               Card(
//                 color: Theme.of(context).colorScheme.primaryContainer,
//                 child: Padding(
//                   padding: EdgeInsets.all(isSmallScreen ? 10 : 16),
//                   child: Row(
//                     children: [
//                       Icon(
//                         _getExamIcon(widget.examTitle),
//                         color: Theme.of(context).colorScheme.primary,
//                         size: isSmallScreen ? 30 : 40,
//                       ),
//                       SizedBox(width: isSmallScreen ? 10 : 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.examTitle,
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 16 : 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               _getExamDescription(widget.examTitle),
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 12 : 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
              
//               // Score and progress
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Score: $correctAnswersCount/${questions.length}',
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 14 : 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '${questions.where((q) => q['showFeedback']).length}/${questions.length}',
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 14 : 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 6),
//               LinearProgressIndicator(
//                 value: questions.where((q) => q['showFeedback']).length / questions.length,
//                 backgroundColor: Colors.grey[200],
//                 color: Theme.of(context).colorScheme.primary,
//                 minHeight: 4,
//               ),
//               const SizedBox(height: 16),
              
//               // Questions list
//               ...List.generate(questions.length, (questionIndex) {
//                 final question = questions[questionIndex];
//                 final isCorrect = question['selectedAnswer'] == question['correctAnswer'];
//                 final showFeedback = question['showFeedback'];
                
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   child: Padding(
//                     padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Question number and text
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: isSmallScreen ? 20 : 24,
//                               height: isSmallScreen ? 20 : 24,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Text(
//                                 '${questionIndex + 1}',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: isSmallScreen ? 10 : 12,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: isSmallScreen ? 8 : 12),
//                             Expanded(
//                               child: Text(
//                                 question['question'],
//                                 style: TextStyle(
//                                   fontSize: isSmallScreen ? 14 : 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
                        
//                         // Answer options
//                         ...List.generate(question['answers'].length, (answerIndex) {
//                           final answer = question['answers'][answerIndex];
//                           final isSelected = question['selectedAnswer'] == answer;
                          
//                           Color? backgroundColor;
//                           BorderSide? borderSide;
                          
//                           if (showFeedback) {
//                             if (isSelected) {
//                               backgroundColor = isCorrect 
//                                 ? Colors.green[50] 
//                                 : Colors.red[50];
//                               borderSide = BorderSide(
//                                 color: isCorrect ? Colors.green : Colors.red,
//                                 width: 1,
//                               );
//                             } else if (answer == question['correctAnswer']) {
//                               backgroundColor = Colors.green[50];
//                             }
//                           } else if (isSelected) {
//                             backgroundColor = Theme.of(context).colorScheme.primaryContainer;
//                           }
                          
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 6),
//                             child: InkWell(
//                               onTap: showFeedback 
//                                 ? null 
//                                 : () => selectAnswer(questionIndex, answer),
//                               borderRadius: BorderRadius.circular(6),
//                               child: Container(
//                                 width: double.infinity,
//                                 padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
//                                 decoration: BoxDecoration(
//                                   color: backgroundColor ?? Colors.white,
//                                   borderRadius: BorderRadius.circular(6),
//                                   border: borderSide != null 
//                                     ? Border.all(
//                                         color: borderSide.color,
//                                         width: borderSide.width,
//                                       )
//                                     : Border.all(color: Colors.grey[300]!),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: isSmallScreen ? 16 : 20,
//                                       height: isSmallScreen ? 16 : 20,
//                                       margin: EdgeInsets.only(right: isSmallScreen ? 8 : 12),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: isSelected
//                                             ? (isCorrect 
//                                                 ? Colors.green 
//                                                 : Colors.red)
//                                             : null,
//                                         border: !isSelected
//                                             ? Border.all(
//                                                 color: Colors.grey,
//                                                 width: 1.5,
//                                               )
//                                             : null,
//                                       ),
//                                       child: isSelected
//                                           ? Icon(
//                                               Icons.check,
//                                               color: Colors.white,
//                                               size: isSmallScreen ? 12 : 14,
//                                             )
//                                           : null,
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         answer,
//                                         style: TextStyle(
//                                           fontSize: isSmallScreen ? 13 : 15,
//                                           color: isSelected 
//                                               ? (isCorrect 
//                                                   ? Colors.green[800] 
//                                                   : Colors.red[800])
//                                               : null,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
                        
//                         // Feedback and explanation
//                         if (showFeedback) ...[
//                           const SizedBox(height: 8),
//                           Text(
//                             isCorrect ? 'Correct! 🎉' : 'Correct: ${question['correctAnswer']}',
//                             style: TextStyle(
//                               color: isCorrect ? Colors.green : Colors.red,
//                               fontWeight: FontWeight.bold,
//                               fontSize: isSmallScreen ? 13 : 14,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             question['explanation'],
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 12 : 13,
//                               color: Colors.grey[700],
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 );
//               }),
              
//               // Results and retry button
//               if (quizCompleted) ...[
//                 const SizedBox(height: 16),
//                 Card(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   child: Padding(
//                     padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
//                     child: Column(
//                       children: [
//                         Text(
//                           '${widget.examTitle} Completed',
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 16 : 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'Score: $correctAnswersCount/${questions.length}',
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 14 : 16,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           _getResultMessage(correctAnswersCount, questions.length),
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 12 : 14,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         ElevatedButton(
//                           onPressed: retryQuiz,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Theme.of(context).colorScheme.primary,
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: isSmallScreen ? 16 : 24, 
//                               vertical: isSmallScreen ? 10 : 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                           child: Text(
//                             'Retry Quiz',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 14 : 16,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text(
//                             'Choose Different Exam',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 13 : 14,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getExamIcon(String examTitle) {
//     switch (examTitle) {
//       case 'NEET': return Icons.medical_services;
//       case 'JEE': return Icons.engineering;
//       case 'UPSC': return Icons.assignment_ind;
//       default: return Icons.school;
//     }
//   }

//   String _getExamDescription(String examTitle) {
//     switch (examTitle) {
//       case 'NEET': return 'Biology, Chemistry, Physics';
//       case 'JEE': return 'Maths, Physics, Chemistry';
//       case 'UPSC': return 'General Studies, CSAT';
//       default: return 'Practice questions';
//     }
//   }

//   String _getResultMessage(int score, int totalQuestions) {
//     final percentage = score / totalQuestions;
//     if (percentage >= 0.8) return 'Excellent! You\'re well prepared!';
//     if (percentage >= 0.6) return 'Good job! Keep improving!';
//     if (percentage >= 0.4) return 'Review concepts again';
//     return 'Focus on weak areas';
//   }
// }
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:qaweb/screens/home_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Prep India',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          brightness: Brightness.light,
        ),
        cardTheme: CardTheme(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}