import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../calc/spine_height_calculator.dart';

class SpineHeightCalculatorScreen extends StatefulWidget {
  const SpineHeightCalculatorScreen({super.key});

  @override
  State<SpineHeightCalculatorScreen> createState() =>
      _SpineHeightCalculatorScreenState();
}

class _SpineHeightCalculatorScreenState
    extends State<SpineHeightCalculatorScreen> {
  final _normalHeightController = TextEditingController();
  final _collapsedHeightController = TextEditingController();
  final _resultController = TextEditingController();
  String _errorMessage = '';

  List<double> _parseInput(String input) {
    if (input.trim().isEmpty) {
      throw const FormatException('Input cannot be empty');
    }

    final Pattern splitPattern = RegExp(r'[,\s]+');

    try {
      if (input.contains(splitPattern)) {
        return input
            .split(splitPattern)
            .map((s) => double.parse(s.trim()))
            .where((value) => value >= 0)
            .toList();
      } else {
        final value = double.parse(input.trim());
        if (value < 0) {
          throw const FormatException('Height cannot be negative');
        }
        return [value];
      }
    } catch (e) {
      throw const FormatException('Invalid number format');
    }
  }

  void _calculate() {
    setState(() {
      _resultController.clear();
      _errorMessage = '';
    });

    try {
      final List<double> normalValues = _parseInput(
        _normalHeightController.text,
      );
      final List<double> collapsedValues = _parseInput(
        _collapsedHeightController.text,
      );
      // Empty
      if (normalValues.isEmpty || collapsedValues.isEmpty) {
        throw const FormatException('Please enter valid height values');
      }

      // Check Negative Value
      final double normalSum = normalValues.fold(0.0, (a, b) => a + b);
      final double collapsedSum = collapsedValues.fold(0.0, (a, b) => a + b);

      if (normalSum < collapsedSum) {
        throw const FormatException(
          'Collapsed height must less than normal height',
        );
      }

      final result = SpineHeightCalculator.spineHtLoss(
        normalCm: normalValues,
        collapsedCm: collapsedValues,
      );

      setState(() {
        _resultController.text = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('FormatException: ', '');

        /// Uncomment if want to show Error message in SnackBar
        // if (mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(_errorMessage),
        //       backgroundColor: Colors.red.shade700,
        //       duration: const Duration(seconds: 3),
        //       behavior: SnackBarBehavior.floating,
        //     ),
        //   );
        // }
      });
    }
  }

  void _copyToClipboard() async {
    if (_resultController.text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: _resultController.text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _clearAll() {
    setState(() {
      _normalHeightController.clear();
      _collapsedHeightController.clear();
      _resultController.clear();
      _errorMessage = '';
    });
  }

  void _showUsageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'How to use',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Input height in centimeter (e.g. 10)',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Comma-separated value to calculate mean (e.g. 10, 12)',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Normal Height
          TextField(
            controller: _normalHeightController,
            keyboardType: TextInputType.number,
            onSubmitted: (value) => _calculate(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.sentiment_very_satisfied),
              labelText: 'Normal Height',
              hintText: 'Normal Height (cm)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Collapsed Height
          TextField(
            controller: _collapsedHeightController,
            keyboardType: TextInputType.number,
            onSubmitted: (value) => _calculate(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.sentiment_dissatisfied),
              labelText: 'Collapsed Height',
              hintText: 'Collapsed Height (cm)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Result TextField
          TextField(
            controller: _resultController,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Report',
              hintText: 'Calculation Report will appear here...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 16),
          // Button Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Generate', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _clearAll,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                child: const Text('Clear', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _showUsageDialog,
                icon: const Icon(Icons.info_outline),
                tooltip: 'How to use',
                iconSize: 18,
                color: Colors.grey,
              ),
              IconButton(
                onPressed: _resultController.text.isNotEmpty
                    ? _copyToClipboard
                    : null,
                icon: const Icon(Icons.copy),
                tooltip: 'Copy Report',
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Error Message
          if (_errorMessage.isNotEmpty)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _normalHeightController.dispose();
    _collapsedHeightController.dispose();
    _resultController.dispose();
    super.dispose();
  }
}
