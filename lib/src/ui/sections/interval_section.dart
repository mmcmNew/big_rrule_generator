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
class IntervalSection extends StatefulWidget {
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
  State<IntervalSection> createState() => _IntervalSectionState();
}

class _IntervalSectionState extends State<IntervalSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.interval.toString());
  }

  @override
  void didUpdateWidget(covariant IntervalSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextText = widget.interval.toString();
    if (_controller.text != nextText) {
      _controller.text = nextText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intervalLabel = widget.localizations.intervalUnitLabel(widget.frequency);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.localizations.intervalLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(widget.localizations.intervalEveryPrefix),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final intValue = int.tryParse(value) ?? 1;
                  if (intValue > 0) {
                    widget.onIntervalChanged(intValue);
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
