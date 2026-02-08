import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

class ByDayOrdinalSection extends StatefulWidget {
  final List<String> selectedOrdinals;
  final ValueChanged<List<String>> onOrdinalsChanged;
  final RRuleLocalizations localizations;

  const ByDayOrdinalSection({
    super.key,
    required this.selectedOrdinals,
    required this.onOrdinalsChanged,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  State<ByDayOrdinalSection> createState() => _ByDayOrdinalSectionState();
}

class _ByDayOrdinalSectionState extends State<ByDayOrdinalSection> {
  final List<int> _ordinals = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
  int _selectedOrdinal = 1;
  String _selectedWeekday = 'MO';

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.byDayOrdinalLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedOrdinal,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _ordinals
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOrdinal = value ?? 1;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedWeekday,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU']
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(localizations.weekdayShortLabel(value)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWeekday = value ?? 'MO';
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                final entry = '${_selectedOrdinal}${_selectedWeekday}';
                final updated = List<String>.from(widget.selectedOrdinals);
                if (!updated.contains(entry)) {
                  updated.add(entry);
                  widget.onOrdinalsChanged(updated);
                }
              },
              child: Text(localizations.byDayOrdinalAdd),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.selectedOrdinals.isEmpty)
          Text(
            localizations.byDayOrdinalEmpty,
            style: const TextStyle(color: Colors.grey),
          ),
        if (widget.selectedOrdinals.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedOrdinals.map((entry) {
              return Chip(
                label: Text(entry),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  final updated = List<String>.from(widget.selectedOrdinals);
                  updated.remove(entry);
                  widget.onOrdinalsChanged(updated);
                },
              );
            }).toList(),
          ),
      ],
    );
  }
}
