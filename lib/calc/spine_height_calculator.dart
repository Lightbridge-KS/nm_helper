import 'statistics.dart' show Statistics;

class SpineHeightCalculator {

  /// Spine Height Loss Main Calculation Logic
  /// 
  /// [normalCm] Normal spine height in centimeter
  /// [collapsedCm] Collapsed spine height in centimeter
  /// 
  /// Return formatted report string 
  static String spineHtLoss({required List<double> normalCm, required List<double> collapsedCm}) {

    // Normal or Collapsed Height Display Text
    final normalDisp = _toNumberOrMean(normalCm);
    final collapsedDisp = _toNumberOrMean(collapsedCm);

    // Calculate Mean of Normal or Collapsed Height
    final normalCmMean = Statistics.calculateMean(normalCm);
    final collapsedCmMean = Statistics.calculateMean(collapsedCm);

    // Height Loss Fraction and Diagnosis
    final double lossFrac = ( normalCmMean - collapsedCmMean ) * 100 / normalCmMean;
    final diagnosis = _spineHtLossDx(lossFrac);

    return """Height loss: ${Statistics.roundToDecimals(lossFrac, 1)} % ($diagnosis)
- Normal Ht (cm): $normalDisp
- Collapsed Ht (cm): $collapsedDisp""";

  }

  /// Calculate Spine Height Loss Diagnosis
  static String _spineHtLossDx(double lossFrac) {
    final String diagnosis;

    if (lossFrac < 0) {
      throw FormatException();
    }

    if (lossFrac < 0.2) {
      diagnosis = "less than mild";
    } else if (lossFrac < 0.25) {
      diagnosis = "mild";
    } else if (lossFrac == 0.25) {
      diagnosis = "mild to moderate";
    } else if (lossFrac < 0.4) {
      diagnosis = "moderate";
    } else if (lossFrac == 0.4) {
      diagnosis = "moderate to severe";
    } else {
      diagnosis = "severe";
    }

    return diagnosis;
  }

  static String _toNumberOrMean(List<double> x) {

    if(x.length > 1) {

      final xBar = Statistics.calculateMean(x);
      final vals = x.join(", ");
      return "$vals (mean = ${Statistics.roundToDecimals(xBar, 1)})";

    } else {
      return x[0].toString();
    }
  }


}


/// Testing

// void main() {
//   print(SpineHeightCalculator.spineHtLoss(normalCm: [5], collapsedCm: [3, 4]));

//   print(Statistics.calculateMean([2]));
//   print(Statistics.calculateMean([1, 2]));
//   print(Statistics.roundToDecimals(3.2446, 2));
// }
