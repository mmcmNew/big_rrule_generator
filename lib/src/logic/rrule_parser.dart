import 'dart:developer' as developer;
import 'package:intl/intl.dart';

/// Data class representing RRULE components
class RRuleData {
  String frequency;
  int interval;
  String endType;
  int count;
  DateTime until;
  List<String> byday;
  List<String> bydayOrdinal;
  String weekStart;
  List<int> bysecond;
  List<int> byminute;
  List<int> byhour;
  List<int> bymonth;
  List<int> bymonthday;
  List<int> byyearday;
  List<int> byweekno;
  List<int> bysetpos;
  List<DateTime> exdate;
  List<DateTime> rdate;
  
  RRuleData({
    this.frequency = 'DAILY',
    this.interval = 1,
    this.endType = 'NEVER',
    this.count = 10,
    DateTime? until,
    List<String>? byday,
    List<String>? bydayOrdinal,
    this.weekStart = 'MO',
    List<int>? bysecond,
    List<int>? byminute,
    List<int>? byhour,
    List<int>? bymonth,
    List<int>? bymonthday,
    List<int>? byyearday,
    List<int>? byweekno,
    List<int>? bysetpos,
    List<DateTime>? exdate,
    List<DateTime>? rdate,
  })  : until = until ?? DateTime.now().add(const Duration(days: 30)),
       byday = byday ?? [],
       bydayOrdinal = bydayOrdinal ?? [],
       bysecond = bysecond ?? [],
       byminute = byminute ?? [],
       byhour = byhour ?? [],
       bymonth = bymonth ?? [],
       bymonthday = bymonthday ?? [],
       byyearday = byyearday ?? [],
       byweekno = byweekno ?? [],
       bysetpos = bysetpos ?? [],
       exdate = exdate ?? [],
       rdate = rdate ?? [];
}

class RRuleSet {
  final String rrule;
  final List<DateTime> exdate;
  final List<DateTime> rdate;

  const RRuleSet({
    required this.rrule,
    required this.exdate,
    required this.rdate,
  });

  String toRRuleSetString() {
    final lines = <String>['RRULE:$rrule'];
    if (exdate.isNotEmpty) {
      final formatted = exdate
          .map(_formatDateValue)
          .join(',');
      lines.add('EXDATE:$formatted');
    }
    if (rdate.isNotEmpty) {
      final formatted = rdate
          .map(_formatDateValue)
          .join(',');
      lines.add('RDATE:$formatted');
    }
    return lines.join('\n');
  }
}

class RRuleResult {
  final String rrule;
  final RRuleSet rruleSet;

  const RRuleResult({
    required this.rrule,
    required this.rruleSet,
  });
}

/// Parser and generator for iCalendar RRULE strings
/// 
/// Provides functionality to parse and generate RRULE strings according to RFC 5545.
/// 
/// Example usage:
/// ```dart
/// final parser = RRuleParser(DateTime(2026, 1, 15));
/// final rule = parser.parse('FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR');
/// print(rule.frequency); // WEEKLY
/// print(rule.interval); // 2
/// print(rule.byday); // [MO, WE, FR]
/// 
/// final rrule = parser.generate(rule);
/// print(rrule); // FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR
/// ```
class RRuleParser {
  final DateTime startDate;
  
  RRuleParser(this.startDate);
  
  /// Parses RRULE string into structured data
  RRuleData parse(String rrule) {
    final data = RRuleData(until: DateTime.now().add(const Duration(days: 30)));
    
    final parts = rrule.split(';');
    for (var part in parts) {
      if (part.startsWith('FREQ=')) {
        data.frequency = part.substring(5);
      } else if (part.startsWith('INTERVAL=')) {
        data.interval = int.parse(part.substring(9));
      } else if (part.startsWith('COUNT=')) {
        data.endType = 'COUNT';
        data.count = int.parse(part.substring(6));
      } else if (part.startsWith('UNTIL=')) {
        data.endType = 'UNTIL';
        final untilStr = part.substring(6).split('T')[0];
        final year = int.parse(untilStr.substring(0, 4));
        final month = int.parse(untilStr.substring(4, 6));
        final day = int.parse(untilStr.substring(6, 8));
        data.until = DateTime(year, month, day);
      } else if (part.startsWith('BYDAY=')) {
        final values = part.substring(6).split(',').map((entry) => entry.trim());
        for (final entry in values) {
          if (RegExp(r'^[+-]?\\d').hasMatch(entry)) {
            data.bydayOrdinal.add(entry);
          } else {
            data.byday.add(entry);
          }
        }
      } else if (part.startsWith('BYSECOND=')) {
        data.bysecond = _parseIntList(part.substring(9));
      } else if (part.startsWith('BYMINUTE=')) {
        data.byminute = _parseIntList(part.substring(9));
      } else if (part.startsWith('BYHOUR=')) {
        data.byhour = _parseIntList(part.substring(7));
      } else if (part.startsWith('BYMONTH=')) {
        data.bymonth = _parseIntList(part.substring(8));
      } else if (part.startsWith('BYMONTHDAY=')) {
        data.bymonthday = _parseIntList(part.substring(11));
      } else if (part.startsWith('BYYEARDAY=')) {
        data.byyearday = _parseIntList(part.substring(10));
      } else if (part.startsWith('BYWEEKNO=')) {
        data.byweekno = _parseIntList(part.substring(9));
      } else if (part.startsWith('BYSETPOS=')) {
        data.bysetpos = _parseIntList(part.substring(9));
      } else if (part.startsWith('WKST=')) {
        data.weekStart = part.substring(5);
      } else if (part.startsWith('EXDATE:')) {
        data.exdate.addAll(_parseDateList(part.substring(7)));
      } else if (part.startsWith('RDATE:')) {
        data.rdate.addAll(_parseDateList(part.substring(6)));
      }
    }
    
    // If weekly and no BYDAY set, use start date's weekday
    if (data.frequency == 'WEEKLY' && data.byday.isEmpty) {
      data.byday = [_getWeekdayFromDate(startDate)];
    }
    
    return data;
  }
  
  /// Generates RRULE string from structured data
  String generate(RRuleData data, {bool includeExDate = true}) {
    List<String> parts = [];
    
    parts.add('FREQ=${data.frequency}');
    
    if (data.interval > 1) {
      parts.add('INTERVAL=${data.interval}');
    }
    
    // Weekdays are required for WEEKLY rules.
    if (data.frequency == 'WEEKLY') {
      if (data.byday.isEmpty) {
        data.byday = [_getWeekdayFromDate(startDate)];
      }
      parts.add('BYDAY=${data.byday.join(',')}');
    }

    if (data.bydayOrdinal.isNotEmpty && data.frequency != 'WEEKLY') {
      parts.add('BYDAY=${data.bydayOrdinal.join(',')}');
    }

    if (data.bysecond.isNotEmpty) {
      data.bysecond.sort();
      parts.add('BYSECOND=${data.bysecond.join(',')}');
    }

    if (data.byminute.isNotEmpty) {
      data.byminute.sort();
      parts.add('BYMINUTE=${data.byminute.join(',')}');
    }

    // Hours for intra-day recurrence (not for MINUTELY/HOURLY).
    if (data.byhour.isNotEmpty) {
      data.byhour.sort();
      parts.add('BYHOUR=${data.byhour.join(',')}');
    }

    if (data.bymonth.isNotEmpty) {
      data.bymonth.sort();
      parts.add('BYMONTH=${data.bymonth.join(',')}');
    }

    if (data.bymonthday.isNotEmpty) {
      data.bymonthday.sort();
      parts.add('BYMONTHDAY=${data.bymonthday.join(',')}');
    }

    if (data.byyearday.isNotEmpty) {
      data.byyearday.sort();
      parts.add('BYYEARDAY=${data.byyearday.join(',')}');
    }

    if (data.byweekno.isNotEmpty) {
      data.byweekno.sort();
      parts.add('BYWEEKNO=${data.byweekno.join(',')}');
    }

    if (data.bysetpos.isNotEmpty) {
      data.bysetpos.sort();
      parts.add('BYSETPOS=${data.bysetpos.join(',')}');
    }

    if (data.weekStart.isNotEmpty) {
      parts.add('WKST=${data.weekStart}');
    }

    if (data.frequency == 'MONTHLY') {
      if (data.bymonthday.isEmpty && data.bydayOrdinal.isEmpty) {
        parts.add('BYMONTHDAY=${startDate.day}');
      }
    }

    if (data.frequency == 'YEARLY') {
      final hasYearlySelector = data.bymonth.isNotEmpty ||
          data.bymonthday.isNotEmpty ||
          data.bydayOrdinal.isNotEmpty ||
          data.byweekno.isNotEmpty ||
          data.byyearday.isNotEmpty;
      if (!hasYearlySelector) {
        parts.add('BYMONTH=${startDate.month}');
        parts.add('BYMONTHDAY=${startDate.day}');
      }
    }
    
    // Rule ending.
    if (data.endType == 'COUNT') {
      parts.add('COUNT=${data.count}');
    } else if (data.endType == 'UNTIL') {
      final formatted = DateFormat('yyyyMMdd').format(data.until);
      parts.add('UNTIL=${formatted}T235959Z');
    }
    
    // Excluded dates (with exact time if present).
    if (includeExDate && data.exdate.isNotEmpty) {
      data.exdate.sort((a, b) => a.compareTo(b));
      final exDatesStr = data.exdate
          .map((d) => _formatDateValue(d))
          .join(',');
      parts.add('EXDATE:$exDatesStr');
    }
    
    return parts.join(';');
  }

  RRuleSet generateSet(RRuleData data) {
    final rrule = generate(data, includeExDate: false);
    final exDates = List<DateTime>.from(data.exdate)..sort();
    final rDates = List<DateTime>.from(data.rdate)..sort();
    return RRuleSet(rrule: rrule, exdate: exDates, rdate: rDates);
  }
  
  /// Converts DateTime to weekday abbreviation (MO, TU, WE, TH, FR, SA, SU)
  String _getWeekdayFromDate(DateTime date) {
    const weekdays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return weekdays[date.weekday - 1];
  }
  
  List<DateTime> _parseDateList(String value) {
    final dates = value.split(',');
    final parsed = <DateTime>[];
    for (var d in dates) {
      try {
        final date = _parseDateValue(d.trim());
        if (date != null) {
          parsed.add(date);
        }
      } catch (e) {
        developer.log('Error parsing date value: $d', name: 'RRuleParser');
      }
    }
    return parsed;
  }

  /// Parses a single date from EXDATE/RDATE (with or without time)
  DateTime? _parseDateValue(String value) {
    // Formats: 20260115 or 20260115T120000 or 20260115T120000Z
    if (value.length < 8) return null;
    
    try {
      final year = int.parse(value.substring(0, 4));
      final month = int.parse(value.substring(4, 6));
      final day = int.parse(value.substring(6, 8));
      
      // Check if time is present (T)
      if (value.contains('T') && value.length >= 15) {
        final hour = int.parse(value.substring(9, 11));
        final minute = int.parse(value.substring(11, 13));
        final second = int.parse(value.substring(13, 15));
        
        // If string ends with Z, it's UTC time
        if (value.endsWith('Z')) {
          return DateTime.utc(year, month, day, hour, minute, second);
        } else {
          return DateTime(year, month, day, hour, minute, second);
        }
      }
      
      // Date only, no time
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}

List<int> _parseIntList(String value) {
  return value
      .split(',')
      .map((entry) => entry.trim())
      .where((entry) => entry.isNotEmpty)
      .map(int.parse)
      .toList();
}

/// Formats date for EXDATE/RDATE (RFC 5545: YYYYMMDDThhmmssZ or YYYYMMDD)
String _formatDateValue(DateTime date) {
  // If time is not specified (00:00:00), format date only
  if (date.hour == 0 && date.minute == 0 && date.second == 0) {
    return DateFormat('yyyyMMdd').format(date);
  }

  // Convert to UTC for time format
  final utc = date.toUtc();
  final year = utc.year.toString().padLeft(4, '0');
  final month = utc.month.toString().padLeft(2, '0');
  final day = utc.day.toString().padLeft(2, '0');
  final hour = utc.hour.toString().padLeft(2, '0');
  final minute = utc.minute.toString().padLeft(2, '0');
  final second = utc.second.toString().padLeft(2, '0');
  // Format with exact time: YYYYMMDDThhmmssZ
  return '$year$month${day}T$hour$minute${second}Z';
}
