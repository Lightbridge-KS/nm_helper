import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../calc/change_calculator.dart';

class ChangeCalculatorScreen extends StatefulWidget {
  const ChangeCalculatorScreen({super.key});

  @override
  State<ChangeCalculatorScreen> createState() => _ChangeCalculatorScreenState();
}

class _ChangeCalculatorScreenState extends State<ChangeCalculatorScreen> {
  final _currentValueController = TextEditingController();
  final _previousValueController = TextEditingController();
  final _resultController = TextEditingController();
  String _errorMessage = '';

  double _parseInput(String input) {
    if (input.trim().isEmpty) {
      throw const FormatException('Input cannot be empty');
    }

    try {
      return double.parse(input.trim());
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
      final double current = _parseInput(_currentValueController.text);
      final double previous = _parseInput(_previousValueController.text);

      if (previous == 0) {
        throw const FormatException(
          'Previous value cannot be zero (division by zero)',
        );
      }

      final result = ChangeCalculator.change(
        current: current,
        previous: previous,
      );

      setState(() {
        _resultController.text = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('FormatException: ', '');
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
      _currentValueController.clear();
      _previousValueController.clear();
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
              Text('• Enter current value', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('• Enter previous value', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                '• % change = (current - previous) * 100 / previous',
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
          // Current Value
          TextField(
            controller: _currentValueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.trending_up),
              labelText: 'Current Value',
              hintText: 'Current value',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Previous Value
          TextField(
            controller: _previousValueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.history),
              labelText: 'Previous Value',
              hintText: 'Previous value',
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
    _currentValueController.dispose();
    _previousValueController.dispose();
    _resultController.dispose();
    super.dispose();
  }
}
