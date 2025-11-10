// Fichero: lib/models/test_progress.dart

/// Modelo de progreso del usuario en un test específico.
class TestProgress {
  final String testId;          // ID único del test
  final String title;           // Título del test (opcional)
  final int questionsAnswered;  // Número de preguntas respondidas
  final int totalQuestions;     // Total de preguntas del test
  final bool completado;        // Si el test se completó
  final double puntos;          // Puntuación final (0.0 a 1.0 o 0–100 según tu app)

  TestProgress({
    required this.testId,
    this.title = '',
    this.questionsAnswered = 0,
    this.totalQuestions = 0,
    this.completado = false,
    this.puntos = 0.0,
  });

  /// Calcula el porcentaje de progreso
  double get progreso {
    if (totalQuestions == 0) return 0.0;
    return questionsAnswered / totalQuestions;
  }

  /// Convierte el progreso en un mapa (para Firebase)
  Map<String, dynamic> toJson() {
    return {
      'testId': testId,
      'title': title,
      'questionsAnswered': questionsAnswered,
      'totalQuestions': totalQuestions,
      'completado': completado,
      'puntos': puntos,
    };
  }

  /// Crea un objeto TestProgress desde un mapa (de Firebase)
  factory TestProgress.fromJson(Map<String, dynamic> json) {
    return TestProgress(
      testId: json['testId'] ?? '',
      title: json['title'] ?? '',
      questionsAnswered: json['questionsAnswered'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      completado: json['completado'] ?? false,
      puntos: (json['puntos'] ?? 0).toDouble(),
    );
  }
}
