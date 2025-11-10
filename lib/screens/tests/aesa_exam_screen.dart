// Fichero: lib/screens/tests/aesa_exam_screen.dart
import 'package:adv_formacion/models/test_progress.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:adv_formacion/config/app_theme.dart';
import 'package:adv_formacion/models/models.dart';
import 'package:adv_formacion/services/question_loader.dart';
import 'package:adv_formacion/screens/tests/test_results_screen.dart';
import 'package:adv_formacion/services/progress_service.dart';

class AesaExamScreen extends StatefulWidget {
  const AesaExamScreen({super.key});

  @override
  State<AesaExamScreen> createState() => _AesaExamScreenState();
}

class _AesaExamScreenState extends State<AesaExamScreen> {
  final QuestionLoaderService _questionLoader = QuestionLoaderService();
  final ProgressService _progressService = ProgressService();

  List<Question> _fullQuestions = [];
  List<Question> _examQuestions = [];
  int _currentQuestionIndex = 0;
  Map<int, int> _userAnswers = {};
  bool _isLoading = true;
  String _errorMessage = '';
  Key _questionCardKey = UniqueKey();

  // Distribución del Examen AESA
  static const Map<String, int> _aesaDistribution = {
    'Conocimientos teóricos generales de aviación': 10,
    'Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros': 5,
    'Asistencia a los pasajeros y vigilancia de la cabina': 11,
    'Aspectos de medicina aeronáutica y primeros auxilios': 10,
    'Mercancías peligrosas': 5,
    'Aspectos generales de seguridad de navegación': 3,
    'Formación en la lucha contra incendios y humo': 3,
    'Supervivencia': 3,
  };

  final Map<String, String> _assetPaths = {
    'Conocimientos teóricos generales de aviación': 'assets/questions/tcp/conocimientos_teoricos.json',
    'Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros': 'assets/questions/tcp/normativa.json',
    'Asistencia a los pasajeros y vigilancia de la cabina': 'assets/questions/tcp/asistencia.json',
    'Aspectos de medicina aeronáutica y primeros auxilios': 'assets/questions/tcp/medicina.json',
    'Mercancías peligrosas': 'assets/questions/tcp/mercancias.json',
    'Aspectos generales de seguridad de navegación': 'assets/questions/tcp/seguridad_nav.json',
    'Formación en la lucha contra incendios y humo': 'assets/questions/tcp/incendios.json',
    'Supervivencia': 'assets/questions/tcp/supervivencia.json',
  };

  @override
  void initState() {
    super.initState();
    _loadAndGenerateExam();
  }

  Future<void> _loadAndGenerateExam() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _examQuestions.clear();
      _fullQuestions.clear();
      _currentQuestionIndex = 0;
      _userAnswers.clear();
    });

    final Random random = Random();

    try {
      for (final entry in _assetPaths.entries) {
        final topic = entry.key;
        final path = entry.value;
        final List<Question> topicQuestions = await _questionLoader.loadQuestionsFromAsset(path);

        topicQuestions.shuffle(random);

        final requiredCount = _aesaDistribution[topic] ?? topicQuestions.length;
        final countToTake = min(requiredCount, topicQuestions.length);

        _examQuestions.addAll(topicQuestions.take(countToTake));
      }

      _examQuestions.shuffle(random);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (_examQuestions.isEmpty) {
          _errorMessage = 'No se pudieron generar las preguntas para el examen.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar las preguntas: $e';
      });
    }
  }

  void _selectAnswer(int optionIndex) {
    if (_userAnswers.containsKey(_currentQuestionIndex)) return;

    setState(() {
      _userAnswers[_currentQuestionIndex] = optionIndex;
    });
  }

  void _goToNextQuestion() {
    if (!_userAnswers.containsKey(_currentQuestionIndex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una respuesta antes de avanzar.')),
      );
      return;
    }

    if (_currentQuestionIndex < _examQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _questionCardKey = UniqueKey();
      });
    } else {
      _finishExam();
    }
  }

  void _finishExam() {
    int correctCount = 0;
    for (int i = 0; i < _examQuestions.length; i++) {
      if (_userAnswers[i] == _examQuestions[i].correctIndex) {
        correctCount++;
      }
    }

    final totalQuestions = _examQuestions.length;

    final result = TestProgress(
      testId: 'aesa_exam_001',
      puntos: correctCount.toDouble(),
      completado: true,
    );

    _progressService.saveTestResult('user_adv_001', result);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TestResultsScreen(
          title: 'Examen Oficial AESA',
          correctCount: correctCount,
          totalQuestions: totalQuestions,
          isAesaExam: true,
          onRetry: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AesaExamScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _retryExam() {
    if (!mounted) return;
    _loadAndGenerateExam();
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = _examQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Examen Oficial AESA'),
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent)))
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: const TextStyle(color: AppColors.error)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${_currentQuestionIndex + 1} de $totalQuestions',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / totalQuestions,
                minHeight: 12,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.highlight),
              ),
            ),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              child: _buildQuestionCard(_examQuestions[_currentQuestionIndex]),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToNextQuestion,
                child: Text(
                  _currentQuestionIndex < totalQuestions - 1
                      ? 'SIGUIENTE PREGUNTA'
                      : 'FINALIZAR EXAMEN',
                  style: const TextStyle(fontSize: 16, color: AppColors.white),
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
              'Tema: ${question.topic}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
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

              // Solo resalta la opción seleccionada, no la correcta
              if (isAnswered && optionIndex == selectedIndex) {
                borderColor = AppColors.highlight;
              } else if (!isAnswered && optionIndex == selectedIndex) {
                borderColor = AppColors.highlight;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: isAnswered ? null : () => _selectAnswer(optionIndex),
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
                              ? (optionIndex == selectedIndex
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off)
                              : (optionIndex == selectedIndex
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off),
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            optionText,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryDark,
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
