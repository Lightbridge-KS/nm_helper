# NM Helper

A professional Flutter calculator app for commonly-used utilities in nuclear medicine, featuring custom Material Design 3 theming and cross-platform desktop support.

## App Architecture

**Navigation**: Bottom navigation bar with two main calculator screens
**Theme**: Custom Material Design 3 theme with custom color palette
**Platform Support**: Mobile (iOS/Android), Desktop (Windows/macOS/Linux), and Web
**Window Management**: Minimum window size 400×500px for desktop platforms

## Core Features

### 🔢 Spine Height Loss Calculator
- **Input**: Normal height and collapsed height (supports comma-separated values for mean calculation)
- **Calculation**: Uses SpineHeightCalculator with comprehensive diagnostic classifications
- **Output**: Height loss percentage with clinical diagnosis (less than mild, mild, moderate, severe)
- **Validation**: Prevents invalid inputs, negative values, and logical errors (collapsed > normal)
- **Sample**: `5, 5.5` → `4` = `23.8% (severe)` with detailed report

### 📊 Change Calculator  
- **Input**: Current value and previous value (decimal numbers supported)
- **Calculation**: Percentage change and absolute delta using ChangeCalculator
- **Output**: `Change: X.X %` and `Delta: X.XXX` formatted report
- **Validation**: Division by zero protection and input validation
- **Sample**: `4` → `2` = `100.0%` change with `2.0` delta

## UI Components & Features

### 🎨 Theme System
- **Custom Colors**: Material Design 3 custom palette
- **Theme Toggle**: System/Light/Dark mode switching via AppBar button
- **Adaptive Design**: All UI elements use theme-aware colors for proper contrast
- **File**: `lib/theme/theme_blue.dart` contains comprehensive ColorSchemes

### 🖱️ User Interface
- **Dynamic AppBar**: Context-aware titles ("Spine Height Loss Calculator" | "Change Calculator")
- **Button Layout**: `[Generate] [Clear] [Info] [Copy]` consistent across screens
- **Results Display**: Editable TextField with monospace font for easy copying
- **Error Handling**: Theme-adaptive error cards with user-friendly messages
- **Usage Help**: AlertDialog with context-specific instructions

### ⚙️ Interactive Elements
- **Generate**: Primary action button with branded theme colors
- **Clear**: Resets all input fields and clears errors
- **Copy**: Clipboard integration with success feedback via SnackBar
- **Info**: Context help dialog explaining usage for each calculator
- **Theme Toggle**: Cycles through System → Light → Dark themes
- **Enter Key Support**: Press Enter in any input field to trigger calculations

## Technical Implementation

### 📁 Project Structure
```
lib/
├── calc/                           # Business logic
│   ├── spine_height_calculator.dart   # Height loss calculations & diagnostics
│   ├── change_calculator.dart         # Percentage change calculations  
│   └── statistics.dart                # Utility functions (mean, rounding)
├── screen/                         # UI screens
│   ├── spine_height_calculator_screen.dart
│   └── change_calculator_screen.dart
├── theme/                          # Theming system
│   ├── theme_blue.dart            # Custom Material Design 3 theme
│   └── theme_toggle_button.dart   # Theme switching component
└── main.dart                      # App entry point & navigation
```

### 🔧 Key Dependencies
- `window_manager: ^0.5.1` - Desktop window management and minimum size constraints
- `flutter/services.dart` - Clipboard functionality for copy operations
- `flutter_launcher_icons: ^0.14.4` - Generate app icons for all platforms
- Custom Material Design 3 theme generated from online Material Theme Builder

### 💡 Validation & Error Handling
- **Input Parsing**: Handles single values and comma-separated lists
- **Business Logic**: Prevents division by zero, negative inputs, logical inconsistencies
- **UI Feedback**: Theme-adaptive error cards with contextual messages
- **State Management**: Proper clearing of errors and results between calculations

## Development Notes

### 🎯 Code Patterns
- **StatefulWidget**: Both calculator screens use state management for inputs/results
- **TextEditingController**: Proper disposal in widget lifecycle
- **Theme Integration**: Consistent use of `Theme.of(context).colorScheme.*`
- **Error Boundaries**: Try-catch with FormatException for user-friendly messages
- **onSubmitted Callbacks**: TextField Enter key support for triggering calculations

### 🚀 Future Enhancements
- Additional calculator types can be added to `appScreenWidgets` and `appScreenTitles`
- Theme system supports high contrast variants for accessibility
- Business logic is modular and can be extended with new calculation methods
- Desktop-first design scales well to larger screen sizes

### 🔍 Testing Examples
**Spine Height**: `5, 5.5` (normal) + `4` (collapsed) → `Height loss: 23.8% (severe)`
**Change Calc**: `4` (current) + `2` (previous) → `Change: 100.0% | Delta: 2.0`

## CI/CD & Build System

### 🚀 GitHub Actions Workflows
- **macOS Build**: `.github/workflows/macos-build.yml` - Automated macOS app building and packaging
- **Windows Build**: `.github/workflows/windows-build.yml` - Windows installer creation with Inno Setup
- **Cross-Platform**: Supports both manual triggers and automatic release creation
- **Versioning**: Auto-updates app version from Git tags (strips 'v' prefix, adds build number)

### 📦 Release Process
1. **Triggers**: Push to main/dev/feat/hotfix branches, pull requests, GitHub releases
2. **Version Management**: Extracts version from Git tags and updates `pubspec.yaml`
3. **Platform Builds**: 
   - **macOS**: Creates `.app` bundle, zips as `NM-Helper-macos.zip`
   - **Windows**: Builds executable, creates installer with Inno Setup as `NM-Helper-Setup.exe`
4. **Artifacts**: Uploads build artifacts and creates GitHub releases automatically
5. **Dependencies**: Uses Flutter 3.32.6, Dart 3.8.1 with proper platform detection

### 🔧 Build Tools
- **Inno Setup**: Windows installer creation with custom icons and proper file associations
- **macOS Packaging**: Native `.app` bundle with minimum window constraints
- **Flutter Config**: Enables desktop platform support for both Windows and macOS
- **Version Sync**: Maintains consistent versioning across platforms and releases

## Session Summary
Transformed a basic calculator concept into a polished, professional Nuclear Medicine helper app with custom theming, comprehensive validation, cross-platform support, intuitive user experience, and complete CI/CD automation. Added Enter key support for enhanced usability and implemented robust build pipelines for seamless macOS and Windows releases.