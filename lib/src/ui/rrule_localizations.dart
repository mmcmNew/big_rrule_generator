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
      default:
        return frequency;
    }
  }

  String describeHourCount(int count) => '$count $hoursSuffix';

  String describeCountOccurrences(int count) => '$count ${endOccurrences}';

  String describeUntilDate(String formattedDate) => '$untilPrefix $formattedDate';
}
