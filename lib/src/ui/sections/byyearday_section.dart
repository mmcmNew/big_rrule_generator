import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';
import 'package:big_rrule_generator/src/ui/sections/number_list_section.dart';

class ByYearDaySection extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onDaysChanged;
  final RRuleLocalizations localizations;

  const ByYearDaySection({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  Widget build(BuildContext context) {
    return NumberListSection(
      label: localizations.byYearDayLabel,
      hint: localizations.byYearDayHint,
      values: selectedDays,
      onChanged: onDaysChanged,
      allowNegative: true,
    );
  }
}
