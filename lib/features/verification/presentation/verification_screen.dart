import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fiyatatlas/app_state.dart';
import 'package:fiyatatlas/features/price/domain/price_status.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<AppState>().entries;
    final pending = entries
        .where((entry) => entry.status != PriceVerificationStatus.verifiedPublic)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Doğrulama Durumu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Bekleyen doğrulamalar',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (pending.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Text('Bekleyen doğrulama yok'),
                subtitle: Text('Yeni fiyat girişlerini takip edin.'),
              ),
            )
          else
            for (final entry in pending)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.pending_actions),
                  title: Text('Barkod: ${entry.barcode}'),
                  subtitle: Text(entry.status.label),
                  trailing: Text('${entry.price.toStringAsFixed(2)} ₺'),
                ),
              ),
        ],
      ),
    );
  }
}
