import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TrustBadge extends StatelessWidget {
  final double score;
  final bool isShadowBanned;

  const TrustBadge({
    super.key,
    required this.score,
    required this.isShadowBanned,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;

    // Determine color based on score (Using Tier Colors from AppColors)
    if (isShadowBanned) {
      borderColor = AppColors.shadow;
    } else if (score >= 90) {
      borderColor = AppColors.atlasStart; // Using Atlas primary
    } else if (score >= 70) {
      borderColor = AppColors.gold;
    } else if (score >= 50) {
      borderColor = AppColors.silver;
    } else {
      borderColor = AppColors.bronze;
    }

    // Atlas Style Special Handling
    if (!isShadowBanned && score >= 90) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent), // Hidden by gradient
          gradient: const LinearGradient(
            colors: [AppColors.atlasStart, AppColors.atlasEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          // Inner container to create border effect if needed,
          // but design says "Background: Surface, Border: Tier Color".
          // For Atlas it says "Animated gradient border".
          // Simplified: Gradient Border with Surface Inner
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 14, color: AppColors.atlasStart),
              const SizedBox(width: 6),
              Text(
                '${score.toStringAsFixed(0)} Trust',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Standard Badge
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isShadowBanned ? Icons.visibility_off : Icons.verified_user,
            size: 14,
            color: borderColor,
          ),
          const SizedBox(width: 4),
          Text(
            isShadowBanned ? 'Shadow' : '${score.toStringAsFixed(0)} Trust',
            style: TextStyle(
              color: borderColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TierBadge extends StatelessWidget {
  final String tier; // Bronze, Silver, Gold, Atlas

  const TierBadge({super.key, required this.tier});

  @override
  Widget build(BuildContext context) {
    Color color;
    List<Color> gradientColors;

    switch (tier.toLowerCase()) {
      case 'atlas':
        color = AppColors.atlasStart;
        gradientColors = [AppColors.atlasStart, AppColors.atlasEnd];
        break;
      case 'gold':
        color = AppColors.gold;
        gradientColors = [
          AppColors.gold,
          AppColors.gold.withValues(alpha: 0.8),
        ];
        break;
      case 'silver':
        color = AppColors.silver;
        gradientColors = [AppColors.silver, Colors.grey.shade400];
        break;
      case 'bronze':
      default:
        color = AppColors.bronze;
        gradientColors = [AppColors.bronze, const Color(0xFFA0522D)];
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        tier.toUpperCase(),
        style: const TextStyle(
          color:
              Colors.white, // Text inside Tier badge usually white for contrast
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
