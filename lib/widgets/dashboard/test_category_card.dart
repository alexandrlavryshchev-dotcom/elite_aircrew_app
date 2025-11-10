// Fichero: lib/widgets/dashboard/test_category_card.dart
import 'package:flutter/material.dart';
import 'package:adv_formacion/config/app_theme.dart';
import 'package:adv_formacion/models/models.dart';
import 'package:adv_formacion/models/test_progress.dart';

class TestCategoryCard extends StatelessWidget {
  final TestCategory category;
  final TestProgress? progress;
  final VoidCallback onTap;
  final bool isSubcategory;

  const TestCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.progress,
    this.isSubcategory = false,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay progreso aún, se considera 0
    final num puntos = progress?.puntos ?? 0;
    final bool completado = progress?.completado ?? false;

    // Convertimos los puntos en un porcentaje (0.0 - 1.0)
    final double percentage = (puntos / 100).clamp(0.0, 1.0);
    final String status = completado
        ? 'Completado'
        : (percentage > 0.0 ? 'En Progreso' : 'Iniciado');
    final Color statusColor =
    completado ? Colors.green : AppColors.highlight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isSubcategory ? 12 : 20),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryDark,
              AppColors.primary.withOpacity(0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  category.id == 'aesa_exam'
                      ? Icons.military_tech_rounded
                      : Icons.flight_takeoff_rounded,
                  color: AppColors.highlight,
                  size: isSubcategory ? 24 : 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: isSubcategory ? 16 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (!isSubcategory) ...[
              const SizedBox(height: 8),
              Text(
                category.description,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
            ],

            // Barra de progreso
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      backgroundColor: AppColors.primary.withOpacity(0.5),
                      valueColor:
                      AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Estado del test
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  completado ? 'Repetir Test' : 'Iniciar/Continuar',
                  style: const TextStyle(
                    color: AppColors.highlight,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
