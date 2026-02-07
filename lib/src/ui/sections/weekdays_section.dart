import 'package:flutter/material.dart';

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
  
  const WeekdaysSection({
    super.key,
    required this.selectedWeekdays,
    required this.onWeekdaysChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final weekdays = [
      {'value': 'MO', 'label': 'Пн'},
      {'value': 'TU', 'label': 'Вт'},
      {'value': 'WE', 'label': 'Ср'},
      {'value': 'TH', 'label': 'Чт'},
      {'value': 'FR', 'label': 'Пт'},
      {'value': 'SA', 'label': 'Сб'},
      {'value': 'SU', 'label': 'Вс'},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Дни недели:', style: TextStyle(fontWeight: FontWeight.bold)),
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