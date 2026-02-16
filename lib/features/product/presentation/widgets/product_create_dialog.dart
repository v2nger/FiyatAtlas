import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product.dart';

class ProductCreateDialog extends StatefulWidget {
  final String barcode;
  final String userId;

  const ProductCreateDialog({
    super.key,
    required this.barcode,
    required this.userId,
  });

  @override
  State<ProductCreateDialog> createState() =>
      _ProductCreateDialogState();
}

class _ProductCreateDialogState
    extends State<ProductCreateDialog> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("New Product", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code, color: AppColors.secondary, size: 20),
                const SizedBox(width: 8),
                Text(widget.barcode, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Product Name",
              prefixIcon: Icon(Icons.label, color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _brandController,
            decoration: const InputDecoration(
              labelText: "Brand",
              prefixIcon: Icon(Icons.branding_watermark, color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.trim().isEmpty) return;
            
            final product = Product(
              barcode: widget.barcode,
              name: _nameController.text.trim(),
              brand: _brandController.text.trim(),
              imageUrl: null,
              createdAt: DateTime.now(),
              createdBy: widget.userId,
            );
            Navigator.pop(context, product);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Create Product"),
        ),
      ],
    );
  }
}
