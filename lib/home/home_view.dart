import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scanner_event_learn/options/options_view.dart';
import 'home_controller.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = HomeController();
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode
            ? Colors.grey.shade900
            : Colors.lightBlueAccent,
        elevation: 0,
        title: Text(
          'EventPass',
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Get.isDarkMode ? Colors.white : Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OptionsView()),
              );
            },
          ),
        ],
      ),

      // TOMBOL SCAN QR
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.goToQRCodeView(context),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        backgroundColor: Get.isDarkMode ? Colors.grey.shade800 : Colors.lightBlueAccent,
        shape: const CircleBorder(),
      ),

      body: Container(
        decoration: BoxDecoration(color: Get.isDarkMode ? Colors.black : Colors.grey.shade100),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration:  BoxDecoration(
            color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
          ),
        
          child: StreamBuilder<QuerySnapshot>(
            stream: controller.getScanHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5, // coba 0.3 – 0.5
                        child: Image.asset(
                          'assets/img/nakano1.png',
                          width: 160,
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada history',
                        style: TextStyle(
                          fontSize: 16,
                          color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  log('History item: $data');

                  return Card(
                    elevation: 4, // ✨ shadow
                    margin: const EdgeInsets.only(bottom: 8),
                    color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete History'),
                              content: const Text(
                                'Are you sure you want to delete this history item?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await controller.deleteHistory(doc.id);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      leading: const Icon(Icons.confirmation_number),
                      title: Text(data['qr_data']),
                      subtitle: Text(
                        data['is_valid'] ? 'Unredeemed' : 'Redeemed',
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: data['is_valid']
                              ? Colors.orange.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data['is_valid'] ? 'UNREDEEMED' : 'REDEEMED',
                          style: TextStyle(
                            fontSize: 12,
                            color: data['is_valid']
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
