import 'package:flutter/material.dart';

/// Widget for selecting recurrence frequency
/// 
/// Provides a dropdown for selecting recurrence frequency
/// (e.g., daily, weekly, monthly) and handles user interactions.
/// 
/// Example usage:
/// ```dart
/// FrequencySection(
///   frequency: _frequency,
///   onFrequencyChanged: (value) {
///     setState(() {
///       _frequency = value;
///     });
///   },
/// )
/// ```
class FrequencySection extends StatelessWidget {
  final String frequency;
  final ValueChanged<String> onFrequencyChanged;
  
  const FrequencySection({
    super.key,
    required this.frequency,
    required this.onFrequencyChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Частота:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: frequency,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: const [
            DropdownMenuItem(value: 'MINUTELY', child: Text('Каждые N минут')),
            DropdownMenuItem(value: 'HOURLY', child: Text('Каждые N часов')),
            DropdownMenuItem(value: 'DAILY', child: Text('Ежедневно')),
            DropdownMenuItem(value: 'WEEKLY', child: Text('Еженедельно')),
            DropdownMenuItem(value: 'MONTHLY', child: Text('Ежемесячно')),
            DropdownMenuItem(value: 'YEARLY', child: Text('Ежегодно')),
          ],
          onChanged: (value) => onFrequencyChanged(value!),
        ),
      ],
    );
  }
}