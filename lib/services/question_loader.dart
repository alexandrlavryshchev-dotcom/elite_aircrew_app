// Fichero: lib/services/question_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:adv_formacion/models/models.dart';

/// Servicio para cargar preguntas desde archivos JSON en assets.
class QuestionLoaderService {
  // Caché de preguntas por ruta
  final Map<String, List<Question>> _questionCache = {};

  /// Carga y parsea preguntas desde un archivo JSON
  Future<List<Question>> loadQuestionsFromAsset(String assetPath) async {
    // Si ya se cargaron antes, devuelve la caché
    if (_questionCache.containsKey(assetPath)) {
      return _questionCache[assetPath]!;
    }

    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonList = json.decode(jsonString);

      final List<Question> questions = [];

      for (var jsonItem in jsonList) {
        try {
          // Validar que los campos existan y tengan el tipo correcto
          if (jsonItem['topic'] is String &&
              jsonItem['text'] is String &&
              jsonItem['options'] is List &&
              jsonItem['correctIndex'] is int) {
            questions.add(Question.fromJson(jsonItem));
          } else {
            print('⚠️ Pregunta inválida en $assetPath: $jsonItem');
          }
        } catch (e) {
          print('⚠️ Error parseando pregunta en $assetPath: $jsonItem\nError: $e');
        }
      }

      // Guardar en caché
      _questionCache[assetPath] = questions;

      if (questions.isEmpty) {
        print('❌ No se encontraron preguntas válidas en $assetPath');
      }

      return questions;
    } catch (e) {
      print('❌ Error cargando preguntas desde $assetPath: $e');
      return [];
    }
  }
}
