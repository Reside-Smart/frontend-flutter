import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color _primary = const Color(0xFF25B4F8);
  static final Color _secondary = const Color(0xFFFF6584);
  static final Color _surface = Colors.white;

  static ThemeData lightTheme = ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: _primary,
      secondary: _secondary,
      surface: _surface,
      error: const Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textTheme: GoogleFonts.urbanistTextTheme().copyWith(
      displayLarge: GoogleFonts.urbanist(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      titleLarge: GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
      labelLarge: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300, // Default border color
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _primary, // Focused border color
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.red.shade400, // Error state color
          width: 2.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.red.shade600, // Focused error state
          width: 2.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade200, // Disabled state
          width: 1.0,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade200, // Default border
          width: 1.0,
        ),
      ),
      // Optional: Add hover color
      hoverColor: _primary.withOpacity(0.1),
    ),
    cardTheme: CardTheme(
      color: _surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    iconTheme: IconThemeData(color: _primary, size: 24),
    appBarTheme: AppBarTheme(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _secondary,
      foregroundColor: Colors.white,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.white),
        backgroundColor: WidgetStatePropertyAll(_primary),
        foregroundColor: WidgetStatePropertyAll(_primary),
      ),
    ),
  );

  // Dark Theme (Optional)
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: _primary,
      secondary: _secondary,
      surface: Color(0xFF1E1E1E),
    ),
  );
}
