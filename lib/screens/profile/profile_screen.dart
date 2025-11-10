// Fichero: lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adv_formacion/config/app_theme.dart';
import 'package:adv_formacion/services/progress_service.dart';
import 'package:adv_formacion/models/test_progress.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProgressService _progressService = ProgressService();
  User? _firebaseUser; // Usuario actual de Firebase
  late ConfettiController _confettiController;
  double _lastProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _firebaseUser = FirebaseAuth.instance.currentUser;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  double _calculateOverallProgress(Map<String, TestProgress> progress) {
    if (progress.isEmpty) return 0.0;
    final completed = progress.values.where((p) => p.completado).toList();
    if (completed.isEmpty) return 0.0;
    final totalPoints =
    completed.map((p) => p.puntos.toDouble()).fold(0.0, (a, b) => a + b);
    final average = totalPoints / completed.length / 100;
    return average.clamp(0.0, 1.0);
  }

  Map<String, dynamic> _getBadge(double progress) {
    if (progress >= 0.9) {
      return {
        'emoji': '👑',
        'title': 'TCP de Oro',
        'desc': 'Excelencia total. Serías el orgullo de cualquier aerolínea.',
        'color': Colors.amber[700],
      };
    } else if (progress >= 0.6) {
      return {
        'emoji': '🛫',
        'title': 'Tripulante Destacado',
        'desc': 'Tu seguridad y servicio brillan, estás casi listo para volar.',
        'color': Colors.blueAccent,
      };
    } else if (progress >= 0.3) {
      return {
        'emoji': '☕',
        'title': 'Asistente de Cabina Junior',
        'desc': 'Ya conoces los procedimientos básicos, buen trabajo.',
        'color': Colors.green,
      };
    } else {
      return {
        'emoji': '🧳',
        'title': 'Tripulante en Formación',
        'desc': 'Estás preparando tu primer vuelo, sigue estudiando.',
        'color': Colors.grey,
      };
    }
  }

  List<Map<String, dynamic>> _getAllBadges() => [
    {
      'emoji': '🧳',
      'title': 'Tripulante en Formación',
      'desc': 'Tu viaje acaba de comenzar.',
    },
    {
      'emoji': '☕',
      'title': 'Asistente de Cabina Junior',
      'desc': 'Dominas los fundamentos del servicio a bordo.',
    },
    {
      'emoji': '🛫',
      'title': 'Tripulante Destacado',
      'desc': 'Te desenvuelves como un auténtico profesional.',
    },
    {
      'emoji': '👑',
      'title': 'TCP de Oro',
      'desc': 'Excelencia y vocación. Eres la referencia de la tripulación.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userId = _firebaseUser?.uid ?? 'default_user';
    final userEmail = _firebaseUser?.email ?? '';
    final userName = (_firebaseUser?.displayName?.isNotEmpty == true)
        ? _firebaseUser!.displayName!
        : userEmail.split('@')[0]; // toma solo la parte antes de @

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Mi Perfil"),
      ),
      body: Stack(
        children: [
          StreamBuilder<Map<String, TestProgress>>(
            stream: _progressService.observeUserProgress(userId),
            builder: (context, snapshot) {
              final progress = snapshot.data ?? {};
              final overallProgress = _calculateOverallProgress(progress);

              // Confeti si sube de rango
              if (overallProgress > _lastProgress &&
                  (overallProgress * 100).floor() ~/ 10 >
                      (_lastProgress * 100).floor() ~/ 10) {
                _confettiController.play();
              }
              _lastProgress = overallProgress;

              final completedCount =
                  progress.values.where((p) => p.completado).length;
              final totalTests = progress.length;
              final badge = _getBadge(overallProgress);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                      AssetImage('assets/images/student_avatar.png'),
                      radius: 50,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "ID: $userId",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // 🏅 Insignia actual
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutBack,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (badge['color'] as Color?)?.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: badge['color'] ?? Colors.grey),
                      ),
                      child: Column(
                        children: [
                          Text(badge['emoji'],
                              style: const TextStyle(fontSize: 50)),
                          const SizedBox(height: 8),
                          Text(
                            badge['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: badge['color'],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            badge['desc'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.primaryDark.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 📊 Progreso general
                    Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Progreso General",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: overallProgress,
                              backgroundColor:
                              AppColors.primary.withOpacity(0.2),
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

                    // 📈 Estadísticas generales
                    Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Tus Estadísticas",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tests completados:"),
                                Text("$completedCount / $totalTests"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Puntuación media:"),
                                Text("${(overallProgress * 100).toStringAsFixed(1)}%"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🏆 Historial de insignias
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Insignias disponibles",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _getAllBadges().map((b) {
                        final unlocked =
                            badge['title'] == b['title'] ||
                                overallProgress >= 0.3 &&
                                    b['title'] != 'Tripulante en Formación';
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: unlocked ? 1 : 0.3,
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: unlocked ? Colors.white : Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: unlocked
                                    ? AppColors.primary.withOpacity(0.5)
                                    : Colors.grey,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(b['emoji'],
                                    style: const TextStyle(fontSize: 32)),
                                const SizedBox(height: 6),
                                Text(
                                  b['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: unlocked
                                        ? AppColors.primaryDark
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  b['desc'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: unlocked
                                        ? AppColors.primaryDark.withOpacity(0.8)
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    // 🔴 Botón Reiniciar Progreso al final de la pantalla
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                        ),
                        icon: const Icon(Icons.restart_alt),
                        label: const Text(
                          "Reiniciar Progreso",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          if (_firebaseUser != null) {
                            await _progressService
                                .resetUserProgress(_firebaseUser!.uid);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Progreso reiniciado correctamente"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),

          // 🎉 Confeti al subir de nivel
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.blue,
                Colors.amber,
                Colors.pink,
                Colors.green,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }
}
