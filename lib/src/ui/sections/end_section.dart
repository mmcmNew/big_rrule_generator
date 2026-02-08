import 'package:flutter/material.dart';
import 'package:big_rrule_generator/src/utils/date_formatter.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

/// Widget for selecting end condition of recurrence
/// 
/// Provides controls for setting when the recurrence should end:
/// never, after a certain number of occurrences, or until a specific date.
class EndSection extends StatefulWidget {
  final String endType;
  final int count;
  final DateTime until;
  final ValueChanged<String> onEndTypeChanged;
  final ValueChanged<int> onCountChanged;
  final ValueChanged<DateTime> onUntilChanged;
  final RRuleLocalizations localizations;
  
  const EndSection({
    super.key,
    required this.endType,
    required this.count,
    required this.until,
    required this.onEndTypeChanged,
    required this.onCountChanged,
    required this.onUntilChanged,
    this.localizations = RRuleLocalizations.english,
  });
  
  @override
  State<EndSection> createState() => _EndSectionState();
}

class _EndSectionState extends State<EndSection> {
  late DateTime _currentUntil;
  
  @override
  void initState() {
    super.initState();
    _currentUntil = widget.until;
  }
  
  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.endLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        ListTile(
          leading: Radio<String>(
            value: 'NEVER',
            groupValue: widget.endType,
            onChanged: (value) => widget.onEndTypeChanged(value!),
          ),
          title: Text(localizations.endNever),
          onTap: () => widget.onEndTypeChanged('NEVER'),
        ),
        
        ListTile(
          leading: Radio<String>(
            value: 'COUNT',
            groupValue: widget.endType,
            onChanged: (value) => widget.onEndTypeChanged(value!),
          ),
          title: Row(
            children: [
              Text(localizations.endAfter),
              const SizedBox(width: 12),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: widget.count.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  enabled: widget.endType == 'COUNT',
                  onChanged: (value) {
                    final intValue = int.tryParse(value) ?? 1;
                    if (intValue > 0) {
                      widget.onCountChanged(intValue);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Text(localizations.endOccurrences),
            ],
          ),
          onTap: () => widget.onEndTypeChanged('COUNT'),
        ),
        
        ListTile(
          leading: Radio<String>(
            value: 'UNTIL',
            groupValue: widget.endType,
            onChanged: (value) => widget.onEndTypeChanged(value!),
          ),
          title: Row(
            children: [
              Text(localizations.endUntilDate),
              const SizedBox(width: 12),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(DateFormatter.formatForDisplay(_currentUntil).split(' ')[0]),
                onPressed: widget.endType == 'UNTIL'
                    ? () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _currentUntil,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        );
                        if (date != null) {
                          setState(() {
                            _currentUntil = date;
                          });
                          widget.onUntilChanged(date);
                        }
                      }
                    : null,
              ),
            ],
          ),
          onTap: () => widget.onEndTypeChanged('UNTIL'),
        ),
      ],
    );
  }
}
