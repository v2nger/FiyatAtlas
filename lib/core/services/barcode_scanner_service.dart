import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerService {
  static String? extractBarcode(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        return barcode.rawValue;
      }
    }
    return null;
  }
}
