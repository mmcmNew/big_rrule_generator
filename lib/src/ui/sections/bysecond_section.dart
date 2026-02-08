import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';
import 'package:big_rrule_generator/src/ui/sections/number_list_section.dart';

class BySecondSection extends StatelessWidget {
  final List<int> selectedSeconds;
  final ValueChanged<List<int>> onSecondsChanged;
  final RRuleLocalizations localizations;

  const BySecondSection({
    super.key,
    required this.selectedSeconds,
    required this.onSecondsChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  Widget build(BuildContext context) {
    return NumberListSection(
      label: localizations.bySecondLabel,
      hint: localizations.bySecondHint,
      values: selectedSeconds,
      onChanged: onSecondsChanged,
      allowNegative: false,
    );
  }
}
