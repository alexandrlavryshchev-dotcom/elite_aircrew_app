// Fichero: lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:adv_formacion/config/app_theme.dart';
import 'package:adv_formacion/models/models.dart';
import 'package:adv_formacion/models/test_progress.dart';
import 'package:adv_formacion/services/auth_service.dart';
import 'package:adv_formacion/services/progress_service.dart';
import 'package:adv_formacion/widgets/dashboard/test_category_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  final ProgressService _progressService = ProgressService();
  var _currentUser;

  final List<TestCategory> _mainCategories = [
    // ✅ Examen Oficial AESA
    TestCategory(
      id: 'aesa_exam',
      title: 'Examen Oficial AESA',
      description:
      'Simulacro de examen con 50 preguntas aleatorias y distribución exacta.',
      icon: 'military_tech_rounded',
      questionAssetPath: 'assets/questions/examenaesa.json',
    ),

    // ✅ Entrevistas
    TestCategory(
      id: 'entrevistas',
      title: 'Entrevistas',
      description:
      'Prepárate para las preguntas clave de la selección de tripulantes.',
      icon: 'question_answer_rounded',
      questionAssetPath: 'assets/questions/entrevistas.json',
    ),

    // ✅ Test TCP con subcategorías
    TestCategory(
      id: 'tcp_general',
      title: 'Test TCP',
      description: 'Temario completo de Tripulante de Cabina de Pasajeros.',
      icon: 'flight_class_rounded',
      subcategories: [
        TestCategory(
          id: 'ctga',
          title: 'Conocimientos teóricos generales de aviación',
          icon: 'airplanemode_active_rounded',
          questionAssetPath: 'assets/questions/tcp/conocimientos_teoricos.json', description: '',
        ),
        TestCategory(
          id: 'normativa',
          title: 'Normativa e instituciones',
          icon: 'gavel_rounded',
          questionAssetPath: 'assets/questions/tcp/normativa.json', description: '',
        ),
        TestCategory(
          id: 'asistencia',
          title: 'Asistencia a pasajeros y vigilancia',
          icon: 'accessibility_new_rounded',
          questionAssetPath: 'assets/questions/tcp/asistencia.json', description: '',
        ),
        TestCategory(
          id: 'medicina',
          title: 'Medicina aeronáutica y primeros auxilios',
          icon: 'medical_services_rounded',
          questionAssetPath: 'assets/questions/tcp/medicina.json', description: '',
        ),
        TestCategory(
          id: 'mercancias',
          title: 'Mercancías peligrosas',
          icon: 'dangerous_rounded',
          questionAssetPath: 'assets/questions/tcp/mercancias.json', description: '',
        ),
        TestCategory(
          id: 'seguridad_nav',
          title: 'Aspectos generales de seguridad en aviación',
          icon: 'security_rounded',
          questionAssetPath: 'assets/questions/tcp/seguridad_nav.json', description: '',
        ),
        TestCategory(
          id: 'incendios',
          title: 'Lucha contra incendios y humo',
          icon: 'local_fire_department_rounded',
          questionAssetPath: 'assets/questions/tcp/incendios.json', description: '',
        ),
        TestCategory(
          id: 'supervivencia',
          title: 'Supervivencia',
          icon: 'forest_rounded',
          questionAssetPath: 'assets/questions/tcp/supervivencia.json', description: '',
        ),
      ],
    ),

    // ✅ Inglés con subcategorías
    TestCategory(
      id: 'ingles',
      title: 'Inglés Aeronáutico y General',
      description: 'Mejora tus habilidades lingüísticas para la aviación.',
      icon: 'language_rounded',
      subcategories: [
        TestCategory(
          id: 'ingles_gral',
          title: 'Inglés General',
          icon: 'book_rounded',
          questionAssetPath: 'assets/questions/ingles/ingles_gral.json', description: '',
        ),
        TestCategory(
          id: 'ingles_cambridge',
          title: 'Inglés Cambridge',
          icon: 'school_rounded',
          questionAssetPath: 'assets/questions/ingles/ingles_cambridge.json', description: '',
        ),
        TestCategory(
          id: 'ingles_aero',
          title: 'Inglés Aeronáutico',
          icon: 'flight_rounded',
          questionAssetPath: 'assets/questions/ingles/ingles_aero.json', description: '',
        ),
      ],
    ),

    // ✅ Roleplay en Cabina
    TestCategory(
      id: 'roleplay',
      title: 'Roleplay en Cabina',
      description: 'Simulaciones de situaciones reales en cabina.',
      icon: 'diversity_3_rounded',
      questionAssetPath: 'assets/questions/roleplay/roleplay.json',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Obtener usuario autenticado
    final user = _authService.currentUser;
    _currentUser = {
      'id': user?.uid ?? 'default_user',
      'name': (user?.displayName?.isNotEmpty == true)
          ? user!.displayName!           // si tiene displayName
          : user!.email!.split('@')[0], // sino usa la parte antes del @
    };
  }

  /// 🔹 Calcula el progreso general del usuario
  double _calculateOverallProgress(Map<String, TestProgress> progress) {
    if (progress.isEmpty) return 0.0;
    double total = 0;
    int count = 0;
    for (var p in progress.values) {
      total += p.puntos;
      count++;
    }
    if (count == 0) return 0.0;
    return (total / count) / 100;
  }

  /// 🔹 Calcula el progreso de una categoría o subcategoría
  double _getCategoryProgress(TestCategory category, Map<String, TestProgress> progress) {
    if (category.subcategories != null && category.subcategories!.isNotEmpty) {
      double total = 0;
      int count = 0;
      for (var sub in category.subcategories!) {
        final p = progress[sub.id];
        if (p != null) {
          total += p.puntos;
          count++;
        }
      }
      if (count == 0) return 0.0;
      return (total / count) / 100;
    } else {
      final p = progress[category.id];
      return p != null ? (p.puntos / 100) : 0.0;
    }
  }

  void _navigateToTest(TestCategory category) {
    if (category.subcategories != null && category.subcategories!.isNotEmpty) {
      _showSubcategories(category.subcategories!);
      return;
    }

    if (category.id == 'aesa_exam') {
      Navigator.pushNamed(context, '/aesa_exam');
      return;
    }

    Navigator.pushNamed(
      context,
      '/test_screen',
      arguments: {'category': category, 'userId': _currentUser['id']},
    );
  }

  void _showSubcategories(List<TestCategory> subcategories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StreamBuilder<Map<String, TestProgress>>(
          stream: _progressService.observeUserProgress(_currentUser['id']),
          builder: (context, snapshot) {
            final progress = snapshot.data ?? {};
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subcategorías',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Divider(color: AppColors.primary),
                  Expanded(
                    child: ListView.builder(
                      itemCount: subcategories.length,
                      itemBuilder: (context, index) {
                        final sub = subcategories[index];
                        final subProgress = _getCategoryProgress(sub, progress);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TestCategoryCard(
                            category: sub,
                            isSubcategory: true,
                            progress: subProgress > 0
                                ? TestProgress(
                              testId: sub.id,
                              puntos: subProgress * 100,
                              completado: subProgress >= 1.0,
                            )
                                : null,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                '/test_screen',
                                arguments: {
                                  'category': sub,
                                  'userId': _currentUser['id'],
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = _currentUser['id'] ?? 'default_user';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'adv_logo',
              child: Image.asset('assets/images/adv-logo.png', height: 35),
            ),
            const SizedBox(width: 8),
            const Text('ADV Formación'),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/student_avatar.png'),
            ),
            tooltip: 'Perfil del alumno',
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<Map<String, TestProgress>>(
        stream: _progressService.observeUserProgress(userId),
        builder: (context, snapshot) {
          final progress = snapshot.data ?? {};
          final overallProgress = _calculateOverallProgress(progress);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, ${_currentUser['name']} 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Progreso General',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: overallProgress,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.highlight),
                          minHeight: 12,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${(overallProgress * 100).toInt()}% Completado",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mainCategories.length,
                  itemBuilder: (context, index) {
                    final category = _mainCategories[index];
                    final categoryProgress =
                    _getCategoryProgress(category, progress);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TestCategoryCard(
                        category: category,
                        progress: categoryProgress > 0
                            ? TestProgress(
                          testId: category.id,
                          puntos: categoryProgress * 100,
                          completado: categoryProgress >= 1.0,
                        )
                            : null,
                        onTap: () => _navigateToTest(category),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
