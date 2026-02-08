import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

/// Widget for selecting weekdays for weekly recurrence
/// 
/// Provides a set of filter chips for selecting days of the week
/// for weekly recurrence patterns.
/// 
/// Example usage:
/// ```dart
/// WeekdaysSection(
///   selectedWeekdays: _selectedWeekdays,
///   onWeekdaysChanged: (value) {
///     setState(() {
///       _selectedWeekdays = value;
///     });
///   },
/// )
/// ```
class WeekdaysSection extends StatelessWidget {
  final List<String> selectedWeekdays;
  final ValueChanged<List<String>> onWeekdaysChanged;
  final RRuleLocalizations localizations;
  
  const WeekdaysSection({
    super.key,
    required this.selectedWeekdays,
    required this.onWeekdaysChanged,
    this.localizations = RRuleLocalizations.english,
  });
  
  @override
  Widget build(BuildContext context) {
    final weekdays = [
      {'value': 'MO', 'label': localizations.weekdayShortLabel('MO')},
      {'value': 'TU', 'label': localizations.weekdayShortLabel('TU')},
      {'value': 'WE', 'label': localizations.weekdayShortLabel('WE')},
      {'value': 'TH', 'label': localizations.weekdayShortLabel('TH')},
      {'value': 'FR', 'label': localizations.weekdayShortLabel('FR')},
      {'value': 'SA', 'label': localizations.weekdayShortLabel('SA')},
      {'value': 'SU', 'label': localizations.weekdayShortLabel('SU')},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.weekdaysLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: weekdays.map((day) {
            final isSelected = selectedWeekdays.contains(day['value']);
            return FilterChip(
              label: Text(day['label']!),
              selected: isSelected,
              onSelected: (selected) {
                final updated = List<String>.from(selectedWeekdays);
                if (selected) {
                  updated.add(day['value']!);
                } else {
                  updated.remove(day['value']);
                }
                onWeekdaysChanged(updated);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
