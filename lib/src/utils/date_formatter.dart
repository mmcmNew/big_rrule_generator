import 'package:intl/intl.dart';

/// Helper class for formatting dates in RRULE format
/// 
/// Contains helper functions for formatting dates according to RFC 5545
/// specifications for iCalendar RRULE strings.
/// 
/// Example usage:
/// ```dart
/// final formatted = DateFormatter.formatExDate(DateTime(2026, 1, 15));
/// print(formatted); // 20260115
/// 
/// final formattedWithTime = DateFormatter.formatExDate(DateTime(2026, 1, 15, 14, 30));
/// print(formattedWithTime); // 20260115T143000Z
/// 
/// final display = DateFormatter.formatForDisplay(DateTime(2026, 1, 15, 14, 30));
/// print(display); // 15.01.2026 14:30
/// ```
class DateFormatter {
  /// Formats date for EXDATE (RFC 5545: YYYYMMDDThhmmssZ or YYYYMMDD)
  static String formatExDate(DateTime date) {
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
  
  /// Formats EXDATE for display to user
  static String formatForDisplay(DateTime date) {
    // If time is not specified (00:00:00), show date only
    if (date.hour == 0 && date.minute == 0 && date.second == 0) {
      return DateFormat('dd.MM.yyyy').format(date);
    }
    // Show date and time
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }
}