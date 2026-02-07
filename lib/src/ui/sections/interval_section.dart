import 'package:flutter/material.dart';

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
  
  const IntervalSection({
    super.key,
    required this.frequency,
    required this.interval,
    required this.onIntervalChanged,
  });
  
  String _getIntervalLabel(String frequency) {
    switch (frequency) {
      case 'MINUTELY':
        return 'минут';
      case 'HOURLY':
        return 'часов';
      case 'DAILY':
        return 'дней';
      case 'WEEKLY':
        return 'недель';
      case 'MONTHLY':
        return 'месяцев';
      case 'YEARLY':
        return 'лет';
      default:
        return 'единиц';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final intervalLabel = _getIntervalLabel(frequency);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Интервал:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Каждые'),
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