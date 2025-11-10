// Fichero: test/unit_tests.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:adv_formacion/models/models.dart';
import 'package:adv_formacion/services/question_loader.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';

// Simulación de los archivos JSON de assets
void main() {
  // Configuración de la simulación de rootBundle (necesario para QuestionLoaderService)
  TestWidgetsFlutterBinding.ensureInitialized();

  // JSON de prueba para "conocimientos_teoricos.json" (al menos 10 preguntas para probar AESA)
  const String mockConocimientosTeoricos = '''
[
  {"id": "ct_001", "text": "P1", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_002", "text": "P2", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_003", "text": "P3", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_004", "text": "P4", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_005", "text": "P5", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_006", "text": "P6", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_007", "text": "P7", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_008", "text": "P8", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_009", "text": "P9", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_010", "text": "P10", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"},
  {"id": "ct_011", "text": "P11", "options": ["A", "B"], "correctIndex": 0, "topic": "Conocimientos teóricos generales de aviación"}
]
''';

  const String mockNormativa = '''
[
  {"id": "nor_001", "text": "N1", "options": ["A", "B"], "correctIndex": 0, "topic": "Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros"},
  {"id": "nor_002", "text": "N2", "options": ["A", "B"], "correctIndex": 0, "topic": "Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros"},
  {"id": "nor_003", "text": "N3", "options": ["A", "B"], "correctIndex": 0, "topic": "Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros"},
  {"id": "nor_004", "text": "N4", "options": ["A", "B"], "correctIndex": 0, "topic": "Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros"},
  {"id": "nor_005", "text": "N5", "options": ["A", "B"], "correctIndex": 0, "topic": "Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros"},
  {"id": "nor_006", "text": "N6", "options": ["A", "B"], "correctIndex": 0, "topic": "Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros"}
]
''';

  // Mapear las rutas de assets a los datos de prueba
  setUpAll(() {
    // Simular el cargador de assets
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
        if (methodCall.method == 'loadString') {
          final String key = methodCall.arguments['key'];
          if (key.endsWith('conocimientos_teoricos.json')) {
            return mockConocimientosTeoricos;
          } else if (key.endsWith('normativa.json')) {
            return mockNormativa;
          }
        }
        return '';
      },
    );
  });

  group('QuestionLoaderService', () {
    final loader = QuestionLoaderService();

    test('should load questions from a mock asset path', () async {
      final questions = await loader.loadQuestionsFromAsset('assets/questions/conocimientos_teoricos.json');
      expect(questions, isA<List<Question>>());
      expect(questions.length, 11);
      expect(questions.first.topic, 'Conocimientos teóricos generales de aviación');
    });

    test('should parse Question model correctly', () async {
      final questions = await loader.loadQuestionsFromAsset('assets/questions/normativa.json');
      final q = questions.first;
      expect(q.id, 'nor_001');
      expect(q.text, 'N1');
      expect(q.options.length, 2);
      expect(q.correctIndex, 0);
    });
  });

  group('AESA Exam Generation Logic', () {
    // La lógica de generación se simula aquí, ya que el código real está en el State de AesaExamScreen.

    // Distribución del Examen AESA
    const Map<String, int> aesaDistribution = {
      'Conocimientos teóricos generales de aviación': 10, // Max 11 disponibles en mock
      'Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros': 5, // Max 6 disponibles en mock
      'Asistencia a los pasajeros y vigilancia de la cabina': 11, // Mock no disponible, se esperaría 0
      'Aspectos de medicina aeronáutica y primeros auxilios': 10, // Mock no disponible, se esperaría 0
      'Mercancías peligrosas': 5, // Mock no disponible, se esperaría 0
      'Aspectos generales de seguridad de navegación': 3, // Mock no disponible, se esperaría 0
      'Formación en la lucha contra incendios y humo': 3, // Mock no disponible, se esperaría 0
      'Supervivencia': 3, // Mock no disponible, se esperaría 0
    };

    test('should generate a question list respecting AESA distribution constraints', () async {
      final loader = QuestionLoaderService();

      // 1. Cargar todas las preguntas (simuladas)
      final List<Question> fullQuestions = [];
      fullQuestions.addAll(await loader.loadQuestionsFromAsset('assets/questions/conocimientos_teoricos.json'));
      fullQuestions.addAll(await loader.loadQuestionsFromAsset('assets/questions/normativa.json'));
      // Aquí se agregarían las demás si estuvieran simuladas.

      final List<Question> generatedExam = [];
      final Random random = Random();

      for (final entry in aesaDistribution.entries) {
        final topic = entry.key;
        final requiredCount = entry.value;

        List<Question> availableQuestions = fullQuestions.where((q) => q.topic == topic).toList();

        final countToTake = min(requiredCount, availableQuestions.length);

        // Mezclar y tomar
        availableQuestions.shuffle(random);
        generatedExam.addAll(availableQuestions.take(countToTake));
      }

      // 2. Verificar la distribución y el total
      int totalGenerated = generatedExam.length;

      // La suma esperada es 10 (CTGA) + 5 (Normativa) + 0 + 0... = 15 preguntas generadas
      // Nota: Si se simulan todas las 50 preguntas en los JSON, el total debe ser 50.
      expect(totalGenerated, 15);

      // 3. Verificar el conteo por tema
      final topicCounts = <String, int>{};
      for (var q in generatedExam) {
        topicCounts.update(q.topic, (value) => value + 1, ifAbsent: () => 1);
      }

      expect(topicCounts['Conocimientos teóricos generales de aviación'], 10);
      expect(topicCounts['Normativa e instituciones aeronáuticas relevantes para la tripulación de cabina de pasajeros'], 5);
      expect(topicCounts.containsKey('Asistencia a los pasajeros y vigilancia de la cabina'), false); // No hay mock

    });
  });
}
