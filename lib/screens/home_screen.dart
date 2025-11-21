import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../services/firestore_service.dart';
import '../models/test_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late final String _uidAlumno;
  bool _progresoCreado = false;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No hay usuario autenticado");
    _uidAlumno = user.uid;

    _crearProgresoSeguro();
  }

  Future<void> _crearProgresoSeguro() async {
    try {
      await _firestoreService.crearProgresoAlumno(_uidAlumno);
    } catch (e) {
      debugPrint('❌ Error al crear progreso inicial: $e');
    } finally {
      setState(() => _progresoCreado = true);
    }
  }

  Widget _buildCard(String titulo, String valor) {
    return Card(
      color: AppColors.moradoLuz.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '$titulo: $valor',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildBoton(String texto, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.moradoAcademia,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          texto,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_progresoCreado) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a Elite Aircrew'),
        backgroundColor: AppColors.moradoAcademia,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.moradoAcademia, AppColors.moradoLuz],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Tu Progreso General',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Progreso general
              StreamBuilder<Map<String, dynamic>>(
                stream: _firestoreService.progresoStream(_uidAlumno),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final progreso = snapshot.data!;

                  return Column(
                    children: [
                      _buildCard(
                        'Lección 1',
                        progreso['leccion1'] == true ? '✅ Completada' : '❌ Pendiente',
                      ),
                      _buildCard(
                        'Lección 2',
                        progreso['leccion2'] == true ? '✅ Completada' : '❌ Pendiente',
                      ),
                      _buildCard(
                        'Puntos',
                        '${progreso['puntos'] ?? 0}',
                      ),
                      const SizedBox(height: 10),
                      _buildBoton('Completar Lección 1', () {
                        _firestoreService.actualizarProgreso(
                          _uidAlumno,
                          leccion: 'leccion1',
                          puntos: (progreso['puntos'] ?? 0) + 10,
                        );
                      }),
                      _buildBoton('Completar Lección 2', () {
                        _firestoreService.actualizarProgreso(
                          _uidAlumno,
                          leccion: 'leccion2',
                          puntos: (progreso['puntos'] ?? 0) + 20,
                        );
                      }),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),
              const Text(
                'Tus Tests',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              StreamBuilder<List<TestProgress>>(
                stream: _firestoreService.testsStream(_uidAlumno),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final tests = snapshot.data!;
                  if (tests.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Aún no has completado ningún test.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }

                  return Column(
                    children: tests.map((test) {
                      return _buildCard(
                        'Test ${test.testId}',
                        test.completado
                            ? '✅ Completado (${test.puntos} pts)'
                            : '❌ Pendiente',
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
