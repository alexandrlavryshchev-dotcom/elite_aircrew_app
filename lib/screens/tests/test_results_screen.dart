import 'package:flutter/material.dart';
import 'package:adv_formacion/config/app_theme.dart';

class TestResultsScreen extends StatelessWidget {
  final String title;
  final int correctCount;
  final int totalQuestions;
  final bool isAesaExam;
  final bool isEliteExam; // 🔹 Para Elite finales
  final VoidCallback? onRetry;

  const TestResultsScreen({
    super.key,
    required this.title,
    required this.correctCount,
    required this.totalQuestions,
    this.isAesaExam = false,
    this.isEliteExam = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = totalQuestions > 0 ? (correctCount / totalQuestions) : 0.0;

    final bool isPassed = (isAesaExam || isEliteExam)
        ? (correctCount >= 38)
        : (percentage >= 0.7); // 70% para tests normales

    final Color resultColor = isPassed ? AppColors.highlight : AppColors.error;
    final String resultText = isPassed ? '¡APROBADO!' : 'SUSPENSO';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Resultados: $title'),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPassed ? Icons.check_circle_outline : Icons.cancel_outlined,
                size: 100,
                color: resultColor,
              ),
              const SizedBox(height: 20),
              Text(
                resultText,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Puntuación Obtenida',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$correctCount / $totalQuestions',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Porcentaje: ${(percentage * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.primary,
                        ),
                      ),
                      if ((isAesaExam || isEliteExam) && !isPassed)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Necesitas al menos 38 correctas para aprobar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Botón volver al dashboard
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 5,
                  ),
                  child: const Text('VOLVER AL DASHBOARD'),
                ),
              ),

              // Botón reintentar si aplica
              if ((isAesaExam || isEliteExam) && onRetry != null) ...[
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onRetry,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('REINTENTAR EXAMEN'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
