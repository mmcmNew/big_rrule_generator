import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/utils/date_formatter.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

class IncludeDatesSection extends StatefulWidget {
  final List<DateTime> includedDates;
  final ValueChanged<List<DateTime>> onIncludedDatesChanged;
  final RRuleLocalizations localizations;

  const IncludeDatesSection({
    super.key,
    required this.includedDates,
    required this.onIncludedDatesChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  State<IncludeDatesSection> createState() => _IncludeDatesSectionState();
}

class _IncludeDatesSectionState extends State<IncludeDatesSection> {
  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.includeDatesLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(localizations.includeDatesAdd),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (date != null && !widget.includedDates.contains(date)) {
                  final updated = List<DateTime>.from(widget.includedDates);
                  updated.add(date);
                  widget.onIncludedDatesChanged(updated);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.includedDates.isEmpty)
          Text(
            localizations.includeDatesEmpty,
            style: const TextStyle(color: Colors.grey),
          ),
        if (widget.includedDates.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.includedDates.map((date) {
              return Chip(
                label: Text(DateFormatter.formatForDisplay(date)),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  final updated = List<DateTime>.from(widget.includedDates);
                  updated.remove(date);
                  widget.onIncludedDatesChanged(updated);
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}
