import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar_rrule_generator/src/logic/rrule_parser.dart';
import 'package:calendar_rrule_generator/src/ui/sections/frequency_section.dart';
import 'package:calendar_rrule_generator/src/ui/sections/interval_section.dart';
import 'package:calendar_rrule_generator/src/ui/sections/weekdays_section.dart';
import 'package:calendar_rrule_generator/src/ui/sections/byhour_section.dart';
import 'package:calendar_rrule_generator/src/ui/sections/end_section.dart';
import 'package:calendar_rrule_generator/src/ui/sections/exclude_dates_section.dart';
import 'package:calendar_rrule_generator/src/ui/rrule_display.dart';
import 'package:calendar_rrule_generator/src/ui/rrule_localizations.dart';

/// A Flutter widget for visually creating iCalendar RRULE recurrence rules for calendar events
class RRuleGenerator extends StatefulWidget {
  /// Callback when the RRULE string is generated or changed
  final Function(String) onRRuleChanged;
  /// Initial RRULE string to parse and display (optional)
  final String? initialRRule;
  /// Start date of the event, used to determine default weekday for weekly recurrence
  final DateTime startDate;
  /// Localization strings for the UI
  final RRuleLocalizations localizations;

  const RRuleGenerator({
    super.key,
    required this.onRRuleChanged,
    this.initialRRule,
    required this.startDate,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  State<RRuleGenerator> createState() => _RRuleGeneratorState();
}

class _RRuleGeneratorState extends State<RRuleGenerator> {
  late RRuleParser _parser;
  late RRuleData _data;

  @override
  void initState() {
    super.initState();
    _parser = RRuleParser(widget.startDate);

    // Initialize with default values or parse initial rule
    if (widget.initialRRule != null && widget.initialRRule!.isNotEmpty) {
      _data = _parser.parse(widget.initialRRule!);
    } else {
      _data = RRuleData();
    }

    // Ensure weekday is set for weekly recurrence
    if (_data.frequency == 'WEEKLY' && _data.byday.isEmpty) {
      _data.byday = [_getWeekdayFromDate(widget.startDate)];
    }

    // Schedule callback after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateRRule();
    });
  }

  void _updateRRule() {
    final rrule = _parser.generate(_data);
    widget.onRRuleChanged(rrule);
  }

  String _getWeekdayFromDate(DateTime date) {
    const weekdays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.recurrenceTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Frequency
            FrequencySection(
              frequency: _data.frequency,
              localizations: localizations,
              onFrequencyChanged: (value) {
                setState(() {
                  _data.frequency = value;
                  // Reset weekdays when switching to weekly
                  if (_data.frequency == 'WEEKLY' && _data.byday.isEmpty) {
                    _data.byday = [_getWeekdayFromDate(widget.startDate)];
                  }
                  _updateRRule();
                });
              },
            ),
            const SizedBox(height: 20),

            // Interval
            IntervalSection(
              frequency: _data.frequency,
              interval: _data.interval,
              localizations: localizations,
              onIntervalChanged: (value) {
                setState(() {
                  _data.interval = value;
                  _updateRRule();
                });
              },
            ),

            // Weekdays for WEEKLY
            if (_data.frequency == 'WEEKLY') ...[
              const SizedBox(height: 20),
              WeekdaysSection(
                selectedWeekdays: _data.byday,
                localizations: localizations,
                onWeekdaysChanged: (value) {
                  setState(() {
                    _data.byday = value;
                    _updateRRule();
                  });
                },
              ),
            ],

            // Hours (BYHOUR) for DAILY, WEEKLY, MONTHLY, YEARLY
            if (_data.frequency != 'MINUTELY' && _data.frequency != 'HOURLY') ...[
              const SizedBox(height: 20),
              ByHourSection(
                useByHour: _data.byhour.isNotEmpty,
                selectedHours: _data.byhour,
                localizations: localizations,
                onUseByHourChanged: (value) {
                  setState(() {
                    if (!value) {
                      _data.byhour.clear();
                    }
                    _updateRRule();
                  });
                },
                onHoursChanged: (value) {
                  setState(() {
                    _data.byhour = value;
                    _updateRRule();
                  });
                },
              ),
            ],

            const SizedBox(height: 20),

            // End condition
            EndSection(
              endType: _data.endType,
              count: _data.count,
              until: _data.until,
              localizations: localizations,
              onEndTypeChanged: (value) {
                setState(() {
                  _data.endType = value;
                  _updateRRule();
                });
              },
              onCountChanged: (value) {
                setState(() {
                  _data.count = value;
                  _updateRRule();
                });
              },
              onUntilChanged: (value) {
                setState(() {
                  _data.until = value;
                  _updateRRule();
                });
              },
            ),

            const SizedBox(height: 20),

            // Excluded dates
            ExcludeDatesSection(
              excludedDates: _data.exdate,
              localizations: localizations,
              onExcludedDatesChanged: (value) {
                setState(() {
                  _data.exdate = value;
                  _updateRRule();
                });
              },
            ),

            const SizedBox(height: 20),

            // Result
            RRULEDisplay(
              rrule: _parser.generate(_data),
              localizations: localizations,
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal bottom sheet wrapper for RRuleGenerator
class RRuleGeneratorSheet extends StatefulWidget {
  /// Initial RRULE string to parse and display (optional)
  final String? initialRRule;
  /// Start date of the event, used to determine default weekday for weekly recurrence
  final DateTime startDate;
  /// Localization strings for the UI
  final RRuleLocalizations localizations;

  const RRuleGeneratorSheet({
    super.key,
    this.initialRRule,
    required this.startDate,
    this.localizations = RRuleLocalizations.english,
  });

  @override
  State<RRuleGeneratorSheet> createState() => _RRuleGeneratorSheetState();
}

class _RRuleGeneratorSheetState extends State<RRuleGeneratorSheet> {
  String _currentRRule = '';

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(localizations.cancelAction),
              ),
              Text(
                localizations.sheetTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_currentRRule);
                },
                child: Text(
                  localizations.applyAction,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: RRuleGenerator(
              initialRRule: widget.initialRRule,
              startDate: widget.startDate,
              localizations: localizations,
              onRRuleChanged: (rrule) {
                _currentRRule = rrule;
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Helper to show the RRule generator sheet
Future<String?> showRRuleGeneratorSheet(
  BuildContext context, {
  String? initialRRule,
  required DateTime startDate,
  RRuleLocalizations localizations = RRuleLocalizations.english,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => RRuleGeneratorSheet(
      initialRRule: initialRRule,
      startDate: startDate,
      localizations: localizations,
    ),
  );
}

/// Helper to parse RRULE and return human-readable description
String describeRRule(
  String? rrule, {
  RRuleLocalizations localizations = RRuleLocalizations.english,
}) {
  if (rrule == null || rrule.isEmpty) {
    return localizations.noRecurrence;
  }

  final parser = RRuleParser(DateTime.now());
  final data = parser.parse(rrule);

  String freqStr = '';
  switch (data.frequency) {
    case 'MINUTELY':
      freqStr = localizations.describeFrequency(data.frequency, data.interval);
      break;
    case 'HOURLY':
      freqStr = localizations.describeFrequency(data.frequency, data.interval);
      break;
    case 'DAILY':
      freqStr = localizations.describeFrequency(data.frequency, data.interval);
      break;
    case 'WEEKLY':
      freqStr = localizations.describeFrequency(data.frequency, data.interval);
      if (data.byday.isNotEmpty) {
        final dayNames = data.byday.map((d) {
          return localizations.weekdayShortLabel(d);
        }).join(', ');
        freqStr += ' ($dayNames)';
      }
      break;
    case 'MONTHLY':
      freqStr = localizations.describeFrequency(data.frequency, data.interval);
      break;
    case 'YEARLY':
      freqStr = localizations.describeFrequency(data.frequency, data.interval);
      break;
    default:
      return rrule;
  }

  // Add hour information.
  if (data.byhour.isNotEmpty) {
    data.byhour.sort();
    if (data.byhour.length <= 3) {
      final hoursStr = data.byhour.map((h) => '${h.toString().padLeft(2, '0')}:00').join(', ');
      freqStr += ' ${localizations.timeAtPrefix} $hoursStr';
    } else {
      freqStr += ' (${localizations.describeHourCount(data.byhour.length)})';
    }
  }

  if (data.endType == 'COUNT') {
    freqStr += ', ${localizations.describeCountOccurrences(data.count)}';
  } else if (data.endType == 'UNTIL') {
    freqStr +=
        ', ${localizations.describeUntilDate(DateFormat('dd.MM.yyyy').format(data.until))}';
  }

  return freqStr;
}
