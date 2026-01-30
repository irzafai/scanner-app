import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:scanner_event_learn/splash/splash_view.dart';
import 'package:scanner_event_learn/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(ThemeController()); // inject sekali, global

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController c = Get.find<ThemeController>();


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EventPass',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      themeMode: c.isDark.value ? ThemeMode.dark : ThemeMode.light,   
      home: const SplashView(),
    );
  }
}
