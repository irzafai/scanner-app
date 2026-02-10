import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_event_learn/home/home_controller.dart';
import 'package:scanner_event_learn/qr_code/qr_code_controller.dart';
import 'package:scanner_event_learn/ticket/ticket_service.dart';

class QrCodeView extends StatefulWidget {
  const QrCodeView({super.key});

  @override
  State<QrCodeView> createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  final QrCodeController controller = QrCodeController();
  final MobileScannerController scannerController = MobileScannerController();
  final HomeController homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            onDetect: (barcode) async {
              if (!controller.isScanning) return;

              final qrCode = barcode.barcodes.first.rawValue;
              if (qrCode == null) return;

              await controller.scanQRcode(barcode);

              // ⬇️ PANGGIL API (INI YANG HILANG)
              final ticket = await TicketService().fetchTicket(qrCode);

              if (ticket != null) {
                await homeController.saveScanResult(
                  ticket['data']['name'],
                  true,
                );
              } else {
                await homeController.saveScanResult('Unknown Ticket', false);
              }

              scannerController.stop();
              setState(() {});
            },
          ),

          if (controller.isValid != null) _resultOverlay(),
        ],
      ),
    );
  }

  Widget _resultOverlay() {
    final valid = controller.isValid == true;

    return AlertDialog(
      content: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                valid ? Icons.check_circle : Icons.cancel,
                color: valid ? Colors.green : Colors.red,
                size: 100,
              ),
              const SizedBox(height: 16),
              Text(
                valid ? 'VALID TICKET' : 'INVALID TICKET',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  controller.resetScanner();
                  scannerController.start();
                  setState(() {});
                },
                child: const Text('Scan lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
