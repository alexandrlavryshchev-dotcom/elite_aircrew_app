// lib/models/student_model.dart

class Student {
  final String name;
  final String avatarUrl;
  final Map<String, double> progress; // clave: tema, valor: progreso 0-1

  Student({
    required this.name,
    required this.avatarUrl,
    required this.progress,
  });
}
