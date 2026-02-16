import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/app_theme.dart';

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
    Navigator.pushNamed(context, '/product-detail', arguments: barcode).then((_) {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Barkod Tara', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.white);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: AppColors.gold);
                  case TorchState.auto:
                    return const Icon(Icons.flash_auto, color: AppColors.secondary);
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
                    return const Icon(Icons.camera_front, color: Colors.white);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear, color: Colors.white);
                  case CameraFacing.external:
                    return const Icon(Icons.usb, color: Colors.white);
                  case CameraFacing.unknown:
                    return const Icon(Icons.device_unknown, color: Colors.grey);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
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
          
          // Custom Overlay
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.6), 
              BlendMode.srcOut
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    backgroundBlendMode: BlendMode.dstIn,
                  ),
                ),
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Scanner Borders
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.secondary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    spreadRadius: 4,
                    blurRadius: 20,
                  )
                ]
              ),
              child: Stack(
                children: [
                   // Corner Indicators
                   const Positioned(top: 20, left: 20, child: _Corner(color: AppColors.secondary)),
                   const Positioned(top: 20, right: 20, child: RotatedBox(quarterTurns: 1, child: _Corner(color: AppColors.secondary))),
                   const Positioned(bottom: 20, left: 20, child: RotatedBox(quarterTurns: 3, child: _Corner(color: AppColors.secondary))),
                   const Positioned(bottom: 20, right: 20, child: RotatedBox(quarterTurns: 2, child: _Corner(color: AppColors.secondary))),
                   // Scanning Line Animation (Static for now, could be animated)
                   Center(
                     child: Container(
                       height: 2,
                       width: 240,
                       decoration: BoxDecoration(
                         color: AppColors.error.withValues(alpha: 0.8),
                         boxShadow: [
                           const BoxShadow(
                             color: AppColors.error,
                             blurRadius: 10,
                             spreadRadius: 1,
                           )
                         ]
                       ),
                     ),
                   )
                ],
              ),
            ),
          ),

          // Bottom Instruction Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, -5))
                ]
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Kamerayı barkoda hizalayın',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Otomatik olarak taranacaktır.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/price-entry'); 
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.secondary),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.keyboard_alt_outlined),
                      label: const Text('Elle Giriş Yap'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final Color color;
  const _Corner({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color, width: 3),
          left: BorderSide(color: color, width: 3),
        ),
      ),
    );
  }
}
