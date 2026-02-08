import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

/// Widget for selecting specific hours for recurrence
/// 
/// Provides controls for selecting specific hours of the day for recurrence patterns,
/// with preset options for common scenarios.
/// 
/// Example usage:
/// ```dart
/// ByHourSection(
///   useByHour: _useByHour,
///   selectedHours: _selectedHours,
///   onUseByHourChanged: (value) {
///     setState(() {
///       _useByHour = value;
///     });
///   },
///   onHoursChanged: (value) {
///     setState(() {
///       _selectedHours = value;
///     });
///   },
/// )
/// ```
class ByHourSection extends StatelessWidget {
  final bool useByHour;
  final List<int> selectedHours;
  final ValueChanged<bool> onUseByHourChanged;
  final ValueChanged<List<int>> onHoursChanged;
  final RRuleLocalizations localizations;
  
  const ByHourSection({
    super.key,
    required this.useByHour,
    required this.selectedHours,
    required this.onUseByHourChanged,
    required this.onHoursChanged,
    this.localizations = RRuleLocalizations.english,
  });
  
  @override
  Widget build(BuildContext context) {
    // Hours from 0 to 23.
    final hours = List.generate(24, (i) => i);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: useByHour,
              onChanged: (value) => onUseByHourChanged(value!),
            ),
            Text(
              localizations.byHourLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (useByHour) ...[
          const SizedBox(height: 8),
          Text(
            localizations.byHourHint,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: hours.map((hour) {
              final isSelected = selectedHours.contains(hour);
              return FilterChip(
                label: Text(
                  '${hour.toString().padLeft(2, '0')}:00',
                  style: const TextStyle(fontSize: 11),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  final updated = List<int>.from(selectedHours);
                  if (selected) {
                    updated.add(hour);
                  } else {
                    updated.remove(hour);
                  }
                  onHoursChanged(updated);
                },
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Quick presets.
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: Text(
                  localizations.byHourPresetWorkday,
                  style: const TextStyle(fontSize: 11),
                ),
                onPressed: () {
                  onHoursChanged([9, 10, 11, 12, 13, 14, 15, 16, 17, 18]);
                },
              ),
              ActionChip(
                label: Text(
                  localizations.byHourPresetMorning,
                  style: const TextStyle(fontSize: 11),
                ),
                onPressed: () {
                  onHoursChanged([6, 7, 8, 9, 10, 11, 12]);
                },
              ),
              ActionChip(
                label: Text(
                  localizations.byHourPresetEveryTwoHours,
                  style: const TextStyle(fontSize: 11),
                ),
                onPressed: () {
                  onHoursChanged([0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22]);
                },
              ),
              ActionChip(
                label: Text(
                  localizations.byHourPresetReset,
                  style: const TextStyle(fontSize: 11),
                ),
                onPressed: () {
                  onHoursChanged([]);
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}
