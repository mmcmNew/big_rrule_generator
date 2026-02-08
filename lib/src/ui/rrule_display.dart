import 'package:flutter/material.dart';
import 'package:calendar_rrule_generator/src/ui/rrule_localizations.dart';

/// Widget for displaying the generated RRULE string
/// 
/// Shows the current RRULE string in a formatted, selectable
/// text field for easy copying by the user.
/// 
/// Example usage:
/// ```dart
/// RRULEDisplay(
///   rrule: _currentRRule,
/// )
/// ```
class RRULEDisplay extends StatelessWidget {
  final String rrule;
  final RRuleLocalizations localizations;
  
  const RRULEDisplay({
    super.key,
    required this.rrule,
    this.localizations = RRuleLocalizations.english,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.resultLabel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(
            rrule,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
