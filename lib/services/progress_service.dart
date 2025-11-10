// Fichero: lib/services/progress_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/test_progress.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Guarda el resultado de un test para un usuario
  Future<void> saveTestResult(String userId, TestProgress result) async {
    try {
      await _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('tests')
          .doc(result.testId)
          .set(result.toJson());
      print('✅ Progreso guardado para usuario $userId y test ${result.testId}');
    } catch (e) {
      print('❌ Error al guardar progreso: $e');
    }
  }

  /// Obtiene todos los progresos de tests de un usuario
  Future<Map<String, TestProgress>> getUserProgress(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('tests')
          .get();

      final Map<String, TestProgress> progressMap = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data != null && data is Map<String, dynamic>) {
          progressMap[doc.id] = TestProgress.fromJson(data);
        }
      }
      return progressMap;
    } catch (e) {
      print('❌ Error al obtener progreso: $e');
      return {};
    }
  }

  /// Escucha los cambios del progreso del usuario en tiempo real
  Stream<Map<String, TestProgress>> observeUserProgress(String userId) {
    return _firestore
        .collection('user_progress')
        .doc(userId)
        .collection('tests')
        .snapshots()
        .map((snapshot) {
      final Map<String, TestProgress> progressMap = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data != null && data is Map<String, dynamic>) {
          progressMap[doc.id] = TestProgress.fromJson(data);
        }
      }
      return progressMap;
    });
  }

  /// Crear progreso inicial para un usuario (opcional)
  Future<void> createInitialProgress(String userId) async {
    try {
      final docRef = _firestore.collection('user_progress').doc(userId);
      final docSnap = await docRef.get();
      if (!docSnap.exists) {
        await docRef.set({'created_at': FieldValue.serverTimestamp()});
        print('✅ Progreso inicial creado para $userId');
      }
    } catch (e) {
      print('❌ Error al crear progreso inicial: $e');
    }
  }

  /// Reinicia todo el progreso de un usuario
  Future<void> resetUserProgress(String userId) async {
    try {
      final testsCollection = _firestore
          .collection('user_progress')
          .doc(userId)
          .collection('tests');

      final snapshot = await testsCollection.get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print('✅ Progreso del usuario $userId reiniciado correctamente');
    } catch (e) {
      print('❌ Error al reiniciar progreso: $e');
    }
  }
}
