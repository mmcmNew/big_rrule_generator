/// A Flutter widget for visually creating iCalendar RRULE recurrence rules.
///
/// This library provides widgets and utilities for generating, parsing,
/// and displaying iCalendar RRULE recurrence rules according to RFC 5545.
library;

// Logic
export 'src/logic/rrule_parser.dart';

// Utils
export 'src/utils/date_formatter.dart';

// UI - Main widgets
export 'src/ui/rrule_generator.dart';
export 'src/ui/rrule_display.dart';
export 'src/ui/rrule_localizations.dart';

// UI - Sections
export 'src/ui/sections/frequency_section.dart';
export 'src/ui/sections/interval_section.dart';
export 'src/ui/sections/weekdays_section.dart';
export 'src/ui/sections/byhour_section.dart';
export 'src/ui/sections/byminute_section.dart';
export 'src/ui/sections/bysecond_section.dart';
export 'src/ui/sections/bymonth_section.dart';
export 'src/ui/sections/bymonthday_section.dart';
export 'src/ui/sections/byyearday_section.dart';
export 'src/ui/sections/byweekno_section.dart';
export 'src/ui/sections/bysetpos_section.dart';
export 'src/ui/sections/byday_ordinal_section.dart';
export 'src/ui/sections/week_start_section.dart';
export 'src/ui/sections/end_section.dart';
export 'src/ui/sections/exclude_dates_section.dart';
export 'src/ui/sections/include_dates_section.dart';
export 'src/ui/sections/number_list_section.dart';
