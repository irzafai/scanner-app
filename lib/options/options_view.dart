import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_controller.dart';

class OptionsView extends StatelessWidget {
  OptionsView({super.key});

  final ThemeController c = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => GestureDetector(
            onTap: () => c.changeTheme(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: c.isDark.value
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      c.isDark.value
                          ? Icons.nightlight_round
                          : Icons.wb_sunny_rounded,
                      key: ValueKey(c.isDark.value),
                      size: 32,
                      color: c.isDark.value
                          ? Colors.amber
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      c.isDark.value
                          ? 'Dark Mode'
                          : 'Light Mode',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
