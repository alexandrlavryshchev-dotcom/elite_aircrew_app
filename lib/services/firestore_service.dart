import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/test_progress.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crear progreso inicial si no existe
  Future<void> crearProgresoAlumno(String uid) async {
    final Map<String, dynamic> progresoInicial = {
      'leccion1': false,
      'leccion2': false,
      'puntos': 0,
    };
    try {
      await _firestore
          .collection('usuarios')
          .doc(uid)
          .set(progresoInicial, SetOptions(merge: true));
    } catch (e) {
      print('❌ Error al crear progreso inicial: $e');
    }
  }

  /// Actualizar progreso general
  Future<void> actualizarProgreso(String uid,
      {String? leccion, int? puntos}) async {
    final Map<String, dynamic> datos = {};
    if (leccion != null) datos[leccion] = true;
    if (puntos != null) datos['puntos'] = puntos;

    try {
      await _firestore
          .collection('usuarios')
          .doc(uid)
          .set(datos, SetOptions(merge: true));
    } catch (e) {
      print('❌ Error al actualizar progreso: $e');
    }
  }

  /// Stream de progreso general
  Stream<Map<String, dynamic>> progresoStream(String uid) {
    return _firestore
        .collection('usuarios')
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data() ?? {});
  }

  /// Guardar resultado de un test
  Future<void> guardarResultadoTest(String uid, TestProgress? test) async {
    if (test == null) return;
    try {
      await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('tests')
          .doc(test.testId)
          .set(test.toJson());
    } catch (e) {
      print('❌ Error al guardar test: $e');
    }
  }

  /// Stream de tests
  Stream<List<TestProgress>> testsStream(String uid) {
    return _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('tests')
        .snapshots()
        .map((snapshot) {
      final List<TestProgress> tests = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // ⚠️ Protección completa contra null y tipo incorrecto
        if (data != null && data is Map<String, dynamic>) {
          tests.add(TestProgress.fromJson(data));
        }
      }
      return tests;
    });
  }

}
