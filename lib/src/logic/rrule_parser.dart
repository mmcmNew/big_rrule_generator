import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Data class representing RRULE components
class RRuleData {
  String frequency;
  int interval;
  String endType;
  int count;
  DateTime until;
  List<String> byday;
  List<int> byhour;
  List<DateTime> exdate;
  
  RRuleData({
    this.frequency = 'DAILY',
    this.interval = 1,
    this.endType = 'NEVER',
    this.count = 10,
    DateTime? until,
    List<String>? byday,
    List<int>? byhour,
    List<DateTime>? exdate,
  })  : until = until ?? DateTime.now().add(const Duration(days: 30)),
       byday = byday ?? [],
       byhour = byhour ?? [],
       exdate = exdate ?? [];
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
        data.byday = part.substring(6).split(',');
      } else if (part.startsWith('BYHOUR=')) {
        data.byhour = part.substring(7).split(',').map(int.parse).toList();
      } else if (part.startsWith('EXDATE:')) {
        final exDateStr = part.substring(7);
        final dates = exDateStr.split(',');
        for (var d in dates) {
          try {
            final date = _parseExDateValue(d.trim());
            if (date != null) {
              data.exdate.add(date);
            }
          } catch (e) {
            debugPrint('Error parsing exDate: $d');
          }
        }
      }
    }
    
    // If weekly and no BYDAY set, use start date's weekday
    if (data.frequency == 'WEEKLY' && data.byday.isEmpty) {
      data.byday = [_getWeekdayFromDate(startDate)];
    }
    
    return data;
  }
  
  /// Generates RRULE string from structured data
  String generate(RRuleData data) {
    List<String> parts = [];
    
    parts.add('FREQ=${data.frequency}');
    
    if (data.interval > 1) {
      parts.add('INTERVAL=${data.interval}');
    }
    
    // Дни недели - обязательно для WEEKLY
    if (data.frequency == 'WEEKLY') {
      if (data.byday.isEmpty) {
        data.byday = [_getWeekdayFromDate(startDate)];
      }
      parts.add('BYDAY=${data.byday.join(',')}');
    }
    
    if (data.frequency == 'MONTHLY') {
      parts.add('BYMONTHDAY=${startDate.day}');
    }
    
    if (data.frequency == 'YEARLY') {
      parts.add('BYMONTH=${startDate.month}');
      parts.add('BYMONTHDAY=${startDate.day}');
    }
    
    // Часы для внутридневного повторения (не для MINUTELY/HOURLY)
    if (data.byhour.isNotEmpty && data.frequency != 'MINUTELY' && data.frequency != 'HOURLY') {
      data.byhour.sort();
      parts.add('BYHOUR=${data.byhour.join(',')}');
    }
    
    // Окончание правила
    if (data.endType == 'COUNT') {
      parts.add('COUNT=${data.count}');
    } else if (data.endType == 'UNTIL') {
      final formatted = DateFormat('yyyyMMdd').format(data.until);
      parts.add('UNTIL=${formatted}T235959Z');
    }
    
    // Исключенные даты (с точным временем если есть)
    if (data.exdate.isNotEmpty) {
      data.exdate.sort((a, b) => a.compareTo(b));
      final exDatesStr = data.exdate
          .map((d) => _formatExDate(d))
          .join(',');
      parts.add('EXDATE:$exDatesStr');
    }
    
    return parts.join(';');
  }
  
  /// Converts DateTime to weekday abbreviation (MO, TU, WE, TH, FR, SA, SU)
  String _getWeekdayFromDate(DateTime date) {
    const weekdays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return weekdays[date.weekday - 1];
  }
  
  /// Parses a single date from EXDATE (with or without time)
  DateTime? _parseExDateValue(String value) {
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
  
  /// Formats date for EXDATE (RFC 5545: YYYYMMDDThhmmssZ or YYYYMMDD)
  String _formatExDate(DateTime date) {
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
}