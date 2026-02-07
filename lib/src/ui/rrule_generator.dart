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

/// A Flutter widget for visually creating iCalendar RRULE recurrence rules for calendar events
class RRuleGenerator extends StatefulWidget {
  /// Callback when the RRULE string is generated or changed
  final Function(String) onRRuleChanged;
  /// Initial RRULE string to parse and display (optional)
  final String? initialRRule;
  /// Start date of the event, used to determine default weekday for weekly recurrence
  final DateTime startDate;

  const RRuleGenerator({
    super.key,
    required this.onRRuleChanged,
    this.initialRRule,
    required this.startDate,
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Настройка повторения',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Частота
            FrequencySection(
              frequency: _data.frequency,
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

            // Интервал
            IntervalSection(
              frequency: _data.frequency,
              interval: _data.interval,
              onIntervalChanged: (value) {
                setState(() {
                  _data.interval = value;
                  _updateRRule();
                });
              },
            ),

            // Дни недели для WEEKLY
            if (_data.frequency == 'WEEKLY') ...[
              const SizedBox(height: 20),
              WeekdaysSection(
                selectedWeekdays: _data.byday,
                onWeekdaysChanged: (value) {
                  setState(() {
                    _data.byday = value;
                    _updateRRule();
                  });
                },
              ),
            ],

            // Часы дня (BYHOUR) - для DAILY, WEEKLY, MONTHLY, YEARLY
            if (_data.frequency != 'MINUTELY' && _data.frequency != 'HOURLY') ...[
              const SizedBox(height: 20),
              ByHourSection(
                useByHour: _data.byhour.isNotEmpty,
                selectedHours: _data.byhour,
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

            // Окончание
            EndSection(
              endType: _data.endType,
              count: _data.count,
              until: _data.until,
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

            // Исключенные даты
            ExcludeDatesSection(
              excludedDates: _data.exdate,
              onExcludedDatesChanged: (value) {
                setState(() {
                  _data.exdate = value;
                  _updateRRule();
                });
              },
            ),

            const SizedBox(height: 20),

            // Результат
            RRULEDisplay(rrule: _parser.generate(_data)),
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

  const RRuleGeneratorSheet({
    super.key,
    this.initialRRule,
    required this.startDate,
  });

  @override
  State<RRuleGeneratorSheet> createState() => _RRuleGeneratorSheetState();
}

class _RRuleGeneratorSheetState extends State<RRuleGeneratorSheet> {
  String _currentRRule = '';

  @override
  Widget build(BuildContext context) {
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
                child: const Text('Отмена'),
              ),
              Text(
                'Настройка повторений',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_currentRRule);
                },
                child: const Text(
                  'Применить',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
    ),
  );
}

/// Helper to parse RRULE and return human-readable description
String describeRRule(String? rrule) {
  if (rrule == null || rrule.isEmpty) {
    return 'Без повторения';
  }

  final parser = RRuleParser(DateTime.now());
  final data = parser.parse(rrule);

  String freqStr = '';
  switch (data.frequency) {
    case 'MINUTELY':
      freqStr = data.interval == 1 ? 'Каждую минуту' : 'Каждые ${data.interval} мин.';
      break;
    case 'HOURLY':
      freqStr = data.interval == 1 ? 'Каждый час' : 'Каждые ${data.interval} ч.';
      break;
    case 'DAILY':
      freqStr = data.interval == 1 ? 'Ежедневно' : 'Каждые ${data.interval} дн.';
      break;
    case 'WEEKLY':
      freqStr = data.interval == 1 ? 'Еженедельно' : 'Каждые ${data.interval} нед.';
      if (data.byday.isNotEmpty) {
        final dayNames = data.byday.map((d) {
          switch (d) {
            case 'MO': return 'Пн';
            case 'TU': return 'Вт';
            case 'WE': return 'Ср';
            case 'TH': return 'Чт';
            case 'FR': return 'Пт';
            case 'SA': return 'Сб';
            case 'SU': return 'Вс';
            default: return d;
          }
        }).join(', ');
        freqStr += ' ($dayNames)';
      }
      break;
    case 'MONTHLY':
      freqStr = data.interval == 1 ? 'Ежемесячно' : 'Каждые ${data.interval} мес.';
      break;
    case 'YEARLY':
      freqStr = data.interval == 1 ? 'Ежегодно' : 'Каждые ${data.interval} г.';
      break;
    default:
      return rrule;
  }

  // Добавляем информацию о часах
  if (data.byhour.isNotEmpty) {
    data.byhour.sort();
    if (data.byhour.length <= 3) {
      final hoursStr = data.byhour.map((h) => '${h.toString().padLeft(2, '0')}:00').join(', ');
      freqStr += ' в $hoursStr';
    } else {
      freqStr += ' (${data.byhour.length} часов)';
    }
  }

  if (data.endType == 'COUNT') {
    freqStr += ', ${data.count} раз';
  } else if (data.endType == 'UNTIL') {
    freqStr += ', до ${DateFormat('dd.MM.yyyy').format(data.until)}';
  }

  return freqStr;
}
