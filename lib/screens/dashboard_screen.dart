// Fichero: lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:adv_formacion/config/app_theme.dart';
import 'package:adv_formacion/models/models.dart';
import 'package:adv_formacion/models/test_progress.dart';
import 'package:adv_formacion/services/auth_service.dart';
import 'package:adv_formacion/services/progress_service.dart';
import 'package:adv_formacion/widgets/dashboard/test_category_card.dart';
import 'package:url_launcher/url_launcher.dart';


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
      title: 'Prueba de Certificacion',
      description:
      'Simulacro de examen con 50 preguntas aleatorias y distribución exacta.',
      icon: 'military_tech_rounded',
      questionAssetPath: 'assets/questions/examenaesa.json',
    ),

    // ▸ NUEVA CATEGORÍA — EXÁMENES OFICIALES ELITE AIRCREW
    TestCategory(
      id: 'elite_aircrew_main',
      title: 'Exámenes Oficiales ELITE AIRCREW',
      description: 'Colección de exámenes finales y generales.',
      icon: 'military_tech_rounded',
      subcategories: [
        // ▸ SUBCATEGORÍA 1: EXAMEN FINAL
        TestCategory(
          id: 'elite_examen_final',
          title: 'Examen Final',
          description: '16 exámenes finales.',
          subcategories: [
            TestCategory(
              id: 'elite_final_1',
              title: 'Examen Final 1',
              questionAssetPath: 'assets/questions/elite/final/examen1.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_2',
              title: 'Examen Final 2',
              questionAssetPath: 'assets/questions/elite/final/examen2.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_3',
              title: 'Examen Final 3',
              questionAssetPath: 'assets/questions/elite/final/examen3.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_4',
              title: 'Examen Final 4',
              questionAssetPath: 'assets/questions/elite/final/examen4.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_5',
              title: 'Examen Final 5',
              questionAssetPath: 'assets/questions/elite/final/examen5.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_6',
              title: 'Examen Final 6',
              questionAssetPath: 'assets/questions/elite/final/examen6.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_7',
              title: 'Examen Final 7',
              questionAssetPath: 'assets/questions/elite/final/examen7.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_8',
              title: 'Examen Final 8',
              questionAssetPath: 'assets/questions/elite/final/examen8.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_9',
              title: 'Examen Final 9',
              questionAssetPath: 'assets/questions/elite/final/examen9.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_10',
              title: 'Examen Final 10',
              questionAssetPath: 'assets/questions/elite/final/examen10.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_11',
              title: 'Examen Final 11',
              questionAssetPath: 'assets/questions/elite/final/examen11.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_12',
              title: 'Examen Final 12',
              questionAssetPath: 'assets/questions/elite/final/examen12.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_13',
              title: 'Examen Final 13',
              questionAssetPath: 'assets/questions/elite/final/examen13.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_14',
              title: 'Examen Final 14',
              questionAssetPath: 'assets/questions/elite/final/examen14.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_15',
              title: 'Examen Final 15',
              questionAssetPath: 'assets/questions/elite/final/examen15.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_final_16',
              title: 'Examen Final 16',
              questionAssetPath: 'assets/questions/elite/final/examen16.json',
              description: '',
              icon: '',
            ),
          ],
          icon: '',
        ),

        // ▸ SUBCATEGORÍA 2: EXAMEN GENERAL
        TestCategory(
          id: 'elite_examen_general',
          title: 'Examen General',
          description: '16 exámenes generales.',
          subcategories: [
            TestCategory(
              id: 'elite_general_1',
              title: 'Examen General 1',
              questionAssetPath: 'assets/questions/elite/general/examen1.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_2',
              title: 'Examen General 2',
              questionAssetPath: 'assets/questions/elite/general/examen2.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_3',
              title: 'Examen General 3',
              questionAssetPath: 'assets/questions/elite/general/examen3.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_4',
              title: 'Examen General 4',
              questionAssetPath: 'assets/questions/elite/general/examen4.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_5',
              title: 'Examen General 5',
              questionAssetPath: 'assets/questions/elite/general/examen5.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_6',
              title: 'Examen General 6',
              questionAssetPath: 'assets/questions/elite/general/examen6.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_7',
              title: 'Examen General 7',
              questionAssetPath: 'assets/questions/elite/general/examen7.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_8',
              title: 'Examen General 8',
              questionAssetPath: 'assets/questions/elite/general/examen8.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_9',
              title: 'Examen General 9',
              questionAssetPath: 'assets/questions/elite/general/examen9.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_10',
              title: 'Examen General 10',
              questionAssetPath: 'assets/questions/elite/general/examen10.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_11',
              title: 'Examen General 11',
              questionAssetPath: 'assets/questions/elite/general/examen11.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_12',
              title: 'Examen General 12',
              questionAssetPath: 'assets/questions/elite/general/examen12.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_13',
              title: 'Examen General 13',
              questionAssetPath: 'assets/questions/elite/general/examen13.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_14',
              title: 'Examen General 14',
              questionAssetPath: 'assets/questions/elite/general/examen14.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_15',
              title: 'Examen General 15',
              questionAssetPath: 'assets/questions/elite/general/examen15.json',
              description: '',
              icon: '',
            ),
            TestCategory(
              id: 'elite_general_16',
              title: 'Examen General 16',
              questionAssetPath: 'assets/questions/elite/general/examen16.json',
              description: '',
              icon: '',
            ),
          ],
          icon: '',
        ),
      ],
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
          questionAssetPath: 'assets/questions/tcp/conocimientos_teoricos.json',
          description: '',
        ),
        TestCategory(
          id: 'normativa',
          title: 'Normativa e instituciones',
          icon: 'gavel_rounded',
          questionAssetPath: 'assets/questions/tcp/normativa.json',
          description: '',
        ),
        TestCategory(
          id: 'asistencia',
          title: 'Asistencia a pasajeros y vigilancia',
          icon: 'accessibility_new_rounded',
          questionAssetPath: 'assets/questions/tcp/asistencia.json',
          description: '',
        ),
        TestCategory(
          id: 'medicina',
          title: 'Medicina aeronáutica y primeros auxilios',
          icon: 'medical_services_rounded',
          questionAssetPath: 'assets/questions/tcp/medicina.json',
          description: '',
        ),
        TestCategory(
          id: 'mercancias',
          title: 'Mercancías peligrosas',
          icon: 'dangerous_rounded',
          questionAssetPath: 'assets/questions/tcp/mercancias.json',
          description: '',
        ),
        TestCategory(
          id: 'seguridad_nav',
          title: 'Aspectos generales de seguridad en aviación',
          icon: 'security_rounded',
          questionAssetPath: 'assets/questions/tcp/seguridad_nav.json',
          description: '',
        ),
        TestCategory(
          id: 'incendios',
          title: 'Lucha contra incendios y humo',
          icon: 'local_fire_department_rounded',
          questionAssetPath: 'assets/questions/tcp/incendios.json',
          description: '',
        ),
        TestCategory(
          id: 'supervivencia',
          title: 'Supervivencia',
          icon: 'forest_rounded',
          questionAssetPath: 'assets/questions/tcp/supervivencia.json',
          description: '',
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
          questionAssetPath: 'assets/questions/ingles/ingles_gral.json',
          description: '',
        ),
        TestCategory(
          id: 'ingles_cambridge',
          title: 'Inglés Cambridge',
          icon: 'school_rounded',
          questionAssetPath: 'assets/questions/ingles/ingles_cambridge.json',
          description: '',
        ),
        TestCategory(
          id: 'ingles_aero',
          title: 'Inglés Aeronáutico',
          icon: 'flight_rounded',
          questionAssetPath: 'assets/questions/ingles/ingles_aero.json',
          description: '',
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
    // ✅ Manual con dos PDFs
    TestCategory(
      id: 'Curso TOA',
      title: 'Curso TOA',
      description:
      'Lleva tus conocimientos de operaciones aereas al siguiente nivel',
      icon: 'menu_book_rounded',
      subcategories: [
        TestCategory(
          id: 'manual_pdf1',
          title: 'Módulo Técnico de Operaciones',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/pdf1.pdf',
          description: '',
        ),
        TestCategory(
          id: 'manual_pdf2',
          title: 'Módulo Técnico de Operaciones Aeroportuarias',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/pdf2.pdf',
          description: '',
        ),
      ],
    ),
// ✅ Nuevo manual con 3 PDFs
    TestCategory(
      id: 'MANUALES TCP',
      title: 'MANUALES TCP',
      description: 'Impulsa tu futuro como tripulante de cabina',
      icon: 'menu_book_rounded',
      subcategories: [
        TestCategory(
          id: 'ONE-FUE-SEC-SUP',
          title: 'ONE-FUE-SEC-SUP',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/manual_extra_1.pdf',
          description: '',
        ),
        TestCategory(
          id: 'MED',
          title: 'MED',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/manual_extra_2.pdf',
          description: '',
        ),
        TestCategory(
          id: 'CTG_MERGED',
          title: 'CTG_MERGED',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/manual_extra_3.pdf',
          description: '',
        ),
      ],
    ),
    TestCategory(
      id: 'material_clase',
      title: 'MATERIAL CLASE',
      description: 'El contenido perfecto para fortalecer tu formacion',
      icon: 'menu_book_rounded',
      subcategories: [
        // 1️⃣ MODULO
        TestCategory(
          id: 'modulo',
          title: 'MODULO',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/modulo.pdf',
          description: '',
        ),
        // 2️⃣ ONE con sub-subcategorías
        TestCategory(
          id: 'one',
          title: 'ONE',
          icon: 'folder_rounded', // icono de carpeta porque tiene subcategorías
          subcategories: [
            TestCategory(
              id: 'operacion_normal',
              title: 'OPERACION NORMAL',
              icon: 'picture_as_pdf_rounded',
              pdfPath: 'assets/manual/operacion_normal.pdf',
              description: '',
            ),
            TestCategory(
              id: 'operacion_emergencia',
              title: 'OPERACION DE EMERGENCIA',
              icon: 'picture_as_pdf_rounded',
              pdfPath: 'assets/manual/operacion_emergencia.pdf',
              description: '',
            ),
            TestCategory(
              id: 'material_emergencia',
              title: 'MATERIAL DE EMERGENCIA',
              icon: 'picture_as_pdf_rounded',
              pdfPath: 'assets/manual/material_emergencia.pdf',
              description: '',
            ),
            TestCategory(
              id: 'doc_operador',
              title: 'DOC.DEL OPERADOR Y MANUAL DE OPERACIONES',
              icon: 'picture_as_pdf_rounded',
              pdfPath: 'assets/manual/doc_operador.pdf',
              description: '',
            ),
            TestCategory(
              id: 'reunion_prevuel',
              title: 'REUNION PREVUELO',
              icon: 'picture_as_pdf_rounded',
              pdfPath: 'assets/manual/reunion_prevuel.pdf',
              description: '',
            ),
            TestCategory(
              id: 'categoria_pasajeros',
              title: 'CATEGORIA DE PASAJEROS',
              icon: 'picture_as_pdf_rounded',
              pdfPath: 'assets/manual/categoria_pasajeros.pdf',
              description: '',
            ),
            TestCategory(
              id: 'equipaje_pet_comunicacion',
              title: 'EQUIPAJE-PAX-AGRESIVOS PET-COMUNICACION',
              icon: 'picture_as_pdf_rounded',
              pdfPath: 'assets/manual/equipaje_pet_comunicacion.pdf',
              description: '',
            ),
          ],
          description: '',
        ),
        // 3️⃣ FUEGOS
        TestCategory(
          id: 'fuegos',
          title: 'FUEGOS',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/fuegos.pdf',
          description: '',
        ),
        // 4️⃣ SUPERVIVENCIA
        TestCategory(
          id: 'supervivencia',
          title: 'SUPERVIVENCIA',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/supervivencia.pdf',
          description: '',
        ),
        // 5️⃣ SEC
        TestCategory(
          id: 'sec',
          title: 'SEC',
          icon: 'picture_as_pdf_rounded',
          pdfPath: 'assets/manual/sec.pdf',
          description: '',
        ),
      ],
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
          ? user!.displayName! // si tiene displayName
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
  double _getCategoryProgress(
      TestCategory category, Map<String, TestProgress> progress) {
    if (category.subcategories != null && category.subcategories!.isNotEmpty) {
      double total = 0;
      int count = 0;
      for (var sub in category.subcategories!) {
        if (sub.pdfPath != null) continue; // Ignorar subcategorías que son PDFs
        final p = progress[sub.id];
        if (p != null) {
          total += p.puntos;
          count++;
        }
      }
      if (count == 0) return 0.0;
      return (total / count) / 100;
    } else {
      if (category.pdfPath != null)
        return 0.0; // Ignorar categoría PDF individual
      final p = progress[category.id];
      return p != null ? (p.puntos / 100) : 0.0;
    }
  }

  Future<void> _openPdfUrl(String pdfPath) async {
    String path = Uri.base.path;
    // Normalize the path
    if (path.endsWith('/')) path = path.substring(0, path.length - 1);

    // Extract first folder (if any)
    final segments = path.split('/');
    String subfolder = '';

    // If deployed to GitHub Pages or any "/folder" path
    if (segments.length > 1 && segments[1].isNotEmpty) {
      subfolder = segments[1]; // example: "myapp"
    }
    final fullUrl = subfolder.isNotEmpty
        ? Uri.parse('${Uri.base.origin}/$subfolder/assets/$pdfPath')
        : Uri.parse('${Uri.base.origin}/assets/$pdfPath');
    print(fullUrl);
    if (!await launchUrl(fullUrl, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el PDF.')),
      );
    }
  }

  void _navigateToTest(TestCategory category) {
    // 1️⃣ Si tiene subcategorías → abrir bottom sheet
    if (category.subcategories != null && category.subcategories!.isNotEmpty) {
      _showSubcategories(category.subcategories!);
      return;
    }

    // 2️⃣ Caso especial de examen AESA
    if (category.id == 'aesa_exam') {
      Navigator.pushNamed(context, '/aesa_exam');
      return;
    }

    // 3️⃣ Si es un PDF → abrir en navegador/app externa
    if (category.pdfPath != null) {
      _openPdfUrl(category.pdfPath!);
      return;
    }

    // 4️⃣ Resto: test normal (JSON)
    if (category.questionAssetPath != null) {
      Navigator.pushNamed(
        context,
        '/test_screen',
        arguments: {'category': category, 'userId': _currentUser['id']},
      );
      return;
    }

    // 5️⃣ Si no tiene nada → mostrar mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ruta de preguntas no especificada.')),
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
                            progress: sub.pdfPath == null
                                ? (subProgress > 0
                                ? TestProgress(
                              testId: sub.id,
                              puntos: subProgress * 100,
                              completado: subProgress >= 1.0,
                            )
                                : null)
                                : null,
                            onTap: () {
                              Navigator.pop(context);

                              // Si tiene sub-subcategorías → abrir otro bottom sheet
                              if (sub.subcategories != null &&
                                  sub.subcategories!.isNotEmpty) {
                                _showSubcategories(sub.subcategories!);
                                return;
                              }

                              // Si es PDF → abrir en app externa
                              if (sub.pdfPath != null) {
                                _openPdfUrl(sub.pdfPath!);
                                return;
                              }

                              // Caso normal: test JSON
                              if (sub.questionAssetPath != null) {
                                Navigator.pushNamed(
                                  context,
                                  '/test_screen',
                                  arguments: {
                                    'category': sub,
                                    'userId': _currentUser['id'],
                                  },
                                );
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Ruta de preguntas no especificada.'),
                                ),
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
              child: Image.asset('assets/images/aircrew-logo.png', height: 35),
            ),
            const SizedBox(width: 8),
            const Text('Elite Aircrew'),
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
                  'Bienvenid@ a bordo, ${_currentUser['name']} ✈️🎓',
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

                    // ✅ Chequear si todas las subcategorías son PDFs
                    final allSubcategoriesArePdf =
                        category.subcategories != null &&
                            category.subcategories!.isNotEmpty &&
                            category.subcategories!.every((sub) =>
                            sub.pdfPath != null && sub.pdfPath!.isNotEmpty);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TestCategoryCard(
                        category: category,
                        isSubcategory: false,
                        // ❌ No mostrar progreso si todas las subcategorías son PDFs
                        progress: allSubcategoriesArePdf
                            ? null
                            : (categoryProgress > 0
                            ? TestProgress(
                          testId: category.id,
                          puntos: categoryProgress * 100,
                          completado: categoryProgress >= 1.0,
                        )
                            : null),
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