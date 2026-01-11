import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_app/app/constants/app_colors.dart';
import 'package:social_app/app/data/user_model.dart';
import 'package:social_app/app/routes/app_pages.dart';
import 'package:social_app/app/services/api_services.dart';
import 'package:social_app/app/services/auth_services.dart';
import 'package:social_app/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Hive.registerAdapter(UserModelAdapter());

  await Hive.openBox('auth');

  Get.put(AuthServices());
  Get.put(ApiServices());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.iconColor),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        fontFamily: 'Inter',
      ),
      getPages: AppPages.routes,
      initialRoute: AppPages.initialRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
