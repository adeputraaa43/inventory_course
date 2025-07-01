import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final isDark = false.obs;

  // untuk ThemeMode: light / dark
  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  // untuk data tema kustom (tidak wajib, tapi bisa dipakai juga)
  ThemeData get theme => isDark.value ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(themeMode); // gunakan ThemeMode, bukan ThemeData
  }
}
