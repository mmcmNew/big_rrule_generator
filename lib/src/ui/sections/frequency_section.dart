import 'package:flutter/material.dart';
import 'package:calendar_rrule_generator/src/ui/rrule_localizations.dart';

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
  final RRuleLocalizations localizations;
  
  const FrequencySection({
    super.key,
    required this.frequency,
    required this.onFrequencyChanged,
    this.localizations = RRuleLocalizations.english,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.frequencyLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: frequency,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            DropdownMenuItem(
              value: 'MINUTELY',
              child: Text(localizations.frequencyOptionLabel('MINUTELY')),
            ),
            DropdownMenuItem(
              value: 'HOURLY',
              child: Text(localizations.frequencyOptionLabel('HOURLY')),
            ),
            DropdownMenuItem(
              value: 'DAILY',
              child: Text(localizations.frequencyOptionLabel('DAILY')),
            ),
            DropdownMenuItem(
              value: 'WEEKLY',
              child: Text(localizations.frequencyOptionLabel('WEEKLY')),
            ),
            DropdownMenuItem(
              value: 'MONTHLY',
              child: Text(localizations.frequencyOptionLabel('MONTHLY')),
            ),
            DropdownMenuItem(
              value: 'YEARLY',
              child: Text(localizations.frequencyOptionLabel('YEARLY')),
            ),
          ],
          onChanged: (value) => onFrequencyChanged(value!),
        ),
      ],
    );
  }
}
