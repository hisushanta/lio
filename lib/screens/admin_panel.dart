import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qaweb/data/exam_data.dart';
import 'package:qaweb/data/models/exam.dart';
import 'package:qaweb/data/models/question.dart';
import 'package:qaweb/data/models/year.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  final List<Exam> _exams = [];
  bool _isLoading = true;
  bool _isConnected = true;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  // Exam Form Controllers
  final _examIdController = TextEditingController();
  final _examTitleController = TextEditingController();
  final _examDescController = TextEditingController();
  IconData _selectedIcon = Icons.school;
  Color _selectedColor = Colors.blue;

  // Year Form Controllers
  final _yearController = TextEditingController();
  final _questionCountController = TextEditingController(text: '100');
  String? _selectedExamId;
  List<ExamYear> _existingYears = [];

  // Question Form Controllers
  final _questionController = TextEditingController();
  final _explanationController = TextEditingController();
  final _pointController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  String? _correctAnswer;
  String? _selectedYear;
  List<ExamYear> _availableYears = [];

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _initializeData();
    _fadeController.forward();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    
    // Check Firebase connection
    _isConnected = await ExamData.checkConnection();
    if (!_isConnected) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      _exams.addAll(await ExamData.getAllExams());
    } catch (e) {
      debugPrint('Error loading exams: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _examIdController.dispose();
    _examTitleController.dispose();
    _examDescController.dispose();
    _yearController.dispose();
    _questionCountController.dispose();
    _questionController.dispose();
    _explanationController.dispose();
    _pointController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Exam Admin Panel', style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white
        )),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: !_isConnected
            ? _buildConnectionError()
            : _isLoading
                ? _buildLoading()
                : _buildContent(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildConnectionError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleController,
            child: const Icon(Icons.cloud_off, size: 64, color: Colors.red),
          ),
          const SizedBox(height: 16),
          const Text(
            'No connection to Firebase',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your internet connection and try again',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _initializeData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading admin panel...',
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return IndexedStack(
      index: _currentTabIndex,
      children: [
        _buildAddExamTab(),
        _buildAddYearTab(),
        _buildAddQuestionTab(),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() => _currentTabIndex = index);
          _scaleController.reset();
          _scaleController.forward();
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: ScaleTransition(
              scale: _currentTabIndex == 0 
                ? Tween(begin: 0.8, end: 1.0).animate(_scaleController)
                : const AlwaysStoppedAnimation(1.0),
              child: const Icon(Icons.school),
            ),
            label: 'Add Exam',
          ),
          BottomNavigationBarItem(
            icon: ScaleTransition(
              scale: _currentTabIndex == 1
                ? Tween(begin: 0.8, end: 1.0).animate(_scaleController)
                : const AlwaysStoppedAnimation(1.0),
              child: const Icon(Icons.calendar_today),
            ),
            label: 'Add Year',
          ),
          BottomNavigationBarItem(
            icon: ScaleTransition(
              scale: _currentTabIndex == 2
                ? Tween(begin: 0.8, end: 1.0).animate(_scaleController)
                : const AlwaysStoppedAnimation(1.0),
              child: const Icon(Icons.help_outline),
            ),
            label: 'Add Question',
          ),
        ],
      ),
    );
  }

  Widget _buildAddExamTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add New Exam',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _examIdController,
                    label: 'Exam ID',
                    hint: 'e.g. neet, jee, upsc',
                    icon: Icons.code,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _examTitleController,
                    label: 'Exam Title',
                    hint: 'e.g. NEET, JEE, UPSC',
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _examDescController,
                    label: 'Description',
                    hint: 'e.g. Medical entrance exam',
                    icon: Icons.description,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select Icon:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildIconGrid(),
                  const SizedBox(height: 24),
                  Text(
                    'Select Color:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildColorGrid(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 2,
                    ),
                    onPressed: _submitExam,
                    child: const Text(
                      'Add Exam',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddYearTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add New Year',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildExamDropdown(),
                  if (_existingYears.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Existing Years:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildYearChips(),
                  ],
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _yearController,
                    label: 'Year',
                    hint: 'e.g. 2024',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _questionCountController,
                    label: 'Question Count',
                    hint: 'e.g. 100',
                    icon: Icons.format_list_numbered,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 2,
                    ),
                    onPressed: _submitYear,
                    child: const Text(
                      'Add Year',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddQuestionTab() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Question',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildExamDropdown(
                  onChanged: (value) async {
                    setState(() {
                      _selectedExamId = value;
                      _selectedYear = null;
                      _availableYears = [];
                    });
                    if (value != null) {
                      try {
                        final years = await ExamData.getYearsForExam(value);
                        setState(() => _availableYears = years);
                      } catch (e) {
                        debugPrint('Error loading years: $e');
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildYearDropdown(),
                const SizedBox(height: 16),
                
                // Add this StreamBuilder to show points remaining
                if (_selectedExamId != null && _selectedYear != null)
                  StreamBuilder<List<Question>>(
                    stream: ExamData.getQuestionsStream(_selectedExamId!, _selectedYear!),
                    builder: (context, snapshot) {
                      final questions = snapshot.data ?? [];
                      final totalPoints = questions.fold(0, (sum, q) => sum + (q.point ?? 0));
                      final pointsLeft = 100 - totalPoints;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: pointsLeft <= 0 
                                ? Colors.red[50]
                                : Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: pointsLeft <= 0
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Points: $totalPoints/100',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: pointsLeft <= 0
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                              ),
                              Text(
                                'Points Left: ${pointsLeft > 0 ? pointsLeft : 0}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: pointsLeft <= 0
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                
                _buildTextField(
                  controller: _questionController,
                  label: 'Question Text',
                  icon: Icons.question_answer,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Options:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildTextField(
                      controller: _optionControllers[index],
                      label: 'Option ${index + 1}',
                      icon: Icons.radio_button_checked,
                      onChanged: (value) {
                        if (_correctAnswer == _optionControllers[index].text &&
                            value!.isEmpty) {
                          setState(() => _correctAnswer = null);
                        }
                        setState(() {});
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),
                _buildCorrectAnswerDropdown(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _explanationController,
                  label: 'Explanation',
                  icon: Icons.lightbulb_outline,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _pointController,
                  label: 'Point Value',
                  keyboardType: TextInputType.number,
                  icon: Icons.score,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 2,
                  ),
                  onPressed: _submitQuestion,
                  child: const Text(
                    'Add Question',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
    void Function(String?)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: Theme.of(context).primaryColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        labelStyle: const TextStyle(color: Colors.black54),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black87),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildIconGrid() {
    const icons = [
      Icons.medical_services,
      Icons.engineering,
      Icons.assignment_ind,
      Icons.business_center,
      Icons.assignment,
      Icons.school,
      Icons.science,
      Icons.calculate,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => setState(() => _selectedIcon = icons[index]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _selectedIcon == icons[index]
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedIcon == icons[index]
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: _selectedIcon == icons[index] ? 2 : 1,
              ),
            ),
            child: Icon(
              icons[index],
              size: 30,
              color: _selectedIcon == icons[index]
                  ? Theme.of(context).primaryColor
                  : Colors.grey[700],
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorGrid() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = colors[index]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _selectedColor == colors[index]
                    ? Colors.black
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _selectedColor == colors[index]
                ? const Center(child: Icon(Icons.check, color: Colors.white))
                : null,
          ),
        );
      },
    );
  }

  Widget _buildExamDropdown({void Function(String?)? onChanged}) {
    return DropdownButtonFormField<String>(
      value: _selectedExamId,
      decoration: InputDecoration(
        labelText: 'Select Exam',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(Icons.school, color: Theme.of(context).primaryColor),
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black87),
      items: _exams.map((exam) {
        return DropdownMenuItem(
          value: exam.id,
          child: Text(
            exam.title,
            style: const TextStyle(color: Colors.black87),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged(value);
        } else {
          setState(() {
            _selectedExamId = value;
            _existingYears = [];
          });
          if (value != null) {
            ExamData.getYearsForExam(value).then((years) {
              setState(() => _existingYears = years);
            });
          }
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Please select an exam';
        }
        return null;
      },
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedYear,
      decoration: InputDecoration(
        labelText: 'Select Year',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black87),
      items: _availableYears.map((year) {
        return DropdownMenuItem(
          value: year.year,
          child: Text(
            year.year,
            style: const TextStyle(color: Colors.black87),
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedYear = value),
      validator: (value) {
        if (value == null) {
          return 'Please select a year';
        }
        return null;
      },
    );
  }

  Widget _buildCorrectAnswerDropdown() {
    return DropdownButtonFormField<String>(
      value: _correctAnswer,
      decoration: InputDecoration(
        labelText: 'Correct Answer',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black87),
      items: _optionControllers
          .where((controller) => controller.text.isNotEmpty)
          .map((controller) {
        return DropdownMenuItem(
          value: controller.text,
          child: Text(
            controller.text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black87),
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _correctAnswer = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select correct answer';
        }
        return null;
      },
    );
  }

  Widget _buildYearChips() {
    return Wrap(
      spacing: 8,
      children: _existingYears.map((year) {
        return Chip(
          label: Text(
            year.year,
            style: const TextStyle(color: Colors.black87),
          ),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
        );
      }).toList(),
    );
  }

  Future<void> _submitExam() async {
    if (_examIdController.text.isEmpty ||
        _examTitleController.text.isEmpty ||
        _examDescController.text.isEmpty) {
      final snackBar = SnackBar(
        content: const Text('Please fill all fields'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.red,
        elevation: 2,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (_exams.any((exam) => exam.id == _examIdController.text.trim())) {
      final snackBar = SnackBar(
        content: const Text('Exam ID already exists'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.red,
        elevation: 2,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final newExam = Exam(
        id: _examIdController.text.trim(),
        title: _examTitleController.text.trim(),
        description: _examDescController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
      );

      await ExamData.addExam(newExam);
      if (mounted) {
        final snackBar = SnackBar(
          content: const Text('Exam added successfully!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green,
          elevation: 2,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _resetExamForm();
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(
          content: Text('Error adding exam: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.red,
          elevation: 2,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> _submitYear() async {
    if (_selectedExamId == null ||
        _yearController.text.isEmpty ||
        _questionCountController.text.isEmpty) {
      final snackBar = SnackBar(
        content: const Text('Please fill all fields'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.red,
        elevation: 2,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (_existingYears.any((y) => y.year == _yearController.text.trim())) {
      final snackBar = SnackBar(
        content: const Text('Year already exists for this exam'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.red,
        elevation: 2,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final newYear = ExamYear(
        year: _yearController.text.trim(),
        examId: _selectedExamId!,
        questionCount: int.parse(_questionCountController.text.trim()),
      );

      await ExamData.addYear(newYear);
      if (mounted) {
        final snackBar = SnackBar(
          content: const Text('Year added successfully!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green,
          elevation: 2,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _resetYearForm();
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(
          content: Text('Error adding year: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.red,
          elevation: 2,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> _submitQuestion() async {
  if (_selectedExamId == null ||
      _selectedYear == null ||
      _questionController.text.isEmpty ||
      _optionControllers.any((c) => c.text.isEmpty) ||
      _correctAnswer == null ||
      _explanationController.text.isEmpty ||
      _pointController.text.isEmpty) {
    _showErrorSnackbar('Please fill all fields');
    return;
  }

  try {
    final pointValue = int.tryParse(_pointController.text.trim()) ?? 0;
    if (pointValue <= 0) {
      _showErrorSnackbar('Point value must be greater than 0');
      return;
    }

    // Get current points (await the Future)
    final currentPoints = await ExamData.getTotalPointsForExamYear(
      _selectedExamId!,
      _selectedYear!,
    );

    if (currentPoints >= 100) {
      _showErrorSnackbar('This exam year has already reached 100 points maximum');
      return;
    }

    if (currentPoints + pointValue > 100) {
      _showErrorSnackbar(
        'Cannot add question. Adding ${pointValue} points would exceed 100 points limit '
        '(Current total: $currentPoints points)',
      );
      return;
    }

    final newQuestion = Question(
      examId: _selectedExamId!,
      year: _selectedYear!,
      questionText: _questionController.text.trim(),
      options: _optionControllers.map((c) => c.text.trim()).toList(),
      correctAnswer: _correctAnswer!,
      explanation: _explanationController.text.trim(),
      point: pointValue,
    );

    await ExamData.addQuestion(newQuestion);
    _showSuccessSnackbar('Question added successfully!');
    _resetQuestionForm();
  } catch (e) {
    _showErrorSnackbar('Error adding question: $e');
  }
}
// Add these methods to your _AdminPanelState class
void _showErrorSnackbar(String message) {
  final snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.red,
    elevation: 2,
  );
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void _showSuccessSnackbar(String message) {
  final snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.green,
    elevation: 2,
  );
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

  void _resetExamForm() {
    _examIdController.clear();
    _examTitleController.clear();
    _examDescController.clear();
    setState(() {
      _selectedIcon = Icons.school;
      _selectedColor = Colors.blue;
    });
  }

  void _resetYearForm() {
    _yearController.clear();
    _questionCountController.text = '100';
    setState(() {
      _existingYears = [];
    });
  }

  void _resetQuestionForm() {
    _questionController.clear();
    for (var controller in _optionControllers) {
      controller.clear();
    }
    _explanationController.clear();
    _pointController.clear();
    setState(() {
      _correctAnswer = null;
    });
  }
}