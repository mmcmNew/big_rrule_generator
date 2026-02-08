import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

class ByMonthSection extends StatelessWidget {
  final List<int> selectedMonths;
  final ValueChanged<List<int>> onMonthsChanged;
  final RRuleLocalizations localizations;

  const ByMonthSection({
    super.key,
    required this.selectedMonths,
    required this.onMonthsChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (index) => index + 1);
    final monthLabels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.byMonthLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          localizations.byMonthHint,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: months.map((month) {
            final isSelected = selectedMonths.contains(month);
            return FilterChip(
              label: Text(monthLabels[month - 1]),
              selected: isSelected,
              onSelected: (selected) {
                final updated = List<int>.from(selectedMonths);
                if (selected) {
                  updated.add(month);
                } else {
                  updated.remove(month);
                }
                onMonthsChanged(updated);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
