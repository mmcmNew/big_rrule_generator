import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:big_rrule_generator/src/logic/rrule_parser.dart';
import 'package:big_rrule_generator/src/ui/sections/frequency_section.dart';
import 'package:big_rrule_generator/src/ui/sections/interval_section.dart';
import 'package:big_rrule_generator/src/ui/sections/weekdays_section.dart';
import 'package:big_rrule_generator/src/ui/sections/byhour_section.dart';
import 'package:big_rrule_generator/src/ui/sections/end_section.dart';
import 'package:big_rrule_generator/src/ui/sections/exclude_dates_section.dart';
import 'package:big_rrule_generator/src/ui/sections/include_dates_section.dart';
import 'package:big_rrule_generator/src/ui/sections/byminute_section.dart';
import 'package:big_rrule_generator/src/ui/sections/bysecond_section.dart';
import 'package:big_rrule_generator/src/ui/sections/bymonth_section.dart';
import 'package:big_rrule_generator/src/ui/sections/bymonthday_section.dart';
import 'package:big_rrule_generator/src/ui/sections/byyearday_section.dart';
import 'package:big_rrule_generator/src/ui/sections/byweekno_section.dart';
import 'package:big_rrule_generator/src/ui/sections/bysetpos_section.dart';
import 'package:big_rrule_generator/src/ui/sections/byday_ordinal_section.dart';
import 'package:big_rrule_generator/src/ui/sections/week_start_section.dart';
import 'package:big_rrule_generator/src/ui/rrule_display.dart';
import 'package:big_rrule_generator/src/ui/rrule_localizations.dart';

/// A Flutter widget for visually creating iCalendar RRULE recurrence rules for calendar events
class RRuleGenerator extends StatefulWidget {
  /// Callback when the RRULE string/set is generated or changed
  final ValueChanged<RRuleResult> onRRuleChanged;
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
  bool _useByHour = false;

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
    _useByHour = _data.byhour.isNotEmpty;

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
    final rruleSet = _parser.generateSet(_data);
    widget.onRRuleChanged(RRuleResult(rrule: rrule, rruleSet: rruleSet));
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

            const SizedBox(height: 20),
            ByHourSection(
              useByHour: _useByHour,
              selectedHours: _data.byhour,
              localizations: localizations,
              onUseByHourChanged: (value) {
                setState(() {
                  _useByHour = value;
                  if (!value) {
                    _data.byhour.clear();
                  }
                  _updateRRule();
                });
              },
              onHoursChanged: (value) {
                setState(() {
                  _data.byhour = value;
                  if (value.isNotEmpty) {
                    _useByHour = true;
                  }
                  _updateRRule();
                });
              },
            ),

            const SizedBox(height: 20),
            ByMinuteSection(
              selectedMinutes: _data.byminute,
              localizations: localizations,
              onMinutesChanged: (value) {
                setState(() {
                  _data.byminute = value;
                  _updateRRule();
                });
              },
            ),

            const SizedBox(height: 20),
            BySecondSection(
              selectedSeconds: _data.bysecond,
              localizations: localizations,
              onSecondsChanged: (value) {
                setState(() {
                  _data.bysecond = value;
                  _updateRRule();
                });
              },
            ),

            if (_data.frequency == 'MONTHLY' || _data.frequency == 'YEARLY') ...[
              const SizedBox(height: 20),
              ByMonthDaySection(
                selectedDays: _data.bymonthday,
                localizations: localizations,
                onDaysChanged: (value) {
                  setState(() {
                    _data.bymonthday = value;
                    _updateRRule();
                  });
                },
              ),
              const SizedBox(height: 20),
              ByDayOrdinalSection(
                selectedOrdinals: _data.bydayOrdinal,
                localizations: localizations,
                onOrdinalsChanged: (value) {
                  setState(() {
                    _data.bydayOrdinal = value;
                    _updateRRule();
                  });
                },
              ),
            ],

            if (_data.frequency == 'YEARLY') ...[
              const SizedBox(height: 20),
              ByMonthSection(
                selectedMonths: _data.bymonth,
                localizations: localizations,
                onMonthsChanged: (value) {
                  setState(() {
                    _data.bymonth = value;
                    _updateRRule();
                  });
                },
              ),
              const SizedBox(height: 20),
              ByYearDaySection(
                selectedDays: _data.byyearday,
                localizations: localizations,
                onDaysChanged: (value) {
                  setState(() {
                    _data.byyearday = value;
                    _updateRRule();
                  });
                },
              ),
              const SizedBox(height: 20),
              ByWeekNoSection(
                selectedWeeks: _data.byweekno,
                localizations: localizations,
                onWeeksChanged: (value) {
                  setState(() {
                    _data.byweekno = value;
                    _updateRRule();
                  });
                },
              ),
            ],

            const SizedBox(height: 20),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                localizations.advancedOptionsLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                localizations.advancedOptionsHint,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              children: [
                const SizedBox(height: 12),
                WeekStartSection(
                  weekStart: _data.weekStart,
                  localizations: localizations,
                  onWeekStartChanged: (value) {
                    setState(() {
                      _data.weekStart = value;
                      _updateRRule();
                    });
                  },
                ),
                const SizedBox(height: 20),
                BySetPosSection(
                  selectedPositions: _data.bysetpos,
                  localizations: localizations,
                  onPositionsChanged: (value) {
                    setState(() {
                      _data.bysetpos = value;
                      _updateRRule();
                    });
                  },
                ),
              ],
            ),

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

            // Included dates (RDATE)
            IncludeDatesSection(
              includedDates: _data.rdate,
              localizations: localizations,
              onIncludedDatesChanged: (value) {
                setState(() {
                  _data.rdate = value;
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
  RRuleResult? _currentResult;

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
                  Navigator.of(context).pop(_currentResult);
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
              onRRuleChanged: (result) {
                _currentResult = result;
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Helper to show the RRule generator sheet
Future<RRuleResult?> showRRuleGeneratorSheet(
  BuildContext context, {
  String? initialRRule,
  required DateTime startDate,
  RRuleLocalizations localizations = RRuleLocalizations.english,
}) {
  return showModalBottomSheet<RRuleResult>(
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

  String describeOrdinalWeekday(String value) {
    final match = RegExp(r'^([+-]?\\d+)([A-Z]{2})$').firstMatch(value);
    if (match == null) {
      return value;
    }
    final ordinal = int.tryParse(match.group(1) ?? '');
    final weekday = match.group(2) ?? '';
    if (ordinal == null) {
      return value;
    }
    final ordinalText = localizations.describeOrdinal(ordinal);
    final weekdayText = localizations.weekdayShortLabel(weekday);
    return '$ordinalText $weekdayText';
  }

  String describeIntList(List<int> values) {
    final sorted = List<int>.from(values)..sort();
    return sorted.join(', ');
  }

  String freqStr = '';
  switch (data.frequency) {
    case 'MINUTELY':
      freqStr = localizations.describeFrequency(data.frequency, data.interval);
      break;
    case 'SECONDLY':
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

  final details = <String>[];

  if (data.byday.isNotEmpty && data.frequency != 'WEEKLY') {
    final dayNames = data.byday.map((d) => localizations.weekdayShortLabel(d)).join(', ');
    details.add('${localizations.weekdaysPrefix} $dayNames');
  }

  if (data.bydayOrdinal.isNotEmpty) {
    final ordinals = data.bydayOrdinal.map(describeOrdinalWeekday).join(', ');
    details.add('${localizations.ordinalWeekdaysPrefix} $ordinals');
  }

  if (data.bymonth.isNotEmpty) {
    details.add('${localizations.monthsPrefix} ${describeIntList(data.bymonth)}');
  }

  if (data.bymonthday.isNotEmpty) {
    details.add('${localizations.monthDaysPrefix} ${describeIntList(data.bymonthday)}');
  }

  if (data.byyearday.isNotEmpty) {
    details.add('${localizations.yearDaysPrefix} ${describeIntList(data.byyearday)}');
  }

  if (data.byweekno.isNotEmpty) {
    details.add('${localizations.weekNumbersPrefix} ${describeIntList(data.byweekno)}');
  }

  if (data.bysetpos.isNotEmpty) {
    details.add('${localizations.setPositionsPrefix} ${describeIntList(data.bysetpos)}');
  }

  if (data.byminute.isNotEmpty) {
    details.add('${localizations.minutesPrefix} ${describeIntList(data.byminute)}');
  }

  if (data.bysecond.isNotEmpty) {
    details.add('${localizations.secondsPrefix} ${describeIntList(data.bysecond)}');
  }

  if (data.weekStart.isNotEmpty && data.weekStart != 'MO') {
    details.add(
      '${localizations.weekStartPrefix} ${localizations.weekdayShortLabel(data.weekStart)}',
    );
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

  if (details.isNotEmpty) {
    freqStr += ' (${details.join('; ')})';
  }

  if (data.endType == 'COUNT') {
    freqStr += ', ${localizations.describeCountOccurrences(data.count)}';
  } else if (data.endType == 'UNTIL') {
    freqStr +=
        ', ${localizations.describeUntilDate(DateFormat('dd.MM.yyyy').format(data.until))}';
  }

  return freqStr;
}
