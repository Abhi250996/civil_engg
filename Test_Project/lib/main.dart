import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Civil Engineering AI",
      debugShowCheckedModeBanner: false,

      /// initial route
      initialRoute: AppRoutes.splash,

      /// routes
      getPages: AppPages.routes,

      /// default transition
      defaultTransition: Transition.cupertino,

      /// theme
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
