import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../product/presentation/providers/product_lookup_provider.dart';
import '../../../product/presentation/widgets/product_create_dialog.dart';
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

  final _priceController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _marketController = TextEditingController();

  File? _receiptImage;
  String? _detectedPrice;
  // bool _isLookingUp = false;

  @override
  void dispose() {
    _priceController.dispose();
    _barcodeController.dispose();
    _marketController.dispose();
    super.dispose();
  }

  /* ==========================================================
     DEVICE HASH (REAL)
  ========================================================== */

  Future<String> _generateDeviceHash() async {
    final deviceInfo = DeviceInfoPlugin();

    String raw = '';

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      raw =
          '${android.id}-${android.model}-${android.manufacturer}-${android.version.sdkInt}';
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      raw =
          '${ios.identifierForVendor}-${ios.model}-${ios.systemVersion}';
    } else {
      raw = DateTime.now().millisecondsSinceEpoch.toString();
    }

    final bytes = utf8.encode(raw);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /* ==========================================================
     BARCODE SCAN
  ========================================================== */

  Future<void> _scanBarcode() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 300,
            width: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                onDetect: (barcodeCapture) {
                  final barcode =
                      barcodeCapture.barcodes.first.rawValue;
                  if (barcode != null) {
                    _barcodeController.text = barcode;
                    Navigator.pop(context);
                    // Trigger rebuild to refresh lookup
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /* ==========================================================
     RECEIPT PICK + OCR
  ========================================================== */

  Future<void> _pickReceipt() async {
    final picker = ImagePicker();
    try {
      final picked =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 85);

      if (picked != null) {
        setState(() {
          _receiptImage = File(picked.path);
        });
        await _runOcr(_receiptImage!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Camera error: $e", style: const TextStyle(color: AppColors.textPrimary)), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _runOcr(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText =
          await textRecognizer.processImage(inputImage);

      final extracted = _extractPrice(recognizedText.text);

      if (extracted != null) {
        setState(() {
          _priceController.text = extracted;
          _detectedPrice = extracted;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Price detected: $extracted", style: const TextStyle(color: AppColors.primary)),
              backgroundColor: AppColors.secondary,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No clear price detected, please enter manually.", style: TextStyle(color: AppColors.textPrimary)),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OCR Failed: $e", style: const TextStyle(color: AppColors.textPrimary)), backgroundColor: AppColors.error),
        );
      }
    } finally {
      textRecognizer.close();
    }
  }

  String? _extractPrice(String text) {
    // Regex for patterns like 12.50, 12,50 etc.
    final regex = RegExp(r'\d+[.,]\d{2}');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) return null;

    final prices = matches
        .map((m) => m.group(0)!.replaceAll(',', '.'))
        .map(double.tryParse)
        .where((p) => p != null)
        .map((p) => p!)
        .toList();

    if (prices.isEmpty) return null;

    prices.sort();
    return prices.last.toStringAsFixed(2);
  }

  /* ==========================================================
     SUBMIT
  ========================================================== */

  Future<void> _submit() async {
    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first", style: TextStyle(color: AppColors.textPrimary)), backgroundColor: AppColors.error),
      );
      return;
    }

    if (_priceController.text.isEmpty ||
        _barcodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barcode and Price are required", style: TextStyle(color: AppColors.textPrimary)), backgroundColor: AppColors.error),
      );
      return;
    }
    
    final barcode = _barcodeController.text.trim();

    // Check Product Existence
    final productAsync = ref.read(productLookupProvider(barcode));
    
    if (productAsync.value == null) {
       final newProduct = await showDialog(
         context: context,
         builder: (_) => ProductCreateDialog(barcode: barcode, userId: user.id),
       );

       if (newProduct == null) {
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Product creation cancelled. Cannot submit.", style: TextStyle(color: AppColors.textPrimary)), backgroundColor: AppColors.warning),
           );
         }
         return;
       }
    }

    final deviceHash = await _generateDeviceHash();

    final log = PriceLog(
      id: const Uuid().v4(),
      userId: user.id, 
      productId: barcode,
      marketId: "default_market", 
      marketName: _marketController.text.isEmpty ? "Default Market" : _marketController.text,
      price: double.parse(
          _priceController.text.replaceAll(',', '.')),
      currency: "TRY",
      timestamp: DateTime.now(),
      hasReceipt: _receiptImage != null,
      receiptImageUrl: _receiptImage?.path, 
      isAvailable: true,
      deviceHash: deviceHash,
      syncStatus: PriceLogSyncStatus.pending,
    );

    await ref
        .read(submitPriceLogControllerProvider.notifier)
        .submit(log);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Price submitted successfully!", style: TextStyle(color: AppColors.primary)), backgroundColor: AppColors.success),
      );
      _barcodeController.clear();
      _priceController.clear();
      setState(() {
        _receiptImage = null;
        _detectedPrice = null;
      });
    }
  }

  /* ==========================================================
     UI
  ========================================================== */

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(submitPriceLogControllerProvider);
    final isSubmitting = state is AsyncLoading;
    final barcode = _barcodeController.text;
    final productAsync = ref.watch(productLookupProvider(barcode));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Price"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Section
              Text("Product Details", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              
              TextField(
                controller: _barcodeController,
                onChanged: (val) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: "Barcode",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner, color: AppColors.secondary),
                    onPressed: _scanBarcode,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (barcode.isNotEmpty)
                productAsync.when(
                  data: (product) {
                    if (product == null) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber, color: AppColors.warning),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Product not found. You will be asked to create it on submit.",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.warning),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.inventory_2, color: AppColors.secondary),
                        ),
                        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(product.brand),
                        trailing: const Icon(Icons.check_circle, color: AppColors.success),
                      ),
                    );
                  },
                  loading: () => const LinearProgressIndicator(color: AppColors.secondary),
                  error: (_, _) => const SizedBox(),
                ),

              const SizedBox(height: 24),

              // Price Section
              Text("Price & Market", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 12),

              TextField(
                controller: _marketController,
                decoration: const InputDecoration(
                  labelText: "Market Name (Optional)",
                  prefixIcon: Icon(Icons.store, color: AppColors.textSecondary),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Price",
                  prefixIcon: Icon(Icons.attach_money, color: AppColors.textSecondary),
                  suffixText: "TRY",
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),

              const SizedBox(height: 24),

              // Receipt Section
              Text("Receipt Proof", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 12),

              _buildReceiptCard(),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                        )
                      : Text(
                          "SUBMIT PRICE",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard() {
    return GestureDetector(
      onTap: _pickReceipt,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _receiptImage != null ? AppColors.secondary : AppColors.border,
            width: _receiptImage != null ? 2 : 1,
            style: _receiptImage != null ? BorderStyle.solid : BorderStyle.none, // Dashed unsupported natively easily, sticking to clean border
          ),
          image: _receiptImage != null
              ? DecorationImage(
                  image: FileImage(_receiptImage!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.3),
                    BlendMode.darken,
                  ),
                )
              : null,
          boxShadow: [
            if (_receiptImage == null)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
          ],
        ),
        alignment: Alignment.center,
        child: _receiptImage != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.secondary, size: 48),
                  const SizedBox(height: 8),
                  const Text(
                    "Receipt Attached",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  if (_detectedPrice != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Detected: $_detectedPrice",
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: AppColors.textSecondary, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tap to Scan Receipt",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "(Optional but recommended)",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
