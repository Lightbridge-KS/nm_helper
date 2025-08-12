import "statistics.dart" show Statistics;

class ChangeCalculator {
  static String change({required double current, required double previous}) {
    final double ch = current - previous;
    final double percentChange = (ch / previous) * 100;
    return """Change: ${Statistics.roundToDecimals(percentChange, 1)} %
Delta: ${Statistics.roundToDecimals(ch, 3)}""";
  }
}

// void main() {
//   print(ChangeCalculator.change(current: 4, previous: 3));
// }