import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState
    extends State<BarcodeScannerScreen> {
  bool _found = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Barkod Tara")),
      body: MobileScanner(
        onDetect: (capture) {
          if (_found) return;

          final barcode = capture.barcodes.first.rawValue;
          if (barcode != null) {
            _found = true;
            Navigator.pop(context, barcode);
          }
        },
      ),
    );
  }
}
