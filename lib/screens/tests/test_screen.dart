// Fichero: lib/screens/tests/test_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:adv_formacion/config/app_theme.dart';
import 'package:adv_formacion/models/models.dart';
import 'package:adv_formacion/screens/tests/test_results_screen.dart';
import 'package:adv_formacion/services/progress_service.dart';
import 'package:adv_formacion/services/question_loader.dart';
import 'package:adv_formacion/models/test_progress.dart';

class TestScreen extends StatefulWidget {
  final TestCategory category;
  final String userId; // ID del alumno
  const TestScreen({super.key, required this.category, required this.userId});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final QuestionLoaderService _questionLoader = QuestionLoaderService();
  final ProgressService _progressService = ProgressService();

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  Map<int, int> _userAnswers = {};
  bool _isLoading = true;
  String _errorMessage = '';
  Key _questionCardKey = UniqueKey();

  // 🔹 Detectar si es un test Elite Aircrew
  bool get isEliteExam =>
      widget.category.id.startsWith('elite_final') ||
          widget.category.id.startsWith('elite_general');

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    if (widget.category.questionAssetPath == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ruta de preguntas no especificada para este test.';
      });
      return;
    }

    try {
      final loadedQuestions =
      await _questionLoader.loadQuestionsFromAsset(widget.category.questionAssetPath!);
      final random = Random();

      // Mezclar preguntas y opciones
      _questions = loadedQuestions.map(_shuffleQuestionOptions).toList();
      _questions.shuffle(random);

      setState(() {
        _isLoading = false;
        if (_questions.isEmpty) {
          _errorMessage = 'No se encontraron preguntas en el archivo.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar las preguntas: $e';
      });
    }
  }

  Question _shuffleQuestionOptions(Question question) {
    final random = Random();
    List<String> shuffledOptions = List.from(question.options);
    shuffledOptions.shuffle(random);

    int newCorrectIndex = shuffledOptions.indexOf(question.options[question.correctIndex]);

    return Question(
      text: question.text,
      options: shuffledOptions,
      correctIndex: newCorrectIndex,
      id: question.id,
      topic: question.topic,
    );
  }

  void _selectAnswer(int optionIndex) {
    if (_userAnswers.containsKey(_currentQuestionIndex)) return;

    setState(() {
      _userAnswers[_currentQuestionIndex] = optionIndex;
    });

    // Guardar progreso parcial solo si no es Elite o progreso parcial normal
    final progress = TestProgress(
      testId: widget.category.id,
      title: widget.category.title,
      questionsAnswered: _userAnswers.length,
      totalQuestions: _questions.length,
      completado: _userAnswers.length == _questions.length,
      puntos: (_userAnswers.length / _questions.length) * 100,
    );

    _progressService.saveTestResult(widget.userId, progress);
  }

  void _goToNextQuestion() {
    if (!_userAnswers.containsKey(_currentQuestionIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text('Por favor, selecciona una respuesta antes de continuar.')),
      );
      return;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _questionCardKey = UniqueKey();
      });
    } else {
      _finishTest();
    }
  }

  void _finishTest() {
    int correctCount = 0;

    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].correctIndex) {
        correctCount++;
      }
    }

    // Determinar si es examen Elite Aircrew final o general
    final isEliteExam = widget.category.id.startsWith('elite_final_'); // finales
    final isEliteGeneral = widget.category.id.startsWith('elite_general_'); // generales

    bool aprobado = true;
    if (isEliteExam) {
      aprobado = correctCount >= 38; // mínimo 38 correctas para aprobar
    }
    // Para isEliteGeneral no se cambia: aprobado siempre true, solo porcentaje

    final progress = TestProgress(
      testId: widget.category.id,
      title: widget.category.title,
      questionsAnswered: _userAnswers.length,
      totalQuestions: _questions.length,
      completado: true,
      puntos: (correctCount / _questions.length) * 100,
    );

    _progressService.saveTestResult(widget.userId, progress);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TestResultsScreen(
          title: widget.category.title,
          correctCount: correctCount,
          totalQuestions: _questions.length,
          isAesaExam: false,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent)))
          : _errorMessage.isNotEmpty
          ? Center(
          child: Text(_errorMessage,
              style: const TextStyle(color: AppColors.error)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${_currentQuestionIndex + 1} de ${_questions.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                minHeight: 12,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.highlight),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder:
                  (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation);
                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
              child: _buildQuestionCard(_questions[_currentQuestionIndex]),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToNextQuestion,
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? 'SIGUIENTE PREGUNTA'
                      : 'FINALIZAR TEST',
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: _finishTest,
                child: const Text(
                  'FINALIZAR TEST AHORA',
                  style: TextStyle(
                      fontSize: 16, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    final int? selectedIndex = _userAnswers[_currentQuestionIndex];
    final bool isAnswered = selectedIndex != null;

    return Card(
      key: _questionCardKey,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 20),
            ...question.options.asMap().entries.map((entry) {
              int optionIndex = entry.key;
              String optionText = entry.value;

              Color color = AppColors.white;
              Color borderColor = AppColors.primary.withOpacity(0.3);
              Color textColor = AppColors.primaryDark;

              // 🔹 Solo mostrar colores si NO es test Elite o ya terminado
              if (isAnswered && !isEliteExam) {
                if (optionIndex == question.correctIndex) {
                  color = AppColors.highlight.withOpacity(0.1);
                  borderColor = AppColors.highlight;
                } else if (optionIndex == selectedIndex &&
                    optionIndex != question.correctIndex) {
                  color = AppColors.error.withOpacity(0.1);
                  borderColor = AppColors.error;
                } else if (optionIndex == selectedIndex) {
                  borderColor = AppColors.highlight;
                }
              } else if (optionIndex == selectedIndex) {
                borderColor = AppColors.highlight;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap:
                  (isAnswered && isEliteExam) ? null : () => _selectAnswer(optionIndex),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isAnswered
                              ? (!isEliteExam
                              ? (optionIndex == question.correctIndex
                              ? Icons.check_circle
                              : (optionIndex == selectedIndex
                              ? Icons.cancel
                              : Icons.circle_outlined))
                              : Icons.radio_button_off)
                              : (optionIndex == selectedIndex
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off),
                          color: isAnswered
                              ? (!isEliteExam
                              ? (optionIndex == question.correctIndex
                              ? AppColors.highlight
                              : (optionIndex == selectedIndex
                              ? AppColors.error
                              : Colors.grey))
                              : AppColors.primary)
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            optionText,
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor,
                              fontWeight: isAnswered && optionIndex == question.correctIndex && !isEliteExam
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
