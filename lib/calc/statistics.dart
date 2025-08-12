import 'dart:math';

class Statistics {
  /// Round to decimal places
  static double roundToDecimals(double value, int places) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  /// Calculate Mean
  static double calculateMean(List<double> numbers) {
    if (numbers.isEmpty) return 0.0; // Handle empty list

    double sum = numbers.reduce((a, b) => a + b);
    return sum / numbers.length;
  }
}
