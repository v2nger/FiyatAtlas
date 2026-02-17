import 'package:fiyatatlas/core/providers/active_market_provider.dart';
import 'package:fiyatatlas/features/auth/presentation/providers/auth_providers.dart';
import 'package:fiyatatlas/features/market/domain/market_branch.dart';
import 'package:fiyatatlas/features/price_log/domain/entities/price_log.dart';
import 'package:fiyatatlas/features/price_log/presentation/providers/submit_price_log_provider.dart';
import 'package:fiyatatlas/features/product/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceEntryScreen extends ConsumerStatefulWidget {
  final Product product;
  final MarketBranch branch;

  const PriceEntryScreen({
    super.key,
    required this.product,
    required this.branch,
  });

  @override
  ConsumerState<PriceEntryScreen> createState() => _PriceEntryScreenState();
}

class _PriceEntryScreenState extends ConsumerState<PriceEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  bool _hasReceipt = false;
  bool _isAvailable = true;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen önce giriş yapın.')));
      return;
    }

    final price = double.parse(_priceController.text.replaceAll(',', '.'));

    // Generate Device Hash
    final deviceHash = await DeviceHashService.generate();

    // Create Log Entity
    final log = PriceLog(
      id: DateTime.now().millisecondsSinceEpoch
          .toString(), // Temporary ID for local
      userId: user.id,
      productId: widget.product.barcode,
      marketId: widget.branch.id,
      marketName: widget.branch.displayName,
      price: price,
      timestamp: DateTime.now(),
      hasReceipt: _hasReceipt,
      isAvailable: _isAvailable,
      deviceHash: deviceHash,
      // Default to pending, system handles update
      syncStatus: PriceLogSyncStatus.pending,
    );

    // Call Controller
    await ref.read(submitPriceLogControllerProvider.notifier).submit(log);

    // Check Result (Success is mostly guaranteed due to offline-first policy)
    if (mounted) {
      final state = ref.read(submitPriceLogControllerProvider);

      state.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fiyat kaydedildi! (Senkronize ediliyor...)'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Return to previous screen
        },
        error: (err, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $err'), backgroundColor: Colors.red),
          );
        },
        loading: () {}, // Handled by UI blocking
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(submitPriceLogControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text('Fiyat Gir', style: GoogleFonts.poppins())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Info Card
              Card(
                child: ListTile(
                  leading: widget.product.imageUrl != null
                      ? Image.network(widget.product.imageUrl!, width: 50)
                      : const Icon(Icons.shopping_bag),
                  title: Text(widget.product.name),
                  subtitle: Text(widget.product.barcode),
                ),
              ),
              const SizedBox(height: 16),

              // Market Info
              Text(
                'Market: ${widget.branch.displayName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),

              // Price Input
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Fiyat (TL)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Fiyat giriniz';
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Geçersiz fiyat';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Toggles
              SwitchListTile(
                title: const Text('Fiş/Fatura Var mı?'),
                value: _hasReceipt,
                onChanged: (val) => setState(() => _hasReceipt = val),
              ),
              SwitchListTile(
                title: const Text('Stokta Var mı?'),
                value: _isAvailable,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('KAYDET'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
