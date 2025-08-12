import 'package:flutter/material.dart';


/// Theme Toggle Button Widget
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    super.key, 
    required this.themeMode, 
    required this.onThemeChanged,
  });
  
  final ThemeMode themeMode;
  final VoidCallback onThemeChanged;

  IconData get _icon {
    switch (themeMode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  String get _tooltip {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System theme';
      case ThemeMode.light:
        return 'Light theme';
      case ThemeMode.dark:
        return 'Dark theme';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_icon),
      onPressed: onThemeChanged,
      tooltip: _tooltip,
    );
  }
}