import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner_event_learn/qr_code/qr_code_view.dart';

class HomeController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ini buat nyimpen hasil scan kalo nda salah
  Future<void> saveScanResult(String qrData, bool isValid) async {
    await firestore.collection('scan_results').add({
      'qr_data': qrData,
      'is_valid': isValid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ini buat histori
  Stream<QuerySnapshot> getScanHistory() {
    return firestore
        .collection('scan_results')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // intinya navigasi buat qr lah
  void goToQRCodeView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrCodeView()),
    );
  }

  Future<void> deleteHistory(String documentId) async {
    await firestore.collection('scan_results').doc(documentId).delete();
  }
}
