import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_course/presentation/controller/theme_controller.dart';
import 'config/app_color.dart';
import 'config/session.dart';
import 'presentation/controller/c_user.dart';
import 'presentation/page/dashboard_page.dart';
import 'presentation/page/login_page.dart';
import 'package:inventory_course/presentation/controller/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Session.getUser();

  // Inisialisasi ThemeController SEBELUM runApp
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cUser = Get.put(CUser());
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeController.themeMode,
          theme: ThemeData.light().copyWith(
            primaryColor: AppColor.primary,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.light().copyWith(
              primary: AppColor.primary,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: AppColor.primary,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColor.primary,
            ),
            colorScheme: const ColorScheme.dark().copyWith(
              primary: AppColor.primary,
            ),
          ),
          home: Obx(() {
            if (cUser.data.idUser == null) return const LoginPage();
            return const DashboardPage();
          }),
        ));
  }
}
