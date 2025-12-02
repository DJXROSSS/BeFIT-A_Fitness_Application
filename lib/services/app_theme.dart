import 'package:flutter/material.dart';

/// Minimal black and white theme - no gradients
class AppTheme {
  // Light Theme Colors - Black and off-white only
  static const Color lightBg = Color(0xFFe4e2de);
  static const Color lightCard = Color(0xFFe4e2de);
  static const Color lightText = Color(0xFF000000);
  static const Color lightSubtext = Color(0xFF000000);
  static const Color lightAccent = Color(0xFF000000);
  static const Color lightDivider = Color(0xFF000000);
  static const Color lightGlassBlur = Color(0xFFe4e2de);

  // Dark Theme Colors - Black and off-white only
  static const Color darkBg = Color(0xFF000000);
  static const Color darkCard = Color(0xFF000000);
  static const Color darkText = Color(0xFFe4e2de);
  static const Color darkSubtext = Color(0xFFe4e2de);
  static const Color darkAccent = Color(0xFFe4e2de);
  static const Color darkDivider = Color(0xFFe4e2de);
  static const Color darkGlassBlur = Color(0xFF000000);

  // Primary Action Colors - Black and white only
  static const Color primaryBlue = Color(0xFF000000);
  static const Color primaryGreen = Color(0xFF000000);
  static const Color primaryRed = Color(0xFF000000);
  static const Color primaryOrange = Color(0xFF000000);
  static const Color primaryYellow = Color(0xFF000000);
  static const Color primaryPurple = Color(0xFF000000);

  // Dynamic theme colors
  static bool isDarkMode = false;

  // Accessors that return appropriate color based on theme
  static Color get backgroundColor => isDarkMode ? darkBg : lightBg;
  static Color get cardColor => isDarkMode ? darkCard : lightCard;
  static Color get textColor => isDarkMode ? darkText : lightText;
  static Color get subtextColor => isDarkMode ? darkSubtext : lightSubtext;
  static Color get accentColor => isDarkMode ? darkAccent : lightAccent;
  static Color get dividerColor => isDarkMode ? darkDivider : lightDivider;
  static Color get glassBlurColor =>
      isDarkMode ? darkGlassBlur : lightGlassBlur;
  static Color get titleTextColor => textColor;
  static Color get appBarBg => accentColor;
  static Color get drawerHeaderBg => isDarkMode ? darkCard : lightCard;
  static Color get drawerIconColor => accentColor;
  static Color get logoutColor => primaryRed;

  // Neumorphic shadow colors
  static const Color lightShadow = Color.fromARGB(15, 0, 0, 0);
  static const Color darkShadow = Color.fromARGB(25, 0, 0, 0);

  /// Get the current theme based on dark mode setting
  static ThemeData get theme {
    final isDark = isDarkMode;
    final surface = isDark ? darkBg : lightBg;
    final onSurface = isDark ? darkText : lightText;
    final primary = primaryBlue;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: '-apple-system, BlinkMacSystemFont, SF Pro Display, Segoe UI',
      scaffoldBackgroundColor: surface,
      canvasColor: surface,
      cardColor: isDark ? darkCard : lightCard,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: primaryGreen,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: onSurface,
        error: primaryRed,
        onError: Colors.white,
      ),
      // App Bar - Minimal with no shadow
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: onSurface),
        surfaceTintColor: Colors.transparent,
      ),
      // Bottom Navigation - Minimal style
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? darkCard : lightCard,
        selectedItemColor: primary,
        unselectedItemColor: isDark ? darkSubtext : lightSubtext,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        enableFeedback: true,
      ),
      // Elevated Button - Apple-like
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // Text Button - Minimal
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      // Input Decoration - Clean minimal style
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkCard : Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? darkDivider : lightDivider,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? darkDivider : lightDivider,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        hintStyle: TextStyle(
          color: isDark ? darkSubtext : lightSubtext,
          fontSize: 14,
        ),
        labelStyle: TextStyle(color: primary, fontSize: 14),
      ),
      // Text Theme - Modern and clean
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.15,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurface,
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurface,
          letterSpacing: 0.15,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isDark ? darkSubtext : lightSubtext,
          letterSpacing: 0.15,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? darkSubtext : lightSubtext,
          letterSpacing: 0.5,
        ),
      ),
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: isDark ? darkDivider : lightDivider,
        thickness: 0.5,
        space: 1,
      ),
    );
  }

  /// Update theme mode
  static void setDarkMode(bool dark) {
    isDarkMode = dark;
  }

  /// Legacy method for compatibility
  static void setCustomColor(Color userColor) {
    // For backward compatibility - this is now handled by isDarkMode
  }

  /// Create a neumorphic shadow effect
  static BoxShadow get neumorphicShadow {
    return BoxShadow(
      color: isDarkMode ? darkShadow : lightShadow,
      blurRadius: 8,
      offset: const Offset(0, 2),
    );
  }

  /// Create an elevated neumorphic shadow effect
  static BoxShadow get neumorphicElevatedShadow {
    return BoxShadow(
      color: isDarkMode ? darkShadow : lightShadow,
      blurRadius: 12,
      offset: const Offset(0, 4),
    );
  }
}
