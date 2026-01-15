import 'dart:ui';

import 'package:get/get.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  var notificationsEnabled = true.obs;
  var showSettings = false.obs;

  VoidCallback? onThemeChanged;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    AppTheme.setDarkMode(value);
    onThemeChanged?.call();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  void toggleSettings() {
    showSettings.value = !showSettings.value;
  }
}
