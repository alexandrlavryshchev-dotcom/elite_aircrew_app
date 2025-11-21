// Fichero: lib/models/models.dart

/// Clase que representa el modelo de un usuario en la aplicación.
class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });
}

/// Clase que representa el modelo de una pregunta para los tests.
class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String topic; // Tema del test (ejemplo: "Conocimientos teóricos")

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.topic,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    try {
      return Question(
        id: (json['id'] ?? '').toString(), // Valor por defecto si falta
        text: (json['text'] ?? '').toString(),
        options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        correctIndex: (json['correctIndex'] ?? 0) as int,
        topic: (json['topic'] ?? '').toString(),
      );
    } catch (e) {
      print('❌ Error parseando pregunta: $json\nError: $e');
      return Question(
        id: 'unknown',
        text: 'Error cargando pregunta',
        options: [],
        correctIndex: 0,
        topic: 'unknown',
      );
    }
  }
}

/// Clase que define la estructura de una categoría de test en el Dashboard.
class TestCategory {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<TestCategory>? subcategories;
  final String? questionAssetPath; // Ruta al archivo JSON si aplica
  final String? pdfPath; // 👉 NUEVO: ruta al PDF si esta categoría/subcategoría es un manual

  TestCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.subcategories,
    this.questionAssetPath,
    this.pdfPath,
  });
}

