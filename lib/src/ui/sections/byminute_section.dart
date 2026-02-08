import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';
import 'package:big_rrule_generator/src/ui/sections/number_list_section.dart';

class ByMinuteSection extends StatelessWidget {
  final List<int> selectedMinutes;
  final ValueChanged<List<int>> onMinutesChanged;
  final RRuleLocalizations localizations;

  const ByMinuteSection({
    super.key,
    required this.selectedMinutes,
    required this.onMinutesChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  Widget build(BuildContext context) {
    return NumberListSection(
      label: localizations.byMinuteLabel,
      hint: localizations.byMinuteHint,
      values: selectedMinutes,
      onChanged: onMinutesChanged,
      allowNegative: false,
    );
  }
}
