import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:scanner_event_learn/home/home_services.dart';
import 'package:scanner_event_learn/qr_code/qr_code_view.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _service = HomeServices();

  final RxList<Map<String, dynamic>> scanHistory = RxList<Map<String, dynamic>>([]);

  @override
  void onInit() {
    super.onInit();
    getScanHistory();
  }

  // ini buat nyimpen hasil scan kalo nda salah
  Future<void> saveScanResult(String qrData, bool isValid) async {
    await firestore.collection('scan_results').add({
      'qr_data': qrData,
      'is_valid': isValid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ini buat histori
  void getScanHistory() async {
    final data = await _service.getTickets();
    log('Raw scan history data: $data');

    scanHistory.value = List<Map<String, dynamic>>.from(data);
    log('Scan history updated: $scanHistory');
  }

  // intinya navigasi buat qr lah
  void goToQRCodeView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrCodeView()),
    );
  }

  Future<void> deleteHistory(String id) async {
    await _service.deleteTicket(id);
    getScanHistory();
  }

  Future<void> addTicket(String name) async {
    await _service.addTicket(name);
    getScanHistory();
  }
}
