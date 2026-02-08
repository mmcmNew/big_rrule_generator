import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';
import 'package:big_rrule_generator/src/ui/sections/number_list_section.dart';

class ByMonthDaySection extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onDaysChanged;
  final RRuleLocalizations localizations;

  const ByMonthDaySection({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  Widget build(BuildContext context) {
    return NumberListSection(
      label: localizations.byMonthDayLabel,
      hint: localizations.byMonthDayHint,
      values: selectedDays,
      onChanged: onDaysChanged,
      allowNegative: true,
    );
  }
}
