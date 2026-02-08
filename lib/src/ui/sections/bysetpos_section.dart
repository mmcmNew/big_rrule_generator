import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';
import 'package:big_rrule_generator/src/ui/sections/number_list_section.dart';

class BySetPosSection extends StatelessWidget {
  final List<int> selectedPositions;
  final ValueChanged<List<int>> onPositionsChanged;
  final RRuleLocalizations localizations;

  const BySetPosSection({
    super.key,
    required this.selectedPositions,
    required this.onPositionsChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  Widget build(BuildContext context) {
    return NumberListSection(
      label: localizations.bySetPosLabel,
      hint: localizations.bySetPosHint,
      values: selectedPositions,
      onChanged: onPositionsChanged,
      allowNegative: true,
    );
  }
}
