import 'package:flutter/material.dart';
import 'package:calendar_rrule_generator/src/utils/date_formatter.dart';

/// Widget for managing excluded dates in recurrence
/// 
/// Provides controls for adding and removing specific dates
/// that should be excluded from the recurrence pattern.
/// 
/// Example usage:
/// ```dart
/// ExcludeDatesSection(
///   excludedDates: _exDates,
///   onExcludedDatesChanged: (value) {
///     setState(() {
///       _exDates = value;
///     });
///   },
/// )
/// ```
class ExcludeDatesSection extends StatefulWidget {
  final List<DateTime> excludedDates;
  final ValueChanged<List<DateTime>> onExcludedDatesChanged;
  
  const ExcludeDatesSection({
    super.key,
    required this.excludedDates,
    required this.onExcludedDatesChanged,
  });
  
  @override
  State<ExcludeDatesSection> createState() => _ExcludeDatesSectionState();
}

class _ExcludeDatesSectionState extends State<ExcludeDatesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Исключенные даты:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Добавить'),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null && !widget.excludedDates.contains(date)) {
                  final updated = List<DateTime>.from(widget.excludedDates);
                  updated.add(date);
                  widget.onExcludedDatesChanged(updated);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.excludedDates.isEmpty)
          const Text('Нет исключенных дат',
              style: TextStyle(color: Colors.grey)),
        if (widget.excludedDates.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.excludedDates.map((date) {
              return Chip(
                label: Text(DateFormatter.formatForDisplay(date)),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  final updated = List<DateTime>.from(widget.excludedDates);
                  updated.remove(date);
                  widget.onExcludedDatesChanged(updated);
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}