import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

class WeekStartSection extends StatelessWidget {
  final String weekStart;
  final ValueChanged<String> onWeekStartChanged;
  final RRuleLocalizations localizations;

  const WeekStartSection({
    super.key,
    required this.weekStart,
    required this.onWeekStartChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  Widget build(BuildContext context) {
    const weekdays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.weekStartLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: weekStart,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: weekdays
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(localizations.weekdayShortLabel(value)),
                ),
              )
              .toList(),
          onChanged: (value) => onWeekStartChanged(value ?? 'MO'),
        ),
        const SizedBox(height: 4),
        Text(
          localizations.weekStartHint,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
