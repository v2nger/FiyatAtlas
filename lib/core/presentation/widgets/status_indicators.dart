import 'package:flutter/material.dart';

import '../../../../features/price_log/domain/entities/price_log.dart';
import '../../theme/app_theme.dart';

class ConfidenceBadge extends StatelessWidget {
  final double confidence; // 0.0 to 1.0

  const ConfidenceBadge({super.key, required this.confidence});

  @override
  Widget build(BuildContext context) {
    if (confidence >= 0.9) {
      // Verified - Green Gradient Chip
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.secondary, Color(0xFF22C55E)], // Teal to Green
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 12, color: AppColors.primary),
            SizedBox(width: 4),
            Text(
              'Verified',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else if (confidence >= 0.7) {
      // Pending - Amber Chip
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
        ),
        child: const Text(
          'Pending',
          style: TextStyle(
            color: AppColors.warning,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      // Private/Low - Grey Subtle
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: const Text(
          'Unverified',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}

class SyncIndicator extends StatelessWidget {
  final PriceLogSyncStatus status;

  const SyncIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case PriceLogSyncStatus.synced:
        color = AppColors.success;
        break;
      case PriceLogSyncStatus.pending:
        color = AppColors.warning;
        break;
      case PriceLogSyncStatus.failed:
        color = AppColors.error;
        break;
    }

    return Tooltip(
      message: status.name,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
