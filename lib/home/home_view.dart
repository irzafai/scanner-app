import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_event_learn/options/options_view.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode
            ? Colors.grey.shade900
            : Colors.lightBlueAccent,
        elevation: 0,
        title: const Text(
          'EventPass',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OptionsView()),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.goToQRCodeView(context),
        backgroundColor: Get.isDarkMode
            ? Colors.grey.shade800
            : Colors.lightBlueAccent,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),

      body: Container(
        color: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ADD TICKET BUTTON
            ElevatedButton.icon(
              onPressed: () {
                showAddTicketDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Ticket'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Get.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.lightBlueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // HISTORY LIST
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                ),
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.scanHistory.length,
                    itemBuilder: (context, index) {
                      final ticket = controller.scanHistory[index];
                      return GestureDetector(
                        onLongPress: () => buildDeleteDialog(context, ticket),
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(ticket['name']),
                            subtitle: Text(ticket['status']),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ADD TICKET DIALOG
  Future<void> showAddTicketDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Ticket'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Ticket Name',
              hintText: 'Enter ticket name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  controller.addTicket(name);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.lightBlueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  // DELETE DIALOG
  Future<void> buildDeleteDialog(
    BuildContext context,
    Map<String, dynamic> ticket,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete History'),
          content: const Text('Are you sure you want to delete this ticket?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await controller.deleteHistory(ticket['id']);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
