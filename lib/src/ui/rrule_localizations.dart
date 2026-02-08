/// Localization strings and helpers for the RRULE generator UI.
class RRuleLocalizations {
  final String recurrenceTitle;
  final String sheetTitle;
  final String cancelAction;
  final String applyAction;
  final String frequencyLabel;
  final String intervalLabel;
  final String intervalEveryPrefix;
  final String weekdaysLabel;
  final String byHourLabel;
  final String byHourHint;
  final String byHourPresetWorkday;
  final String byHourPresetMorning;
  final String byHourPresetEveryTwoHours;
  final String byHourPresetReset;
  final String byMinuteLabel;
  final String byMinuteHint;
  final String bySecondLabel;
  final String bySecondHint;
  final String byMonthLabel;
  final String byMonthHint;
  final String byMonthDayLabel;
  final String byMonthDayHint;
  final String byYearDayLabel;
  final String byYearDayHint;
  final String byWeekNoLabel;
  final String byWeekNoHint;
  final String bySetPosLabel;
  final String bySetPosHint;
  final String weekStartLabel;
  final String weekStartHint;
  final String byDayOrdinalLabel;
  final String byDayOrdinalAdd;
  final String byDayOrdinalEmpty;
  final String includeDatesLabel;
  final String includeDatesAdd;
  final String includeDatesEmpty;
  final String advancedOptionsLabel;
  final String advancedOptionsHint;
  final String endLabel;
  final String endNever;
  final String endAfter;
  final String endOccurrences;
  final String endUntilDate;
  final String excludeDatesLabel;
  final String excludeDatesAdd;
  final String excludeDatesEmpty;
  final String resultLabel;
  final String noRecurrence;
  final String hoursSuffix;
  final String timeAtPrefix;
  final String untilPrefix;
  final Map<String, String> weekdayShortLabels;

  const RRuleLocalizations({
    required this.recurrenceTitle,
    required this.sheetTitle,
    required this.cancelAction,
    required this.applyAction,
    required this.frequencyLabel,
    required this.intervalLabel,
    required this.intervalEveryPrefix,
    required this.weekdaysLabel,
    required this.byHourLabel,
    required this.byHourHint,
    required this.byHourPresetWorkday,
    required this.byHourPresetMorning,
    required this.byHourPresetEveryTwoHours,
    required this.byHourPresetReset,
    required this.byMinuteLabel,
    required this.byMinuteHint,
    required this.bySecondLabel,
    required this.bySecondHint,
    required this.byMonthLabel,
    required this.byMonthHint,
    required this.byMonthDayLabel,
    required this.byMonthDayHint,
    required this.byYearDayLabel,
    required this.byYearDayHint,
    required this.byWeekNoLabel,
    required this.byWeekNoHint,
    required this.bySetPosLabel,
    required this.bySetPosHint,
    required this.weekStartLabel,
    required this.weekStartHint,
    required this.byDayOrdinalLabel,
    required this.byDayOrdinalAdd,
    required this.byDayOrdinalEmpty,
    required this.includeDatesLabel,
    required this.includeDatesAdd,
    required this.includeDatesEmpty,
    required this.advancedOptionsLabel,
    required this.advancedOptionsHint,
    required this.endLabel,
    required this.endNever,
    required this.endAfter,
    required this.endOccurrences,
    required this.endUntilDate,
    required this.excludeDatesLabel,
    required this.excludeDatesAdd,
    required this.excludeDatesEmpty,
    required this.resultLabel,
    required this.noRecurrence,
    required this.hoursSuffix,
    required this.timeAtPrefix,
    required this.untilPrefix,
    required this.weekdayShortLabels,
  });

  static const RRuleLocalizations english = RRuleLocalizations(
    recurrenceTitle: 'Recurrence settings',
    sheetTitle: 'Recurrence settings',
    cancelAction: 'Cancel',
    applyAction: 'Apply',
    frequencyLabel: 'Frequency:',
    intervalLabel: 'Interval:',
    intervalEveryPrefix: 'Every',
    weekdaysLabel: 'Weekdays:',
    byHourLabel: 'Repeat at specific hours',
    byHourHint: 'Select hours:',
    byHourPresetWorkday: 'Workday (9-18)',
    byHourPresetMorning: 'Morning (6-12)',
    byHourPresetEveryTwoHours: 'Every 2h',
    byHourPresetReset: 'Reset',
    byMinuteLabel: 'Repeat at specific minutes',
    byMinuteHint: 'Comma-separated minutes (0-59)',
    bySecondLabel: 'Repeat at specific seconds',
    bySecondHint: 'Comma-separated seconds (0-59)',
    byMonthLabel: 'Months',
    byMonthHint: 'Select months',
    byMonthDayLabel: 'Month days',
    byMonthDayHint: 'Comma-separated days (1-31 or -1..-31)',
    byYearDayLabel: 'Year days',
    byYearDayHint: 'Comma-separated days (1-366 or -1..-366)',
    byWeekNoLabel: 'Week numbers',
    byWeekNoHint: 'Comma-separated weeks (1-53 or -1..-53)',
    bySetPosLabel: 'Set positions',
    bySetPosHint: 'Comma-separated positions (1,2,-1)',
    weekStartLabel: 'Week starts on',
    weekStartHint: 'Choose week start day',
    byDayOrdinalLabel: 'Ordinal weekdays',
    byDayOrdinalAdd: 'Add ordinal weekday',
    byDayOrdinalEmpty: 'No ordinal weekdays',
    includeDatesLabel: 'Included dates:',
    includeDatesAdd: 'Add',
    includeDatesEmpty: 'No included dates',
    advancedOptionsLabel: 'Advanced options',
    advancedOptionsHint: 'Additional RRULE options',
    endLabel: 'Ends:',
    endNever: 'Never',
    endAfter: 'After',
    endOccurrences: 'occurrences',
    endUntilDate: 'Until date:',
    excludeDatesLabel: 'Excluded dates:',
    excludeDatesAdd: 'Add',
    excludeDatesEmpty: 'No excluded dates',
    resultLabel: 'RRULE result:',
    noRecurrence: 'No recurrence',
    hoursSuffix: 'hours',
    timeAtPrefix: 'at',
    untilPrefix: 'until',
    weekdayShortLabels: {
      'MO': 'Mon',
      'TU': 'Tue',
      'WE': 'Wed',
      'TH': 'Thu',
      'FR': 'Fri',
      'SA': 'Sat',
      'SU': 'Sun',
    },
  );

  String weekdayShortLabel(String value) => weekdayShortLabels[value] ?? value;

  String frequencyOptionLabel(String frequency) {
    switch (frequency) {
      case 'MINUTELY':
        return 'Every N minutes';
      case 'HOURLY':
        return 'Every N hours';
      case 'DAILY':
        return 'Daily';
      case 'WEEKLY':
        return 'Weekly';
      case 'MONTHLY':
        return 'Monthly';
      case 'YEARLY':
        return 'Yearly';
      case 'SECONDLY':
        return 'Every N seconds';
      default:
        return frequency;
    }
  }

  String intervalUnitLabel(String frequency) {
    switch (frequency) {
      case 'MINUTELY':
        return 'minutes';
      case 'HOURLY':
        return 'hours';
      case 'DAILY':
        return 'days';
      case 'WEEKLY':
        return 'weeks';
      case 'MONTHLY':
        return 'months';
      case 'YEARLY':
        return 'years';
      case 'SECONDLY':
        return 'seconds';
      default:
        return 'units';
    }
  }

  String describeFrequency(String frequency, int interval) {
    switch (frequency) {
      case 'MINUTELY':
        return interval == 1 ? 'Every minute' : 'Every $interval minutes';
      case 'HOURLY':
        return interval == 1 ? 'Every hour' : 'Every $interval hours';
      case 'DAILY':
        return interval == 1 ? 'Daily' : 'Every $interval days';
      case 'WEEKLY':
        return interval == 1 ? 'Weekly' : 'Every $interval weeks';
      case 'MONTHLY':
        return interval == 1 ? 'Monthly' : 'Every $interval months';
      case 'YEARLY':
        return interval == 1 ? 'Yearly' : 'Every $interval years';
      case 'SECONDLY':
        return interval == 1 ? 'Every second' : 'Every $interval seconds';
      default:
        return frequency;
    }
  }

  String describeHourCount(int count) => '$count $hoursSuffix';

  String describeCountOccurrences(int count) => '$count ${endOccurrences}';

  String describeUntilDate(String formattedDate) => '$untilPrefix $formattedDate';
}
