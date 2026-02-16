import 'package:flutter/material.dart';

class VerifiedPriceCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const VerifiedPriceCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final productId = data['product_id'] ?? 'N/A';
    final marketId = data['market_id'] ?? 'N/A';
    final verifiedPrice = (data['verified_price'] as num?)?.toDouble() ?? 0.0;
    final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.0;
    final sampleSize = (data['sample_size'] as num?)?.toInt() ?? 0;
    final forcedByGod = data['forced_by_god'] ?? false;

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product ID: $productId',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Market ID: $marketId',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₺${verifiedPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('$sampleSize samples'),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: confidence / 100,
                            strokeWidth: 6,
                            color: _getConfidenceColor(confidence),
                            backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        Text(
                          '${confidence.toInt()}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (forcedByGod)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  'GOD MODE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double score) {
    if (score >= 90) return Colors.greenAccent;
    if (score >= 70) return Colors.limeAccent;
    if (score >= 50) return Colors.amberAccent;
    return Colors.redAccent;
  }
}
