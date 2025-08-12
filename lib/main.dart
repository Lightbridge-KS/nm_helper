import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:window_manager/window_manager.dart';

import 'theme/theme_blue.dart' show MaterialTheme;
import 'theme/theme_toggle_button.dart';
import 'screen/spine_height_calculator_screen.dart';
import 'screen/change_calculator_screen.dart';

/// App Screens 
const List<Widget> appScreenWidgets = <Widget>[
    SpineHeightCalculatorScreen(), 
    ChangeCalculatorScreen(),
];

/// App Screen Titles
const List<String> appScreenTitles = <String>[
    'Spine Height Loss Calculator',
    'Change Calculator',
];


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set minimum window size for desktop and web platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    // Desktop platforms
    await windowManager.ensureInitialized();
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(450, 500),
      minimumSize: Size(400, 500),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  
  runApp(const NmHelperApp());
}

class NmHelperApp extends StatefulWidget {
  const NmHelperApp({super.key});

  @override
  State<NmHelperApp> createState() => _NmHelperAppState();
}

class _NmHelperAppState extends State<NmHelperApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme() {
    setState(() {
      switch (_themeMode) {
        case ThemeMode.system:
          _themeMode = ThemeMode.light;
          break;
        case ThemeMode.light:
          _themeMode = ThemeMode.dark;
          break;
        case ThemeMode.dark:
          _themeMode = ThemeMode.system;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(ThemeData.light().textTheme);
    
    return MaterialApp(
      themeMode: _themeMode,
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      home: BottomNavigationBar(
        onThemeChanged: _changeTheme,
        themeMode: _themeMode,
      ),
    );
  }
}




/// Navbar
class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({super.key, required this.onThemeChanged, required this.themeMode});
  
  final VoidCallback onThemeChanged;
  final ThemeMode themeMode;

  @override
  State<BottomNavigationBar> createState() =>
      _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appScreenTitles[currentPageIndex]),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          actions: [
            ThemeToggleButton(
              themeMode: widget.themeMode,
              onThemeChanged: widget.onThemeChanged,
            ),
          ],
        ),
        body: Center(child: appScreenWidgets.elementAt(currentPageIndex)),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: null,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.height), 
              label: 'Height Loss'
            ),
            NavigationDestination(
              icon: Icon(Icons.percent_rounded),
              label: 'Change',
            ),
          ],  
        ),
    );
  }
}
