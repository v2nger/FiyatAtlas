import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/active_market_provider.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../domain/entities/price_log.dart';
import '../providers/submit_price_log_provider.dart';

class SubmitPriceLogScreen extends ConsumerStatefulWidget {
  const SubmitPriceLogScreen({super.key});

  @override
  ConsumerState<SubmitPriceLogScreen> createState() =>
      _SubmitPriceLogScreenState();
}

class _SubmitPriceLogScreenState
    extends ConsumerState<SubmitPriceLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();

  bool _hasReceipt = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final activeMarket = ref.watch(activeMarketProvider);

    final user = userAsync.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiyat Gir"),
        backgroundColor: Colors.teal.shade900,
        actions: [
          if (activeMarket != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                backgroundColor: Colors.teal.shade700,
                label: Text(
                  activeMarket['market_name'] ?? 'Market',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : activeMarket == null
              ? _buildNoMarketState(context)
              : _buildForm(context, user.id, activeMarket),
    );
  }

  Widget _buildNoMarketState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront,
                size: 80, color: Colors.teal.shade300),
            const SizedBox(height: 20),
            const Text(
              "Aktif Market Yok",
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Fiyat girebilmek için önce bir markete giriş yapmalısın.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/marketSelect");
              },
              child: const Text("Market Seç"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, String userId, dynamic activeMarket) {
    final submitState = ref.watch(submitPriceLogControllerProvider);
    final isLoading = submitState.isLoading;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildCard(
              child: TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: "Ürün Barkodu",
                  prefixIcon: Icon(Icons.qr_code),
                  border: InputBorder.none,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Barkod gerekli" : null,
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              child: TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Fiyat (₺)",
                  prefixIcon: Icon(Icons.attach_money),
                  border: InputBorder.none,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Fiyat gerekli" : null,
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              child: SwitchListTile(
                value: _hasReceipt,
                onChanged: (v) {
                  setState(() {
                    _hasReceipt = v;
                  });
                },
                title: const Text("Fiş mevcut"),
                secondary: const Icon(Icons.receipt_long),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => _submit(context, userId, activeMarket),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Fiyatı Gönder",
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 16),
            if (submitState.hasError)
              Text(
                submitState.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Future<void> _submit(
      BuildContext context, String userId, dynamic activeMarket) async {
    if (!_formKey.currentState!.validate()) return;
    if (activeMarket == null) return;

    final deviceHash = await DeviceHashService.generate();

    final log = PriceLog(
      id: const Uuid().v4(),
      userId: userId,
      productId: _barcodeController.text.trim(),
      marketId: activeMarket['market_id'],
      marketName: activeMarket['market_name'],
      price: double.parse(_priceController.text.trim()),
      timestamp: DateTime.now(),
      hasReceipt: _hasReceipt,
      receiptImageUrl: null,
      deviceHash: deviceHash,
    );

    await ref.read(submitPriceLogControllerProvider.notifier).submit(log);

    if (!context.mounted) return;

    _barcodeController.clear();

    _priceController.clear();
    setState(() => _hasReceipt = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fiyat başarıyla gönderildi"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
