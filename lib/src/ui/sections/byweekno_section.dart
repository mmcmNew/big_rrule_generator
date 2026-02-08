import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';
import 'package:big_rrule_generator/src/ui/sections/number_list_section.dart';

class ByWeekNoSection extends StatelessWidget {
  final List<int> selectedWeeks;
  final ValueChanged<List<int>> onWeeksChanged;
  final RRuleLocalizations localizations;

  const ByWeekNoSection({
    super.key,
    required this.selectedWeeks,
    required this.onWeeksChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  Widget build(BuildContext context) {
    return NumberListSection(
      label: localizations.byWeekNoLabel,
      hint: localizations.byWeekNoHint,
      values: selectedWeeks,
      onChanged: onWeeksChanged,
      allowNegative: true,
    );
  }
}
