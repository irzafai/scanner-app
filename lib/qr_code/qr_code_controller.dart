import 'dart:developer' show log;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_event_learn/qr_code/qr_code_services.dart';

class QrCodeController {
  final QrCodeServices service = QrCodeServices();

  bool isScanning = true;
  bool? isValid;

  Future<void> scanQRcode(BarcodeCapture barcodes) async {
    if (!isScanning) return;

    final barcode = barcodes.barcodes.first.rawValue;
    if (barcode == null) return;

    isScanning = false;
    log('Barcode found: $barcode');

    isValid = await redeemQRCode(barcode);
  }

  Future<bool> redeemQRCode(String qrData) async {
    log('Redeeming QR Code: $qrData');
    return await service.scanTicket(qrData);
  }

  void resetScanner() {
    isScanning = true;
    isValid = null;
  }
}
