import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

/// Widget for selecting recurrence interval
/// 
/// Provides controls for setting the recurrence interval
/// (e.g., every 2 days, every 3 weeks) based on the selected frequency.
/// 
/// Example usage:
/// ```dart
/// IntervalSection(
///   frequency: _frequency,
///   interval: _interval,
///   onIntervalChanged: (value) {
///     setState(() {
///       _interval = value;
///     });
///   },
/// )
/// ```
class IntervalSection extends StatelessWidget {
  final String frequency;
  final int interval;
  final ValueChanged<int> onIntervalChanged;
  final RRuleLocalizations localizations;
  
  const IntervalSection({
    super.key,
    required this.frequency,
    required this.interval,
    required this.onIntervalChanged,
    this.localizations = RRuleLocalizations.english,
  });
  
  @override
  Widget build(BuildContext context) {
    final intervalLabel = localizations.intervalUnitLabel(frequency);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.intervalLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(localizations.intervalEveryPrefix),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: interval.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final intValue = int.tryParse(value) ?? 1;
                  if (intValue > 0) {
                    onIntervalChanged(intValue);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(intervalLabel),
          ],
        ),
      ],
    );
  }
}
