import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessed = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  Future<void> _handleBarcode(BuildContext context, String barcode) async {

    // Lookup Product via Riverpod and assume it is cached or fetched
    // We navigate to detail regardless, detail screen will fetch it again or show error
    // Pre-fetching would be nicer but for now let's keep it simple as AsyncValue is in the detail screen
    
    // final productAsync = ref.read(productLookupProvider(barcode)); // pre-fetch trigger (optional)
    
    // Show Loading?
    
    // Note: productLookupProvider is a FutureProvider. 
    // We can just navigate to detail regardless, or wait.
    // For now, let's navigate to detail argument directly.
    // The Detail screen will handle the lookup itself using the same provider.
    
    Navigator.pushNamed(context, '/product-detail', arguments: barcode).then((_) {
      // Resume scanning when coming back
      if (mounted) {
         setState(() {
           _isProcessed = false;
         });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barkod Tara'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.auto:
                    return const Icon(Icons.flash_auto, color: Colors.blue);
                  case TorchState.unavailable:
                     return const Icon(Icons.flash_off, color: Colors.grey);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                switch (state.cameraDirection) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                  case CameraFacing.external:
                    return const Icon(Icons.usb);
                  case CameraFacing.unknown:
                    return const Icon(Icons.device_unknown);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    if (_isProcessed) return;
                    
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final code = barcodes.first.rawValue;
                      if (code != null) {
                        setState(() {
                          _isProcessed = true;
                        });
                        _handleBarcode(context, code);
                      }
                    }
                  },
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Kamerayı barkoda hizalayın',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Otomatik olarak taranacaktır.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/price-entry');
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Elle Giriş Yap'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
